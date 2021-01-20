//
//  FriendsTableViewController.swift
//  VK
//
//  Created by  Sergei on 26.12.2020.
//

import UIKit

class FriendsTableViewController: UITableViewController, UISearchBarDelegate {

    var friends = Users()

    @IBOutlet weak var searchFriend: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        friends = NetworkService().getUsers()
        tableView.register(FriendTableViewCell.nib, forCellReuseIdentifier: FriendTableViewCell.identifier)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        friends.filter = searchText
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return friends.letters
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return friends.letters.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.getFriends(section: section).count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return friends.letters[section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                as? FriendTableViewCell else {
            return UITableViewCell()
        }
        cell.set(friend: friends.getFriend(indexPath: indexPath))
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toFriendsPhoto", sender: self)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toFriendsPhoto":
            guard let tableViewController = segue.source as? FriendsTableViewController,
                  let indexPath = tableViewController.tableView.indexPathForSelectedRow,
                  let destination = segue.destination as? FriendsPhotoCollectionViewController else { return }

            destination.friend = friends.getFriend(indexPath: indexPath)

        default:
            break
        }
    }

}
