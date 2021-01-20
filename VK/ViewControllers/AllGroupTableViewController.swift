//
//  AllGroupTableViewController.swift
//  VK
//
//  Created by  Sergei on 26.12.2020.
//

import UIKit

class AllGroupTableViewController: UITableViewController, UISearchBarDelegate {

    var groupes: [Group] = []
    var filteredGroupes: [Group] = []

    @IBOutlet weak var searchGroup: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        groupes = NetworkService().getGroups()
        filteredGroupes = groupes
        tableView.register(GroupTableViewCell.nib, forCellReuseIdentifier: GroupTableViewCell.identifier)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredGroupes = groupes
        } else {
            filteredGroupes = groupes.filter {
                $0.name.range(of: searchText, options: .caseInsensitive) != nil
            }
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredGroupes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                as? GroupTableViewCell else {
            return UITableViewCell()
        }
        let group = filteredGroupes[indexPath.row]
        cell.set(group: group)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "unwindFromGroups", sender: self)
    }

}
