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
  enum UpdateTableMode {
    case all, fetchContinue, fetchNew
  }

  func viewDidLoadRequest() {
    loadData(.all)
  }

  func loadData(_ mode: UpdateTableMode, completion: @escaping () -> Void = {}) {
    NetworkManager.shared.getNews(startFrom: self.startFrom)
      .then { decodeJson -> Promise<Json.News.Response> in
        guard let response = decodeJson.response else { return brokenPromise() }
        return Promise.value(response.configured())
      }.done { response in
        self.updateTable(response: response, mode: mode)
        completion()
      }.catch { error in
        debugPrint(error)
      }
  }

  func updateTable(response: Json.News.Response, mode: UpdateTableMode) {
    let items = response.items

    startFrom = response.nextFrom ?? ""

    switch mode {
    case .all:
      news = items
      tableView.reloadData()
    case .fetchContinue:
      if items.isEmpty { return }

      let indexPaths = (news.count..<(news.count + items.count))
        .map { IndexPath(row: $0, section: 0) }

      news += items

      tableView.beginUpdates()
      tableView.insertRows(at: indexPaths, with: .automatic)
      tableView.endUpdates()
    case .fetchNew:
      let newItems = items
        .map { news.contains($0 ) ? nil : $0 }
        .compactMap { $0 }

      if newItems.isEmpty { return }

      news = newItems + news
      tableView.reloadData()
    }
  }
}

// MARK: - UITableViewDataSource

extension NewsTableViewController {
  func viewDidLoadDataSource() {
    tableView.register(NewsTableViewCell.nib,
                       forCellReuseIdentifier: NewsTableViewCell.identifier)
    tableView.tableFooterView = UIView()
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if news.isEmpty {
      tableView.showPlaceholder("Новостей нет!")
    } else {
      tableView.hidePlaceholder()
    }
    return news.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NewsTableViewCell.identifier,
            for: indexPath
    ) as? NewsTableViewCell else {
      return UITableViewCell()
    }
    cell.configure(news: news[indexPath.row])
    return cell
  }
}

// MARK: - UITableViewDelegate

extension NewsTableViewController {
  override func tableView(_ tableView: UITableView,
                          willDisplay cell: UITableViewCell,
                          forRowAt indexPath: IndexPath) {
    guard news.count == (indexPath.row + 1) else { return }
    loadData(.fetchContinue)
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let newsItem = news[indexPath.row]
    let cellSizes = CachedData.shared.cachedValue(for: newsItem.identifire) {
      NewsTableViewCell.cellSizes(news: newsItem, width: tableView.frame.width)
    }
    return cellSizes.heightForRowAt
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
    loadData(.fetchNew) {
      self.tableView.refreshControl?.endRefreshing()
    }
  }
}
