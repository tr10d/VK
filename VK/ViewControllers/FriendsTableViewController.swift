//
//  FriendsTableViewController.swift
//  VK
//
//  Created by  Sergei on 26.12.2020.
//

import UIKit

class FriendsTableViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var serarchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    var users: Users?

    override func viewDidLoad() {
        super.viewDidLoad()
        delegateViewDidLoad()
        dataSourceViewDidLoad()
        requestViewDidLoad()
    }

}

// MARK: - Request

extension FriendsTableViewController {

    func requestViewDidLoad() {
        NetworkService.shared.requestUsers { (data, _, _) in
            guard let data = data else { return }
            NetworkService.shared.printJSON(data: data)
            do {
                let usersJson = try JSONDecoder().decode(UsersJson.self, from: data)
                usersJson.saveToRealm()
                self.users = Users(usersJson: usersJson)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

}

// MARK: - Navigation

extension FriendsTableViewController {

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toFriendsPhoto":
            guard let tableViewController = segue.source as? FriendsTableViewController,
                  let indexPath = tableViewController.tableView.indexPathForSelectedRow,
                  let destination = segue.destination as? FriendsPhotoCollectionViewController else { return }

            destination.user = users?.getFriend(indexPath: indexPath)

        default:
            break
        }
    }

}

// MARK: - Table view data source

extension FriendsTableViewController: UITableViewDataSource {

    func dataSourceViewDidLoad() {
        tableView.register(FriendTableViewCell.nib, forCellReuseIdentifier: FriendTableViewCell.identifier)
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return users?.letters
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return users?.letters.count ?? 0
    }

}

// MARK: - Table view data delegate

extension FriendsTableViewController: UITableViewDelegate {

    func delegateViewDidLoad() {
        navigationController?.delegate = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.getFriends(section: section).count ?? 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return users?.letters[section]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                as? FriendTableViewCell else {
            return UITableViewCell()
        }
        cell.set(user: users?.getFriend(indexPath: indexPath))
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toFriendsPhoto", sender: self)
    }

}

// MARK: - Search bar delegate

extension FriendsTableViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        users?.filter = searchText
        tableView.reloadData()
    }

}

// MARK: - UINavigationControllerDelegate

extension FriendsTableViewController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        switch operation {
        case .push:
            return Animator(isPresenting: true)
        case .pop:
            return Animator(isPresenting: false)
        default:
            return nil
        }
    }

}
