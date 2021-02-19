//
//  NewsTableViewController.swift
//  VK
//
//  Created by  Sergei on 20.01.2021.
//

import UIKit

class NewsTableViewController: UITableViewController {

    var news: [News] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSourceViewDidLoad()
        requestViewDidLoad()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

// MARK: - Request

extension NewsTableViewController {

    func requestViewDidLoad() {
        news = NetworkService.shared.getNews()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onDidReceiveNews),
                                               name: .didReceiveNews, object: nil)
        NetworkService.shared.requestNews()
    }

    @objc func onDidReceiveNews(_ notification: Notification) {
        if let info = notification.userInfo,
           let data = info["json"] {
            DispatchQueue.main.async {
                print(data)
                self.tableView.reloadData()
            }
        }
    }

}

// MARK: - Table view data source

extension NewsTableViewController {

    func dataSourceViewDidLoad() {
        tableView.register(NewsTableViewCell.nib,
                           forCellReuseIdentifier: NewsTableViewCell.identifier)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return news.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier,
                                                       for: indexPath) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        cell.setContent(news: news[indexPath.row])
        return cell
    }

}
