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
    
    override func loadView() {
        super.loadView()
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
//    override func viewDidLoad() {
//        Realm.Configuration.defaultConfiguration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadStartScreen()
    }
    
    private func loadStartScreen() {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [URLQueryItem(name: "client_id", value: "51404690"),
                              URLQueryItem(name: "display", value: "mobile"),
                              URLQueryItem(name: "redirect_uri", value: urlComponents.host! + "/blank.html"),
                              URLQueryItem(name: "scope", value: "271446"),
                              URLQueryItem(name: "response_type", value: "token"),
                              URLQueryItem(name: "v", value: "5.131")]
        
        webView.load(URLRequest(url: urlComponents.url!))
    }
    
    private func login() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "BarController") as? UITabBarController else { return }
        controller.transitioningDelegate = self
        
        present(controller, animated: true)
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
            let userToken = KeychainWrapper.standard.string(forKey: "userToken")
            guard let realm = try? Realm(), let id = params["user_id"] else { return }
            
            ApiKey.session.token = token
            ApiKey.session.userId = id
            
            if userToken == token {
                login()
            } else {
                KeychainWrapper.standard.set(token, forKey: "userToken")
                
                if let _ = realm.object(ofType: User.self, forPrimaryKey: id) { } else {
                    dataManger.saveUser(id: id)
                }
                login()
            }
        }
        
        decisionHandler(.cancel)
    }
}

extension LoginVC : UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CardRotateTransition()
    }
}

class CardRotateTransition: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from),
        let destinationVC = transitionContext.viewController(forKey: .to) else {
            return
        }
        
        transitionContext.containerView.addSubview(destinationVC.view)
        destinationVC.view.layer.anchorPoint = CGPoint(x: 1, y: 0)
        destinationVC.view.frame = source.view.frame
        destinationVC.view.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        
        UIView.animate(withDuration: 1.2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [], animations: {
            destinationVC.view.transform = CGAffineTransform(rotationAngle: 0)
        }) { animationFinished in
            if animationFinished && !transitionContext.transitionWasCancelled {
                transitionContext.completeTransition(true)
            }
        }
    }
}

