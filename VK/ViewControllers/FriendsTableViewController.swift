//
//  FriendsTableViewController.swift
//  VK
//
//  Created by  Sergei on 26.12.2020.
//

import UIKit

class FriendsTableViewController: UITableViewController {

    var friends = Users()
    var letters = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        friends = NetworkService().getUsers()
        letters = friends.letters
        tableView.register(UINib(nibName: "FriendTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }

    // MARK: - Table view data source

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return letters
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return letters.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = letters[section]
        if let array = friends.data[key] {
            return array.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return letters[section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                as? FriendTableViewCell,
              let array = friends.data[letters[indexPath.section]] else {
            return UITableViewCell()
        }
        let friend = array[indexPath.row]
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
                  let destination = segue.destination as? FriendsPhotoCollectionViewController,
                let array = friends.data[letters[indexPath.section]] else { return }

            destination.friend = array[indexPath.row]

        default:
            break
        }
    }

}

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var friendName: UILabel!

}
