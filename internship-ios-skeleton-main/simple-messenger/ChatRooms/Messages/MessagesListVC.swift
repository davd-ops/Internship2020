//
//  ViewController.swift
//  simple-messenger
//
//  Created by Pavel Odstrčilík on 08.06.2021.
//

import UIKit
import Alamofire

public class MessagesListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var messages: [Message] = []
    var chatroom: Chatroom?
    
    
    let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    let activityIndicator = UIActivityIndicatorView()
    
    let input = UITextField()
    let button = UIButton()

    // MARK: - Hides navigation bar
    public override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        button.setTitle("Send", for: .normal)
        button.setTitleColor(.systemBlue
                             , for: .normal)
        activityIndicator.hidesWhenStopped = true
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        input.clearButtonMode = .whileEditing
        input.placeholder = "Message"
        
        button.addTarget(self, action: #selector(buttonPress), for: .touchUpInside)
        
        
    }
    
    @objc func buttonPress() {
        postApiData(content: input.text!)

        viewDidLoad()
        input.text = ""
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)

    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        
        prepareView()
        messages.reverse()
    
    }
    


    func prepareView() {
        view.backgroundColor = .white
        prepareButton()
        prepareInput()
        prepareTableView()
        
        getApiData()
    }
    
    func postApiData(content: String) {
        activityIndicator.startAnimating()
        let parameters : [String: String] = [
            "content":content
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "Basic \(UserService.shared.getUserApiKey() ?? "")"
        ]
        
        let url: String = "https://simple-messenger-backend.dev07.b2a.cz/api/v1/chat-room/\(chatroom?.id ?? 0)/message"
        
        /**AF.request("https://simple-messenger-backend.dev07.b2a.cz/api/v1/chat-room",
                   method: .post,
                   parameters: parameters,
                   encoder: URLEncodedFormParameterEncoder.default,
                   headers: headers)*/
        
        AF.request(URL.init(string: url)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
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
        activityIndicator.stopAnimating()
        
    }
    
    func deleteApiData(id: Int) {
            // MARK: - Change to your endpoint
            let url = "https://simple-messenger-backend.dev07.b2a.cz/api/v1/chat-room/message/\(id)"
            // MARK: - Headers
            let headers: HTTPHeaders = [
                "Authorization": "Basic \(UserService.shared.getUserApiKey() ?? "")"
            ]

            AF.request(url, method: .delete, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
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
                                self.messages = try JSONDecoder().decode([Message].self, from: jsonAsData)
                                self.tableView.reloadData()
                            } catch {
                                print("Failed to parse object")
                            }

                        } else {
                            // MARK: - Response error
                            guard let message = json["messages"] as? [String] else {
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
    
    // MARK: - Example of HTTP GET request
    func getApiData() {
        activityIndicator.startAnimating()
        // MARK: - Change to your endpoint
        let url = "https://simple-messenger-backend.dev07.b2a.cz/api/v1/chat-room/\(chatroom?.id ?? 1)/message"
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
                            self.messages = try JSONDecoder().decode([Message].self, from: jsonAsData)
                            self.tableView.reloadData()
                        } catch {
                            print("Failed to parse object")
                        }

                    } else {
                        // MARK: - Response error
                        guard let message = json["messages"] as? [String] else {
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
        activityIndicator.stopAnimating()
    }


    
    func prepareTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            //make.edges.equalToSuperview()
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(input.snp.top)
        }

        tableView.register(MessagesListTvCell.self, forCellReuseIdentifier: MessagesListTvCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
    }
    
    func prepareInput() {
        view.addSubview(input)
        input.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().offset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-15)
            make.height.equalTo(20)
            make.width.equalToSuperview().offset(-100)
            
        }
        
    }
    
    func prepareButton() {
        view.addSubview(button)
        
        button.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-15)
            
            make.width.equalTo(45)
            make.height.equalTo(10)
        }
    }
    

    // MARK: - UITableViewDelegate
    // MARK: - Function counts how many cells will be displayed
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    // MARK: - Function creates instance of UITableViewCell for every displayed row
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: MessagesListTvCell.reuseIdentifier) as? MessagesListTvCell ?? MessagesListTvCell()
        if messages.count > indexPath.row {
            cell.data = messages[indexPath.row]
        }
        return cell
    }

    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [self] (_, _, _) in
            guard self.messages.count > indexPath.row else {
                return
            }
            self.deleteApiData(id: self.messages[indexPath.row].id)
            self.viewDidLoad()
        }
        delete.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [delete])
    }
    // MARK: - Function is called when row is selected
    /*public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = ChatRoomsDetailVC()
        if chatrooms.count > indexPath.row {
            detailViewController.title = "\(chatrooms[indexPath.row].title)"
        }
        
        let selectedRow = chatrooms[indexPath.row]
        detailViewController.chatroom = selectedRow
        
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }*/
}

