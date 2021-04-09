//
//  WebViewController.swift
//  VK
//
//  Created by  Sergei on 16.02.2021.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet private weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadAuth()
//        loadRequestAuth()
    }

}

// MARK: - WKNavigationDelegate

extension WebViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {

        if let url = navigationResponse.response.url, url.path == "/error" {
            decisionHandler(.cancel)
            loadRequestAuth()
            return
        }

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

// MARK: - Auth

extension WebViewController {

    func viewDidLoadAuth() {
        if Session.shared.isKeysExist() {

            NetworkManager.shared.requestAPI(method: "account.getInfo") { (data, _, _) in

                NetworkManager.shared.printJSON(data: data)
                var isError = true

                if let data = data {
                    do {
                        _ = try JSONDecoder().decode(Json.Info.self, from: data)
                        isError = false
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                if isError {
                    OperationQueue.main.addOperation { self.loadRequestAuth() }
                } else {
                    OperationQueue.main.addOperation { self.performSegue(withIdentifier: "toMainTab", sender: nil) }
                }
            }

        } else {
            loadRequestAuth()
        }
    }

    private func loadRequestAuth() {
        if let request = NetworkManager.shared.requestAuth() {
            webView.load(request)
        }
    }

}
