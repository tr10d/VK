//
//  NewsTableViewController.swift
//  VK
//
//  Created by  Sergei on 20.01.2021.
//

import UIKit
import RealmSwift

class NewsTableViewController: UITableViewController {

//    private var news: Results<RealmNews>?
    private var news = [Json.News.Item]()
    private var startFrom: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadDataSource()
        viewDidLoadRequest()
    }

}

// MARK: - Request

extension NewsTableViewController {

    func viewDidLoadRequest() {
        loadData(startFrom: startFrom) {
            self.tableView.reloadData()
        }
    }

    func loadData(startFrom: String = "", completion: @escaping () -> Void) {
        NetworkManager.shared.getNews(startFrom: startFrom) { decodeJson in
            guard let response = decodeJson.response else { return }
            self.startFrom = response.nextFrom
            self.news = response.items
            completion()
        }
    }

}

// MARK: - Table view data source

extension NewsTableViewController {

    func viewDidLoadDataSource() {
        tableView.register(NewsTableViewCell.nib,
                           forCellReuseIdentifier: NewsTableViewCell.identifier)
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
   }

    @objc func refresh(_ sender: AnyObject) {
        startFrom = ""
        loadData(startFrom: startFrom) {
            self.tableView.refreshControl?.endRefreshing()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        news.count
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        6
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        (60 + 90 + 6 + 260 + 2 + 20)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier,
                                                       for: indexPath) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(news: news[indexPath.section])
        return cell
    }

}
