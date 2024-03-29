//
//  TitlePreviewViewController.swift
//  KurdRating
//
//  Created by Siros Taib on 3/28/24.
//

import UIKit
import WebKit

class TitlePreviewViewController: UIViewController {
    
  //  private let webView: WKWebView = WKWebView()
    
    private let webView2: WKWebView = {
        let webview2 = WKWebView()
        webview2.translatesAutoresizingMaskIntoConstraints = false
        return webview2
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemOrange
        button.setTitle("Download", for: .normal)
        button.layer.cornerRadius = 7.5
        button.layer.masksToBounds = true
        return button
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.text = "this is a very good movie"
        return label
    }()
    
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "LOTR"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(webView2)
        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(downloadButton)
        self.navigationController?.navigationBar.tintColor = .white
        
        configureConstraints()
        // Do any additional setup after loading the view.
    }
    
    func configureConstraints() {
            let webViewConstraints = [
                webView2.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
                webView2.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                webView2.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                webView2.heightAnchor.constraint(equalToConstant: 300)
            ]
            
            let titleLabelConstraints = [
                titleLabel.topAnchor.constraint(equalTo: webView2.bottomAnchor, constant: 20),
                titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ]
            
            let overviewLabelConstraints = [
                overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
                overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ]
            
            let downloadButtonConstraints = [
                downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                downloadButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 25),
                downloadButton.widthAnchor.constraint(equalToConstant: 140),
                downloadButton.heightAnchor.constraint(equalToConstant: 40)
            ]
            
            NSLayoutConstraint.activate(webViewConstraints)
            NSLayoutConstraint.activate(titleLabelConstraints)
            NSLayoutConstraint.activate(overviewLabelConstraints)
            NSLayoutConstraint.activate(downloadButtonConstraints)
            
        }

    public func configure(with model: TitlePreviewViewModel) {
            titleLabel.text = model.title
            overviewLabel.text = model.titleOverview
            
            guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)") else {
                return
            }
            
            webView2.load(URLRequest(url: url))
        }
}
