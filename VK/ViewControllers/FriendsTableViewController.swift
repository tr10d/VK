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

    var friends = Users()
//    let interactiveTransition = CustomInteractiveTransition()

    override func viewDidLoad() {
        super.viewDidLoad()
        delegateViewDidLoad()
        dataSourceViewDidLoad()
        requestViewDidLoad()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

// MARK: - Request

extension FriendsTableViewController {

    func requestViewDidLoad() {
        friends = NetworkService.shared.getUsers()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onDidReceiveUsers),
                                               name: .didReceiveUsers, object: nil)
        NetworkService.shared.requestUsers()
    }

    @objc func onDidReceiveUsers(_ notification: Notification) {
        if let info = notification.userInfo,
            let data = info["json"] {
            print(data)
            tableView.reloadData()
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

            destination.friend = friends.getFriend(indexPath: indexPath)

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
        return friends.letters
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return friends.letters.count
    }

}

// MARK: - Table view data delegate

extension FriendsTableViewController: UITableViewDelegate {

    func delegateViewDidLoad() {
        navigationController?.delegate = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.getFriends(section: section).count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return friends.letters[section]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                as? FriendTableViewCell else {
            return UITableViewCell()
        }
        cell.set(friend: friends.getFriend(indexPath: indexPath))
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
        friends.filter = searchText
        tableView.reloadData()
    }

}

// MARK: - UINavigationControllerDelegate

extension FriendsTableViewController: UINavigationControllerDelegate {

//    func navigationController(_ navigationController: UINavigationController,
//                              interactionControllerFor animationController: UIViewControllerAnimatedTransitioning)
//                                -> UIViewControllerInteractiveTransitioning? {
//        return interactiveTransition.hasStarted ? interactiveTransition : nil
//    }

    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        switch operation {
        case .push:
//            interactiveTransition.viewController = toVC
            return Animator(isPresenting: true)
        case .pop:
//            if navigationController.viewControllers.first != toVC {
//                interactiveTransition.viewController = toVC
//            }
            return Animator(isPresenting: false)
        default:
            return nil
        }
    }
}
