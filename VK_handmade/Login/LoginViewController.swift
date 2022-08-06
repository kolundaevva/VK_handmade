//
//  LoginViewController.swift
//  VK_handmade
//
//  Created by Владислав Колундаев on 28.07.2022.
//

import UIKit
import RealmSwift

class LoginViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    private let notification = NotificationCenter.default
    private let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notification.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(hideKeyboardGesture)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        notification.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    //MARK: – Navigation
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let loginStatus = checkUserData()
        
        if !loginStatus {
            showAlert()
        }
        
        return loginStatus
    }
    
    //MARK: – Methods
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEnd = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEnd, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        scrollView.verticalScrollIndicatorInsets = scrollView.contentInset
        scrollView.horizontalScrollIndicatorInsets = scrollView.contentInset
    }
    
    @objc func hideKeyboard() {
        self.scrollView.endEditing(true)
    }

    private func checkUserData() -> Bool {
        guard let login = loginTF.text, let password = passwordTF.text else { return false }
        guard !login.isEmpty || !password.isEmpty else { return false }
        
        if login == "login", password == "qwerty123" {
            if !defaults.bool(forKey: "authorized") {
                let user = User()
                
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.add(user)
                    }
                } catch {
                    print(error)
                }
                defaults.set(true, forKey: "authorized")
            }
            return true
        } else {
            return false
        }
    }
    
    private func showAlert() {
        let ac = UIAlertController(title: "Something goes wrong", message: "Incorrect login or password.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.passwordTF.text = nil
        }))
        present(ac, animated:  true)
    }
}

