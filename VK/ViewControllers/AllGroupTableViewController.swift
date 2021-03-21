//
//  AllGroupTableViewController.swift
//  VK
//
//  Created by  Sergei on 26.12.2020.
//

import UIKit

class AllGroupTableViewController: UITableViewController {

    var searchGroups: SearchGroups?

    @IBOutlet var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadDataSource()
    }

}

// MARK: - Table view data source

extension AllGroupTableViewController {

    func viewDidLoadDataSource() {
        tableView.register(GroupTableViewCell.nib, forCellReuseIdentifier: GroupTableViewCell.identifier)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchGroups?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                as? GroupTableViewCell else {
            return UITableViewCell()
        }
        let group = searchGroups?[indexPath.row]
        cell.configure(groupItem: group)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "unwindFromGroups", sender: self)
    }

}

// MARK: - Search bar delegate

extension AllGroupTableViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchGroups = nil
            tableView.reloadData()
        } else {
            NetworkService.shared.requestSearchGroups(searchinText: searchText) { (data, _, _) in
                guard let data = data else { return }
                NetworkService.shared.printJSON(data: data)
                do {
                    self.searchGroups = try JSONDecoder().decode(SearchGroups.self, from: data)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }

}
