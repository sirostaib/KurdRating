//
//  DownloadsVC.swift
//  KurdRating
//
//  Created by Siros Taib on 3/27/24.
//

import UIKit

class DownloadsVC: UIViewController {
    
    private var titles: [TitleItem] = [TitleItem]()
    
    private let downloadsTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Downloads"
        view.addSubview(downloadsTable)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        downloadsTable.delegate = self
        downloadsTable.dataSource = self
        fetchLocalStorageForDownload()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("success_downloaded"), object: nil, queue: nil) { _ in
           self.fetchLocalStorageForDownload()
        }
    }
    
    private func fetchLocalStorageForDownload(){
        print("hereee")
        DataPersistenceManager.shared.fetchingTitlesFromDataBase {[weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async { [weak self] in
                    self?.downloadsTable.reloadData()
                }
                
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadsTable.frame = view.bounds
    }
}

extension DownloadsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return titles.count
       }
       
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
           guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
               return UITableViewCell()
           }
           
           let title = titles[indexPath.row]
           cell.configure(with: TitleViewModel(titleName: (title.original_title ?? title.original_name) ?? "Unknown title name", posterURL: title.poster_path ?? ""))
           return cell
       }
       
       
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 140
       }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            switch editingStyle {
            case .delete:
                
                DataPersistenceManager.shared.deleteTitleWith(model: titles[indexPath.row]) { [weak self] result in
                    switch result {
                    case .success():
                        print("Deleted fromt the database")
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    self?.titles.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            default:
                break;
            }
        }
       
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           tableView.deselectRow(at: indexPath, animated: true)
           
           let title = titles[indexPath.row]
           
           guard let titleName = title.original_title ?? title.original_name else {
               return
           }
           
           
           APICaller.shared.getMovie(with: titleName) { [weak self] result in
               switch result {
               case .success(let videoElement):
                   DispatchQueue.main.async {
                       let vc = TitlePreviewViewController()
                       vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? ""))
                       self?.navigationController?.pushViewController(vc, animated: true)
                   }

                   
               case .failure(let error):
                   print(error.localizedDescription)
               }
           }
       }
}
