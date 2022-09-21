//
//  LoginVC.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 18.08.2022.
//

import UIKit
import WebKit
import RealmSwift

class LoginVC: UIViewController {

    private var webView: WKWebView!
    private let dataManger: Manager = DataManager()
    
    @IBOutlet var loginButton: UIButton!
    
    override func loadView() {
        super.loadView()
        loginButton.layer.cornerRadius = 10
        
        webView = WKWebView()
        webView.navigationDelegate = self
        
        view.addSubview(webView)
        webView.frame = view.frame
        webView.isHidden = true
    }
    
//    override func viewDidLoad() {
//        Realm.Configuration.defaultConfiguration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
//    }
    
    private func loadStartScreen() {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [URLQueryItem(name: "client_id", value: "51404690"),
                              URLQueryItem(name: "display", value: "mobile"),
                              URLQueryItem(name: "redirect_uri", value: urlComponents.host! + "/blank.html"),
                              URLQueryItem(name: "scope", value: "336982"),
                              URLQueryItem(name: "response_type", value: "token"),
                              URLQueryItem(name: "v", value: "5.131")]
        
        webView.load(URLRequest(url: urlComponents.url!))
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        webView.isHidden = false
        let userToken = KeychainWrapper.standard.string(forKey: "userToken") ?? ""
        let userId = KeychainWrapper.standard.string(forKey: "userId") ?? ""
        
        if !userToken.isEmpty && !userId.isEmpty {
            ApiKey.session.token = userToken
            ApiKey.session.userId = userId
            login()
        } else {
            loadStartScreen()
        }
    }
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {
        removeVkCookies()
        webView.isHidden = true
    }
    
    private func login() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "BarController") as? UITabBarController else { return }
        controller.modalPresentationStyle = .fullScreen
        
        present(controller, animated: true)
    }
    
    func removeVkCookies() {
      WKWebsiteDataStore.default()
        .fetchDataRecords(ofTypes: WKWebsiteDataStore
                            .allWebsiteDataTypes()) { records in
        records.forEach { record in
          guard record.displayName == "vk.com" ||
                  record.displayName == "mail.ru" else { return }
          WKWebsiteDataStore.default()
            .removeData(ofTypes: record.dataTypes,
                        for: [record], completionHandler: {
          })
        }
      }
        
    }
    
}

extension LoginVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url, let fragment = url.fragment else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment.components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            }
        
        if let token = params["access_token"] {
            guard let realm = try? Realm(), let id = params["user_id"] else { return }
            
            ApiKey.session.token = token
            ApiKey.session.userId = id
            
            KeychainWrapper.standard.set(token, forKey: "userToken")
            KeychainWrapper.standard.set(id, forKey: "userId")
            
            if let _ = realm.object(ofType: User.self, forPrimaryKey: id) { } else {
                dataManger.saveUser(id: id)
            }
            login()
        }
        
        decisionHandler(.cancel)
    }
}
