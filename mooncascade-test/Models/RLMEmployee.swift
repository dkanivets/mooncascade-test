//
//  RLMEmployee.swift
//  mooncascade-test
//
//  Created by Dmitry Kanivets on 18.04.18.
//  Copyright © 2018 Dmitry Kanivets. All rights reserved.
//

import RealmSwift

class RLMEmployee: Object {
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var position: String = ""
    @objc dynamic var contactID: String? = nil
    @objc dynamic var email: String? = nil
    @objc dynamic var phone: String? = nil
    let projects = List<String>()

    
    func write() {
        let realm = try! Realm()
        try! realm.write {
            realm.add(self)
        }
    }

}
