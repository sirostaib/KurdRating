//
//  HomeVC.swift
//  KurdRating
//
//  Created by Siros Taib on 3/27/24.
//

import UIKit

enum Sections: Int {
    case TrendingMovies = 0
    case TrendingSeries = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

class HomeVC: UIViewController {
    
    private var randomTrendingMovie: Title?
    
    private var headerView: HeroHeaderUIView?
    
    let sectionTitles = [
        "Trending Movies", "Trending TV Series", "Popular", "Upcoming Movies", "Top Rated"
    ]
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))
        homeFeedTable.tableHeaderView = headerView
        
        
        configureNavBar()
        configureHeroHeaderView()
    }
    
    private func configureHeroHeaderView(){
        APICaller.shared.getTrendingMovies { [weak self] result in
            switch result {
            case .success(let title):
                let selectedTitle = title.randomElement()
                self?.randomTrendingMovie = selectedTitle
                self?.headerView?.configure(with: TitleViewModel(titleName: selectedTitle?.original_title ?? selectedTitle?.original_name ?? "", posterURL: selectedTitle?.poster_path ?? "") )
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
    private func configureNavBar(){
        
        let image  = UIImage(named: "kr-logo")?
            .withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            .resizeTo(size: CGSize(width: 70, height: 45))
        
        
        
        let googleButton = UIButton()
        googleButton.setBackgroundImage(image, for: .normal)
        googleButton.frame = CGRect(x: 0, y: 0, width: 10, height: 25)
        let googleBarButton = UIBarButtonItem(customView: googleButton)
        
        
      //  navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
//        navigationItem.setLeftBarButtonItems([
//            UIBarButtonItem(image: image, style: .done, target: self, action: nil),
//            UIBarButtonItem(image: image, style: .done, target: self, action: nil)
//        ], animated: true)
        navigationItem.leftBarButtonItem = googleBarButton
        
        let user = UIImage(systemName: "person.circle.fill") //?.withTintColor(.label, renderingMode: .alwaysOriginal)
        let play = UIImage(systemName: "play.rectangle") // ?.withTintColor(.label, renderingMode: .alwaysOriginal)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: user, style: .done, target: self, action: nil),
            UIBarButtonItem(image: play, style: .done, target: self, action: nil),
        ]
        
        navigationController?.navigationBar.tintColor = .label
        navigationController?.hidesBarsOnSwipe = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    
    
    }

extension UIImage {
    func resizeTo(size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { _ in
            self.draw(in: CGRect.init(origin: CGPoint.zero, size: size))
        }
        
        return image.withRenderingMode(self.renderingMode)
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        
        switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            APICaller.shared.getTrendingMovies{ results in
                switch results{
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
        case Sections.TrendingSeries.rawValue:
            APICaller.shared.getTrendingSeries{ results in
                switch results{
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
//        case Sections.Popular.rawValue:
//        case Sections.Upcoming.rawValue:
//        case Sections.TopRated.rawValue:
            
        default:
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        let defaultOffset = view.safeAreaInsets.top
    //        let offset = scrollView.contentOffset.y + defaultOffset
    //
    //        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    //    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y , width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .label
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
}

extension HomeVC: CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async{ [weak self] in
            let vc = TitlePreviewViewController()

            vc.configure(with: viewModel)
            vc.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
