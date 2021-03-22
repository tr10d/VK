//
//  NewsTableViewController.swift
//  VK
//
//  Created by  Sergei on 20.01.2021.
//

import UIKit
import RealmSwift

class NewsTableViewController: UITableViewController {

    private var news: Results<RealmNews>?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadDataSource()
        viewDidLoadRequest()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

// MARK: - Request

extension NewsTableViewController {

    func viewDidLoadRequest() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onDidReceiveNews),
                                               name: .didReceiveNews, object: nil)
        loadRealmData { self.tableView.reloadData() }
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

    func loadRealmData(offset: Int = 0, completion: @escaping () -> Void) {
        RealmManager.getNews(offset: offset) { realmData in
            self.news = realmData
            completion()
        }
    }
}

// MARK: - Table view data source

extension NewsTableViewController {

    func viewDidLoadDataSource() {
        tableView.register(NewsTableViewCell.nib,
                           forCellReuseIdentifier: NewsTableViewCell.identifier)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return news?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier,
                                                       for: indexPath) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(news: news?[indexPath.row])
//        cell.setContent(news: news[indexPath.row])
        return cell
    }

}
