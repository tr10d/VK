//
//  GroupTableViewController.swift
//  VK
//
//  Created by  Sergei on 26.12.2020.
//

import UIKit

class GroupTableViewController: UITableViewController {

    var groups: [RealmGroup] = []

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
        self.viewDidLoadDataSource()
        self.viewDidLoadRequest()
    }

}

// MARK: - Request

extension GroupTableViewController {

    func viewDidLoadRequest() {
        loadGroups()
        if groups.count == 0 { getDataFromVK() }
    }

    func loadGroups() {
        groups = RealmManager.getGroups()
        tableView.reloadData()
    }

    func getDataFromVK() {
        RealmManager.responseGroups {
            self.loadGroups()
            self.tableView.refreshControl?.endRefreshing()
       }
    }

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
        getDataFromVK()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                as? GroupTableViewCell else {
            return UITableViewCell()
        }
        let group = groups[indexPath.row]
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
