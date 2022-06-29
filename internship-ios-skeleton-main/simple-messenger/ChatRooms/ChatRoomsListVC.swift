//
//  ViewController.swift
//  simple-messenger
//
//  Created by Pavel Odstrčilík on 08.06.2021.
//

import UIKit
import Alamofire

public class ChatRoomsListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var chatrooms: [Chatroom] = []
    let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    let activityIndicator = UIActivityIndicatorView()
    
    
    var cellStyleForEditing: UITableViewCell.EditingStyle = .insert

    // MARK: - Hides navigation bar
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        activityIndicator.hidesWhenStopped = false
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
    
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(addTapped))
        prepareView()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(showEditing))
    }
    
    @objc func showEditing()
    {
       if(self.tableView.isEditing == true)
       {
           self.tableView.isEditing = false
           self.navigationItem.leftBarButtonItem?.title = "Edit"
       }
       else
       {
           self.tableView.isEditing = true
           self.navigationItem.leftBarButtonItem?.title = "Done"
       }
   }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0;
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print("Hello world \(chatrooms[indexPath.row].id)")
        
        let alert = UIAlertController(title: "Edit the chatroom", message: "Enter the requested data", preferredStyle: .alert)

        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Chatroom name"
        })
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Chatroom description"
        })
        
        alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { action in
            if let title = alert.textFields?.first?.text, let description = alert.textFields?[1].text {
                print("\(title)")
                print("\(description)")
                
                self.putApiData(id: self.chatrooms[indexPath.row].id, title: title, description: description)
            }
            
        }))

        self.present(alert, animated: true)
    }
    
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return cellStyleForEditing
    }
    
    @objc func addTapped() {
        let alert = UIAlertController(title: "Create a chatroom", message: "Enter the requested data", preferredStyle: .alert)

        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Chatroom name"
        })
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Chatroom description"
        })
        
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { action in
            if let title = alert.textFields?.first?.text, let description = alert.textFields?[1].text {
                print("\(title)")
                print("\(description)")
                
                self.postApiData(title: title, description: description)
            }
            
        }))

        self.present(alert, animated: true)
    }
    
    func prepareView() {
        view.backgroundColor = .white
        prepareTableView()
        getApiData()
    }
    
    func putApiData(id: Int, title: String, description: String) {
        activityIndicator.startAnimating()
        let parameters : [String: String] = [
            "title":title,
            "description":description
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "Basic \(UserService.shared.getUserApiKey() ?? "")"
        ]
        
        let url: String = "https://simple-messenger-backend.dev07.b2a.cz/api/v1/chat-room/\(id)"
        
        /**AF.request("https://simple-messenger-backend.dev07.b2a.cz/api/v1/chat-room",
                   method: .post,
                   parameters: parameters,
                   encoder: URLEncodedFormParameterEncoder.default,
                   headers: headers)*/
        
        AF.request(URL.init(string: url)!, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
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
    
    func postApiData(title: String, description: String) {
        activityIndicator.startAnimating()
        let parameters : [String: String] = [
            "title":title,
            "description":description
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "Basic \(UserService.shared.getUserApiKey() ?? "")"
        ]
        
        let url: String = "https://simple-messenger-backend.dev07.b2a.cz/api/v1/chat-room"
        
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
            let url = "https://simple-messenger-backend.dev07.b2a.cz/api/v1/chat-room/\(id)"
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
                                self.chatrooms = try JSONDecoder().decode([Chatroom].self, from: jsonAsData)
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
        let url = "https://simple-messenger-backend.dev07.b2a.cz/api/v1/chat-room"
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
                            self.chatrooms = try JSONDecoder().decode([Chatroom].self, from: jsonAsData)
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
            make.edges.equalToSuperview()
        }

        tableView.register(ChatRoomsListTVCell.self, forCellReuseIdentifier: ChatRoomsListTVCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
    }


    // MARK: - UITableViewDelegate
    // MARK: - Function counts how many cells will be displayed
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatrooms.count
    }

    // MARK: - Function creates instance of UITableViewCell for every displayed row
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: ChatRoomsListTVCell.reuseIdentifier) as? ChatRoomsListTVCell ?? ChatRoomsListTVCell()
        if chatrooms.count > indexPath.row {
            cell.data = chatrooms[indexPath.row]
        }
        return cell
    }

    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [self] (_, _, _) in
            guard self.chatrooms.count > indexPath.row else {
                return
            }
            
            deleteApiData(id: chatrooms[indexPath.row].id)
           print("hell")
            self.viewDidLoad()
        }
        delete.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    // MARK: - Function is called when row is selected
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = MessagesListVC()
        if chatrooms.count > indexPath.row {
            detailViewController.title = "\(chatrooms[indexPath.row].title)"
        }
        
        let selectedRow = chatrooms[indexPath.row]
        detailViewController.chatroom = selectedRow
        
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

