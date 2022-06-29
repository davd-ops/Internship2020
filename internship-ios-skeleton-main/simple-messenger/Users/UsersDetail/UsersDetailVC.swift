//
//  ViewController.swift
//  simple-messenger
//
//  Created by Pavel Odstrčilík on 08.06.2021.
//

import UIKit
import Alamofire

public class UsersDetailVC: UIViewController {
    
    
    var userr: [User] = [] // variable holds all currently loaded user
    var userrID: Int?

    // MARK: - Hides navigation bar
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        // MARK: - Set name of currently selected user to nameLabel
        //nameLabel.text = (userrID.name)
        //emailLabel.text = UserService.shared.getEmail()
        //createdLabel.text = UserService.shared.getCreated()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }

    func prepareView() {
        self.view.backgroundColor = .white
        prepareIconImageView()
        prepareNameLabel()
        prepareEmailLabel()
        //prepareCreatedLabel()
        getApiData()
    }

    // MARK: - Example of HTTP GET request
    func getApiData() {
        guard let userrIDunwrapped = userrID else {
            return
        }
        // MARK: - Change to your endpoint
        let url = "https://simple-messenger-backend.dev07.b2a.cz/api/v1/user/\(userrIDunwrapped)"
        // MARK: - Headers
        let headers: HTTPHeaders = [
            "Authorization": "Basic \(UserService.shared.getUserApiKey() ?? "")"
        ]

        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            // MARK: - Parse response
            switch response.result {
            case .success(_):
                if let json = response.value as? [String: Any]
                {
                    if json["error"] as? Bool == false {
                        // MARK: - Success, your response is in variable json

                        guard let dataUnwrapped = json["data"],
                              let jsonAsData = try? JSONSerialization.data(withJSONObject: dataUnwrapped) else {
                            return
                        }

                        do {
                            self.userr = try JSONDecoder().decode([User].self, from: jsonAsData)
                        } catch {
                            print("Failed to parse object")
                        }

                    } else {
                        // MARK: - Response error
                        guard let message = json["User"] as? [String] else {
                            print("Error \(json)")
                            return
                        }
                        print("Error \(message)")
                    }
                }
            case .failure(let error):
                // MARK: - Error, wrong response
                print(error)
            }
        }
    }
    
    ///----------------------------------
    
    let iconImageView = UIImageView()
    let nameLabel = UILabel()
    let emailLabel = UILabel()
    //let createdLabel = UILabel()
    
    ///----------------------------------

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
        emailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconImageView.snp.bottom).offset(100)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        emailLabel.textAlignment = .center
        emailLabel.font = .systemFont(ofSize: 15)
    }

}

