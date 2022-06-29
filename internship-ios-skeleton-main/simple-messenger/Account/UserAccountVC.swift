//
//  UserAccountVC.swift
//  simple-messenger
//
//  Created by Pavel Odstrčilík on 09.06.2021.
//

import Foundation
import UIKit
import Alamofire

open class UserAccountVC: UIViewController {

    let iconImageView = UIImageView()
    let nameLabel = UILabel()
    let emailLabel = UILabel()
    let logOutButton = UIButton()
    let editEmailButton = UIButton()

    open override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareLogOutButton()
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // MARK: - Set name of currently logged user to nameLabel
        nameLabel.text = UserService.shared.getFullName()
        emailLabel.text = UserService.shared.getUserEmail()
        
    }

    // MARK: - Hides navigation bar
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    open func prepareView() {
        self.view.backgroundColor = .white
        prepareIconImageView()
        prepareNameLabel()
        prepareEmailLabel()
        prepareLogOutButton()
        prepareEditButton()
    }

    // MARK: - Creates users icon
    open func prepareIconImageView() {
        view.addSubview(iconImageView)
        iconImageView.image = UIImage(systemName: "person.crop.circle.fill")
        iconImageView.tintColor = UIColor.black.withAlphaComponent(0.8)
        iconImageView.contentMode = .scaleToFill
        iconImageView.snp.makeConstraints { (make) in
            make.top.equalTo(100)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(100)
        }
    }

    // MARK: - Creates name label
    open func prepareNameLabel() {
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconImageView.snp.bottom).offset(50)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        nameLabel.textAlignment = .center
        nameLabel.font = .systemFont(ofSize: 30)
    }
    
    open func prepareEmailLabel() {
        view.addSubview(emailLabel)
        
        emailLabel.snp.makeConstraints {(make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(50)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        emailLabel.textAlignment = .center
        emailLabel.font = .systemFont(ofSize: 15)
    }

    open func prepareLogOutButton() {
        view.addSubview(logOutButton)
        logOutButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-100)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        logOutButton.setTitle("Log out", for: .normal)
        logOutButton.setTitleColor(.white, for: .normal)
        logOutButton.backgroundColor = .systemBlue
        logOutButton.layer.cornerRadius = 10
        logOutButton.addTarget(self, action: #selector(logOut), for: .primaryActionTriggered)
    }
    
    open func prepareEditButton() {
        view.addSubview(editEmailButton)
        editEmailButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-160)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        editEmailButton.setTitle("Edit email", for: .normal)
        editEmailButton.setTitleColor(.white, for: .normal)
        editEmailButton.backgroundColor = .systemBlue
        editEmailButton.layer.cornerRadius = 10
        editEmailButton.addTarget(self, action: #selector(editEmail), for: .primaryActionTriggered)
    }
    
    @objc func editEmail() {
        let alert = UIAlertController(title: "Edit email", message: "Enter the requested data", preferredStyle: .alert)

        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "New Email"
        })
    
        
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { action in
            if let title = alert.textFields?.first?.text {
                print("\(title)")
                
                self.patchApiData(email: (alert.textFields?.first?.text)!)
                
            }
            
        }))

        self.present(alert, animated: true)
    }
    
    func patchApiData(email: String) {
        let parameters : [String: String] = [
            "email":email,
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "Basic \(UserService.shared.getUserApiKey() ?? "")"
        ]
        
        let url: String = "https://simple-messenger-backend.dev07.b2a.cz/api/v1/user/\(UserService.shared.getUserId() ?? 1)"
        
        
        AF.request(URL.init(string: url)!, method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                        print(json);
                        
                    }
                    self.viewDidLoad()
                    break
                case .failure(let error):
                    print("Failure!\(error)");
                    break
                }
            }
    }

    @objc open func logOut() {
        self.dismiss(animated: true, completion: nil)
        UserService.shared.logOut()
    }
}
