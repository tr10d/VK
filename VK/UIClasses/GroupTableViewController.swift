//
//  GroupTableViewController.swift
//  VK
//
//  Created by  Sergei on 26.12.2020.
//

import UIKit

class GroupTableViewController: UITableViewController {

    var groupes = [Group]()

    @IBAction func unwindFromGroups(_ segue: UIStoryboardSegue) {
        guard let tableViewController = segue.source as? AllGroupTableViewController,
              let indexPath = tableViewController.tableView.indexPathForSelectedRow else {
            return
        }
        let group = tableViewController.groupes[indexPath.row]
        if groupes.contains(group) {
            return
        }
        groupes.append(group)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group = groupes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.imageView?.image = group.image
        cell.textLabel?.text = group.name
        return cell
    }

     // Override to support editing the table view.
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            groupes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}