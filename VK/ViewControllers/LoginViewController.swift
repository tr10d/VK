//
//  ViewController.swift
//  VK
//
//  Created by  Sergei on 20.12.2020.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - IBOutlet

    @IBOutlet private weak var login: UITextField!
    @IBOutlet private weak var password: UITextField!
    @IBOutlet private weak var scrollView: UIScrollView!

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }

    @objc func keyboardWillShow(notification: Notification) {
        guard let kbSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.size.height, right: 0)
        scrollView.contentInset = insets
    }

    @objc func keyboardWillHide(notification: Notification) {
        let insets = UIEdgeInsets.zero
        scrollView.contentInset = insets
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        let isCorrect = isLoginPasswordCorrect()
//        if !isCorrect {
//            showLoginAllert()
//        }
        return true
    }

    // MARK: - Private Methods

//    private func isLoginPasswordCorrect() -> Bool {
//        guard let login = login.text, let password = password.text else { return false }
//        return NetworkService().isLoginValid(login: login, password: password)
//    }

    private func showLoginAllert() {
        let alert = UIAlertController(title: "Error", message: "Login/password is invalid", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

}
