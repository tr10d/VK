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
        if Session.shared.isSaved() {
            performSegue(withIdentifier: "toMainTab", sender: nil)
        } else if let request = NetworkService.shared.requestAuth() {
            webView.load(request)
        }
    }

}

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

        Session.shared.set(token: token, userId: userId)
        decisionHandler(.cancel)
        performSegue(withIdentifier: "toMainTab", sender: nil)
    }

}
