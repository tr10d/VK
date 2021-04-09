//
//  NewsTableViewController.swift
//  VK
//
//  Created by  Sergei on 20.01.2021.
//

import UIKit
import RealmSwift

class NewsTableViewController: UITableViewController {

    private var news = [Json.News.Item]()
    private var startFrom: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadDataSource()
        viewDidLoadAction()
        viewDidLoadRequest()
    }

}

// MARK: - Request

extension NewsTableViewController {

    func viewDidLoadRequest() {
        loadData {}
    }

    func loadData(completion: @escaping () -> Void) {
        OperationQueue().addOperation {
            NetworkManager.shared.getNews(startFrom: self.startFrom) { decodeJson in
                var data = decodeJson
                guard let response = data.response else { return }
                data.configure()
                self.startFrom = response.nextFrom ?? ""
                response.items.forEach { self.news.append($0) }
                OperationQueue.main.addOperation {
                    self.tableView.reloadData()
                    completion()
                }
            }
        }
    }

}

// MARK: - UITableViewDataSource

extension NewsTableViewController {

    func viewDidLoadDataSource() {
        tableView.register(NewsTableViewCell.nib,
                           forCellReuseIdentifier: NewsTableViewCell.identifier)
   }

    override func numberOfSections(in tableView: UITableView) -> Int {
        news.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
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

// MARK: - UITableViewDelegate

extension NewsTableViewController {

    override func tableView(_ tableView: UITableView,
                            willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
        guard news.count == (indexPath.section + 1) else { return }
        loadData {}
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = 60 + 90 + 6 + 260 + 2 + 20
        if news[indexPath.section].isPhoto {
            height -= 90
        }
        return CGFloat(height)
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        6
    }

}

// MARK: - Action

extension NewsTableViewController {

    func viewDidLoadAction() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
   }

    @objc func refresh(_ sender: AnyObject) {
        startFrom = ""
        news.removeAll()
        loadData {
            self.tableView.refreshControl?.endRefreshing()
        }
    }

}
