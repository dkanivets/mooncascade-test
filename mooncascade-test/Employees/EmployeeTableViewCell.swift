//
//  EmployeeTableViewCell.swift
//  mooncascade-test
//
//  Created by Dmitry Kanivets on 18.04.18.
//  Copyright © 2018 Dmitry Kanivets. All rights reserved.
//

import UIKit

class EmployeeTableViewCell: UITableViewCell {
    static let reuseIndentifier = "employeeTableViewCell"
    var contactLabel: UILabel!
    
    override func prepareForReuse() {
        contactLabel.removeFromSuperview()
    }
    
    func setupCell(employee: RLMEmployee) {
        contactLabel = UILabel()
        contactLabel.text = "  Contact  "
        contactLabel.textColor = UIColor.white
        contactLabel.backgroundColor = UIColor.blue
        contactLabel.layer.cornerRadius = 4
        contactLabel.clipsToBounds = true
        self.contentView.addSubview(contactLabel)
        contactLabel.translatesAutoresizingMaskIntoConstraints = false
        contactLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16).isActive = true
        contactLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        contactLabel.heightAnchor.constraint(equalToConstant: 40)
        
        self.textLabel?.text = employee.firstName + " " + employee.lastName
        contactLabel.isHidden = employee.contactID == nil
    }
}
