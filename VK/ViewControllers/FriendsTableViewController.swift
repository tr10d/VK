//
//  FriendsTableViewController.swift
//  VK
//
//  Created by  Sergei on 26.12.2020.
//

import UIKit

class FriendsTableViewController: UITableViewController {

    var friends = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        friends = NetworkService().getUsers()
        tableView.register(UINib(nibName: "FriendTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                as? FriendTableViewCell else {
            return UITableViewCell()
        }
        let friend = friends[indexPath.row]
        cell.friendImage.image = friend.image.image
        cell.friendName.text = friend.name
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

            destination.friend = friends[indexPath.row]

        default:
            break
        }
    }

}
