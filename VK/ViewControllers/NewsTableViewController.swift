//
//  NewsTableViewController.swift
//  VK
//
//  Created by  Sergei on 20.01.2021.
//

import UIKit
import PromiseKit

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
        loadData { }
    }

    func loadData(_ completion: @escaping () -> Void) {
        NetworkManager.shared.getNewsPromise(startFrom: self.startFrom)
            .then { [weak self] decodeJson -> Promise<[Json.News.Item]> in
                var data = decodeJson
                guard let response = data.response else { return brokenPromise()}
                data.configure()
                self?.startFrom = response.nextFrom ?? ""
                return Promise.value(response.items)
            }.done(on: DispatchQueue.main) { items in
                self.news = items + self.news
                self.tableView.reloadData()
            }
            .catch { error in
                debugPrint(error)
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
