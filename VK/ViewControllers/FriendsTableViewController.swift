//
//  FriendsTableViewController.swift
//  VK
//
//  Created by  Sergei on 26.12.2020.
//

import UIKit
import RealmSwift

class FriendsTableViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var serarchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    var users: Users? {
        didSet { tableView.reloadData() }
    }
    private var realmUsers: Results<RealmUser>? {
        didSet {
            print(#function)
        }
    }
    
    private var letters: [String] = []
    private var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadDelegate()
        viewDidLoadDataSource()
        viewDidLoadRequest()
        viewDidLoadNotificationToken()
    }

    deinit {
        deinitNotificationToken()
    }
}

// MARK: - Request

extension FriendsTableViewController {

    func viewDidLoadRequest() {
        loadRealmData { self.tableView.reloadData() }
        loadUsers()
        if users == nil || users?.count == 0 { getDataFromVK() }
    }

    func loadRealmData(offset: Int = 0, completion: @escaping () -> Void) {
        RealmManager.getUsers2(offset: offset) { realmData in
            self.realmUsers = realmData
            completion()
        }
    }

    func loadUsers() {
        users = RealmManager.getUsers()
//        tableView.reloadData()
    }

    func getDataFromVK() {
        RealmManager.responseUsers {
            self.loadUsers()
            self.tableView.refreshControl?.endRefreshing()
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

            destination.configure(user: users?.getFriend(indexPath: indexPath))

        default:
            break
        }
    }

}

// MARK: - Table view data source

extension FriendsTableViewController: UITableViewDataSource {

    func viewDidLoadDataSource() {
        tableView.register(FriendTableViewCell.nib, forCellReuseIdentifier: FriendTableViewCell.identifier)

        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh from VK")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
   }

    @objc func refresh(_ sender: AnyObject) {
        loadRealmData { self.tableView.refreshControl?.endRefreshing() }
        getDataFromVK()
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

    func viewDidLoadDelegate() {
        navigationController?.delegate = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.getFriends(section: section).count ?? 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return users?.letters[section]
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let realmUsers = realmUsers else { return }
        let lastCount = realmUsers.count
        guard indexPath.row == lastCount - 1 else { return }
        loadRealmData(offset: lastCount) {}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                as? FriendTableViewCell else {
            return UITableViewCell()
        }
        cell.set(realmUser: users?.getFriend(indexPath: indexPath))
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

// MARK: - NotificationToken

extension FriendsTableViewController {

    func viewDidLoadNotificationToken() {
        notificationToken = realmUsers?.observe { [weak self] change in
            switch change {
            case .initial(let users):
                print("Initialize \(users.count)")
            case .update( _,
                         deletions: let deletions,
                         insertions: let insertions,
                         modifications: let modifications):
                self?.tableView.beginUpdates()
                self?.tableView.deleteRows(at: deletions.indexPaths, with: .automatic)
                self?.tableView.insertRows(at: insertions.indexPaths, with: .automatic)
                self?.tableView.reloadRows(at: modifications.indexPaths, with: .automatic)
                self?.tableView.endUpdates()

            case .error(let error):
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }

    private func deinitNotificationToken() {
        notificationToken?.invalidate()
    }

    private func showAlert(title: String? = nil,
                           message: String? = nil,
                           handler: ((UIAlertAction) -> Void)? = nil,
                           completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: handler)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: completion)
    }

}
