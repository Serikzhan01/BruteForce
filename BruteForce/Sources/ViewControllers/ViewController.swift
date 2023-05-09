//
//  ViewController.swift
//  BruteForce
//
//  Created by Serikzhan on 09.05.2023.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Flags
    
    private var isStart = false
    private let queue = DispatchQueue.global(qos: .background)
    
    // MARK: Outlets
    
    private lazy var passwordTextField: UITextField = {
        var textField = UITextField()
        textField.placeholder = "Enter the password"
        textField.textAlignment = .center
        textField.isSecureTextEntry = true
        textField.backgroundColor = .lightGray
        textField.layer.cornerRadius = 15
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var label: UILabel = {
        var label = UILabel()
        label.text = "****"
        label.textColor = .link
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.clipsToBounds = true
        label.layer.cornerRadius = 15
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var changeColorButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = .link
        button.layer.cornerRadius = 15
        button.setTitle("Change color", for: .normal)
        button.addTarget(self, action: #selector(changeColorButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .link
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Find the password", for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(findPasswordButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
    }
    
    private func setupHierarchy() {
        view.addSubview(activityIndicator)
        view.addSubview(passwordTextField)
        view.addSubview(label)
        view.addSubview(startButton)
        view.addSubview(changeColorButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor, constant: -150),
            
            passwordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            passwordTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            label.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            label.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 5),
            label.heightAnchor.constraint(equalTo: passwordTextField.heightAnchor),
            
            startButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            startButton.heightAnchor.constraint(equalToConstant: 60),
            startButton.widthAnchor.constraint(equalToConstant: 150),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            changeColorButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            changeColorButton.heightAnchor.constraint(equalToConstant: 60),
            changeColorButton.widthAnchor.constraint(equalToConstant: 150),
            changeColorButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
        ])
    }
    
    // MARK: Change background color
    
    private var isBlack: Bool = false {
        didSet {
            if isBlack {
                self.view.backgroundColor = .black
            } else {
                self.view.backgroundColor = .white
            }
        }
    }
    
    // MARK: Actions
    
    @objc private func changeColorButtonPressed() {
        isBlack.toggle()
    }
    
    @objc private func findPasswordButtonPressed() {
        guard let password = passwordTextField.text else {return}
        activityIndicator.startAnimating()
        bruteForce(passwordToUnlock: password)
    }
    
    func bruteForce(passwordToUnlock: String) {
        let ALLOWED_CHARACTERS:   [String] = String().printable.map { String($0) }
        var password: String = ""
        
        queue.async{ [self] in
            while password != passwordToUnlock {
                password = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
                DispatchQueue.main.async {
                    self.label.text = password
                }
            }
            
            DispatchQueue.main.async {
                if password == passwordToUnlock {
                    self.label.text = "Password is \(password) "
                } else {
                    self.label.text = "The password was not found)"
                }
                self.activityIndicator.stopAnimating()
            }
        }
        
    }
}
