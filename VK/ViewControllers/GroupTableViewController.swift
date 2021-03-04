//
//  GroupTableViewController.swift
//  VK
//
//  Created by  Sergei on 26.12.2020.
//

import UIKit

class GroupTableViewController: UITableViewController {

    var groups: Groups?

    @IBAction func unwindFromGroups(_ segue: UIStoryboardSegue) {
        guard let tableViewController = segue.source as? AllGroupTableViewController,
              let indexPath = tableViewController.tableView.indexPathForSelectedRow else { return }

        let group = tableViewController.searchGroups?[indexPath.row]
        groups?.append(group)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSourceViewDidLoad()
        requestViewDidLoad()
    }

//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }

}

// MARK: - Request

extension GroupTableViewController {

    func requestViewDidLoad() {
        NetworkService.shared.requestGroups { (data, _, _) in
            guard let data = data else { return }
            NetworkService.shared.printJSON(data: data)
            do {
                self.groups = try JSONDecoder().decode(Groups.self, from: data)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(onDidReceiveGroups),
//                                               name: .didReceiveGroups, object: nil)
//        NetworkService.shared.requestGroups()
    }

//    @objc func onDidReceiveGroups(_ notification: Notification) {
//        if let info = notification.userInfo,
//           let data = info["json"] {
//            DispatchQueue.main.async {
//                print(data)
//                self.tableView.reloadData()
//            }
//        }
//    }

}

// MARK: - Table view data source

extension GroupTableViewController {

    func dataSourceViewDidLoad() {
        tableView.register(GroupTableViewCell.nib, forCellReuseIdentifier: GroupTableViewCell.identifier)
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
        cell.set(group: group)
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
//        switch editingStyle {
//        case .delete:
////            groupes.remove(at: indexPath.row)
////            tableView.deleteRows(at: [indexPath], with: .fade)
//        default:
//            break
//        }
    }

}
