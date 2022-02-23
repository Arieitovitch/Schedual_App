//
//  LoginVC.swift
//  OnBreak
//
//  Created by Arie Itovitch on 2021-08-12.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    
    let padding: CGFloat = 30
    let emailTextField = OBTextField(placeholder: "Email")
    let passwordTextField = OBTextField(placeholder: "Password")
    let loginButton = OBButton(backgroundcolor: .systemRed, title: "Sign In!")
    let signUpButton = OBButton(backgroundcolor: .systemTeal, title: "No Account? Sign Up!")

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
        view.addSubview(signUpButton)
        loginButton.isSelected = true
        passwordTextField.isSecureTextEntry = true
        loginButton.isEnabled = false
        loginButton.alpha = 0.75
        signUpButton.isSelected = true
        emailTextField.addTarget(self, action: #selector(textfieldStartedEditing), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textfieldStartedEditing), for: .editingChanged)
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
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
            
            signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: padding),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            
            
        ])
    }
    
    @objc func textfieldStartedEditing(){
        if !(passwordTextField.text?.isEmpty ?? false) && !(emailTextField.text?.isEmpty ?? false) {
            loginButton.isEnabled = true
            loginButton.alpha = 1
        } else {
            loginButton.isEnabled = false
            loginButton.alpha = 0.75
        }
    }
    
    @objc func loginButtonPressed(){
        if let email = emailTextField.text, let password = passwordTextField.text{
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let _ = error{
                    self.loginButton.shake()
                } else {
                    self.navigationController?.popToRootViewController(animated: true)
                    self.tabBarController?.tabBar.isHidden = false
                }
            }
        } else {
            loginButton.shake()
        }
    }
    
    @objc func signUpButtonPressed(){
        let VC = SignupVC()
        VC.title = "Sign Up"
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    func buttonAnimation(){
        loginButton.alpha = 0.75
    }

}
