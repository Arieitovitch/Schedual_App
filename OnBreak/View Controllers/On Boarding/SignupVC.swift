//
//  SignupVC.swift
//  OnBreak
//
//  Created by Arie Itovitch on 2021-08-12.
//

import UIKit
import Firebase

class SignupVC: UIViewController {

    let padding: CGFloat = 30
    let NameTextField = OBTextField(placeholder: "Full Name")
    let emailTextField = OBTextField(placeholder: "Email")
    let passwordTextField = OBTextField(placeholder: "Password")
    let loginButton = OBButton(backgroundcolor: .systemRed, title: "Sign Up!")
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        view.backgroundColor = .systemBackground
        configureElements()
    }
    
    func configureElements(){
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(NameTextField)
        loginButton.isSelected = true
        passwordTextField.isSecureTextEntry = true
        loginButton.isEnabled = false
        loginButton.alpha = 0.75
        emailTextField.addTarget(self, action: #selector(textfieldStartedEditing), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textfieldStartedEditing), for: .editingChanged)
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        NSLayoutConstraint.activate([
            NameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            NameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            NameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            NameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            emailTextField.topAnchor.constraint(equalTo: NameTextField.bottomAnchor, constant: padding),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: padding),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 60),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            

            
            
        ])
    }
    
    @objc func textfieldStartedEditing(){
        if !(passwordTextField.text?.isEmpty ?? false) && !(emailTextField.text?.isEmpty ?? false) && !(NameTextField.text?.isEmpty ?? false) {
            loginButton.isEnabled = true
            loginButton.alpha = 1
        } else {
            loginButton.isEnabled = false
            loginButton.alpha = 0.75
        }
    }
    
    @objc func loginButtonPressed(){
        if let email = emailTextField.text, let password = passwordTextField.text, let name = NameTextField.text{
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let _ = error {
                    self.loginButton.shake()
                } else {
                    
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = name.lowercased()
                    changeRequest?.commitChanges(completion: { (error) in
                        if let _ = error{
                            self.loginButton.shake()
                        } else {
                            self.db.collection(K.UserCollection).document(email).setData([K.emailField: email, K.nameField:name, K.friendsField: [], K.requestsField: []])
                            self.navigationController?.popToRootViewController(animated: true)
                            self.tabBarController?.tabBar.isHidden = false
                        }
                    })
                    
                }
            }
        }
    }
    
    func buttonAnimation(){
        loginButton.alpha = 0.75
    }

}
