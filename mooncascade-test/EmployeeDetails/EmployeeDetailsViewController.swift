//
//  EmployeeDetailsViewController.swift
//  mooncascade-test
//
//  Created by Dmitry Kanivets on 19.04.18.
//  Copyright © 2018 Dmitry Kanivets. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class EmployeeDetailsViewController: UIViewController {
    var tableView: UITableView!
    var stackView: UIStackView!
    var stackContainerView: UIView!
    var contactButton: UIButton!
    var nameLabel: UILabel!
    var emailLabel: UILabel!
    var phoneLabel: UILabel!
    var employee: RLMEmployee!
    
    init(employee: RLMEmployee) {
        self.employee = employee
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }
    
    private func setupUI() {
        self.title = employee.firstName + " " + employee.lastName
        
        stackContainerView = UIView()
        stackContainerView.translatesAutoresizingMaskIntoConstraints = false
        stackContainerView.backgroundColor = UIColor.white
        view.addSubview(stackContainerView)
        stackContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        stackContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        stackContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: stackContainerView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: stackContainerView.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: stackContainerView.leadingAnchor, constant: 12).isActive = true
        stackView.trailingAnchor.constraint(equalTo: stackContainerView.trailingAnchor, constant: -12).isActive = true
        
        nameLabel = UILabel()
        nameLabel.text = employee.position
        nameLabel.backgroundColor = UIColor.white
        stackView.addArrangedSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        emailLabel = UILabel()
        emailLabel.text = employee.email
        emailLabel.backgroundColor = UIColor.white
        stackView.addArrangedSubview(emailLabel)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        if employee.phone != nil {
            phoneLabel = UILabel()
            phoneLabel.text = employee.phone
            phoneLabel.backgroundColor = UIColor.white
            stackView.addArrangedSubview(phoneLabel)
            phoneLabel.translatesAutoresizingMaskIntoConstraints = false
            phoneLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
        
        contactButton = UIButton()
        contactButton.translatesAutoresizingMaskIntoConstraints = false
        contactButton.setTitle("Open contact", for: .normal)
        contactButton.addTarget(self, action: #selector(openContact), for: .touchUpInside)
        contactButton.backgroundColor = UIColor.blue
        view.addSubview(contactButton)
        contactButton.heightAnchor.constraint(equalToConstant: employee.contactID == nil ? 0 : 44).isActive = true
        contactButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        contactButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        contactButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: stackContainerView.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: contactButton.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    @objc func openContact() {
        guard let contact = EmployeeService.getContactFromID(contactID: employee.contactID!) else { return }
        let contactsController = CNContactViewController(for: contact)
        self.navigationController?.pushViewController(contactsController, animated: true)
    }
}

extension EmployeeDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employee.projects.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Projects"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cellIdentifier")
        }
        cell.textLabel?.text = employee.projects[indexPath.row]
        
        return cell
    }
}
