//
//  GroupTableViewController.swift
//  VK
//
//  Created by  Sergei on 26.12.2020.
//

import UIKit
import RealmSwift

class GroupTableViewController: UITableViewController {

//    var groups: [RealmGroup] = []
    private var groups: Results<RealmGroup>?
    private var notificationToken: NotificationToken?
    
    @IBAction func unwindFromGroups(_ segue: UIStoryboardSegue) {
//        guard let tableViewController = segue.source as? AllGroupTableViewController,
//              let indexPath = tableViewController.tableView.indexPathForSelectedRow else { return }
//
//        let group = tableViewController.searchGroups?[indexPath.row]
//        groups?.append(group)
//        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadDataSource()
        viewDidLoadRequest()
        viewDidLoadNotificationToken()
    }

    deinit {
        deinitNotificationToken()
    }

}

// MARK: - Request

extension GroupTableViewController {

    func viewDidLoadRequest() {
        loadRealmData() { self.tableView.reloadData() }
//        if groups.count == 0 { getDataFromVK() }
    }

    func loadRealmData(offset: Int = 0, completion: @escaping () -> Void) {
        RealmManager.getGroups(offset: offset) { realmData in
            self.groups = realmData
            completion()
        }
//        tableView.reloadData()
    }

//    func getDataFromVK() {
//        RealmManager.responseGroups {
//            self.loadGroups()
//            self.tableView.refreshControl?.endRefreshing()
//       }
//    }

}

// MARK: - Table view data source

extension GroupTableViewController {

    func viewDidLoadDataSource() {
        tableView.register(GroupTableViewCell.nib, forCellReuseIdentifier: GroupTableViewCell.identifier)

        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh from VK")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    @objc func refresh(_ sender: AnyObject) {
        loadRealmData { self.tableView.refreshControl?.endRefreshing() }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                as? GroupTableViewCell else {
            return UITableViewCell()
        }
        let group = groups?[indexPath.row]
        cell.configure(group: group)
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
//        switch editingStyle {
//        case .delete:
//            groups?.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        default:
//            break
//        }
    }

}

// MARK: - NotificationToken

extension GroupTableViewController {

    func viewDidLoadNotificationToken() {
        notificationToken = groups?.observe { [weak self] change in
            switch change {
            case .initial(let users):
                print("Initialize \(users.count)")
            case .update( _,
                         deletions: let deletions,
                         insertions: let insertions,
                         modifications: let modifications):
                self?.tableView.beginUpdates()
                self?.tableView.deleteRows(at: deletions.indexPaths, with: .automatic)
                self?.tableView.insertRows(at: insertions.indexPaths, with: .automatic)
                self?.tableView.reloadRows(at: modifications.indexPaths, with: .automatic)
                self?.tableView.endUpdates()

            case .error(let error):
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }

    private func deinitNotificationToken() {
        notificationToken?.invalidate()
    }

    private func showAlert(title: String? = nil,
                           message: String? = nil,
                           handler: ((UIAlertAction) -> Void)? = nil,
                           completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: handler)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: completion)
    }

}
