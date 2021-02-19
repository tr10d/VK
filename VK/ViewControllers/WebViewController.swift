//
//  WebViewController.swift
//  VK
//
//  Created by  Sergei on 16.02.2021.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if Session.shared.isKeysExist() {

            NetworkService.shared.requestAPI(method: "account.getInfo") { (_, _, error) in
                DispatchQueue.main.async {
                    if error == nil {
                        self.performSegue(withIdentifier: "toMainTab", sender: nil)
                    } else {
                        self.loadRequestAuth()
                    }
                }
            }

        } else {
            loadRequestAuth()
        }
    }

    private func loadRequestAuth() {
        if let request = NetworkService.shared.requestAuth() {
            webView.load(request)
        }
    }

}

// MARK: - WKNavigationDelegate

extension WebViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {

        guard let url = navigationResponse.response.url,
              url.path == "/blank.html",
              let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }

        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }

        guard let token = params["access_token"],
              let userIdString = params["user_id"],
              let userId = Int(userIdString) else {
            decisionHandler(.allow)
            return
        }

        Session.shared.setItem(token: token, userId: userId)
        decisionHandler(.cancel)
        performSegue(withIdentifier: "toMainTab", sender: nil)
    }

}
