//
//  EmployeeService.swift
//  mooncascade-test
//
//  Created by Dmitry Kanivets on 18.04.18.
//  Copyright © 2018 Dmitry Kanivets. All rights reserved.
//

import Foundation
import ReactiveSwift
import SwiftyJSON
import RealmSwift
import Contacts
import ContactsUI

struct EmployeeService {
    
    fileprivate static var contacts: [CNContact] = {
        let contactStore = CNContactStore()
        var contacts = [CNContact]()
        let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName)]
        let request = CNContactFetchRequest(keysToFetch: keys)
        
        do {
            try contactStore.enumerateContacts(with: request) { (contact, stop) in
                contacts.append(contact)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return contacts
    }()
    
    static var pullEmployeesAction: Action<([City]), [RLMEmployee], NSError> = Action {
        var arrayOfSignalProducers: [SignalProducer<JSON, NSError>] = []

        for city in $0 {
            let signalProducer = NetworkService.employeeList(city).jsonSignalProducer()
            arrayOfSignalProducers.append(signalProducer)
        }
    
        return SignalProducer(arrayOfSignalProducers).flatten(.merge).collect().flatMap(FlattenStrategy.concat, { value -> SignalProducer<[RLMEmployee], NSError> in
            let realm = try! Realm()
            try! realm.write {
                realm.deleteAll()
            }
            var result: [RLMEmployee] = []
            
            for json in value {
                guard let employees = json["employees"].array,
                    let cityResult = employees.failableMap({$0.employeeToStorage()})
                    else {
                        return SignalProducer(error: NSError(domain: "Response can't be parsed", code: 100, userInfo: nil))
                }
                result.append(contentsOf: cityResult)
            }
            
            return SignalProducer(value: result)
        })
    }
    
    static func getContactFromID(contactID: String) -> CNContact? {
        let predicate = CNContact.predicateForContacts(withIdentifiers: [contactID])
        var contacts = [CNContact]()
        let contactsStore = CNContactStore()
        
        do {
            contacts = try contactsStore.unifiedContacts(matching: predicate, keysToFetch: [CNContactViewController.descriptorForRequiredKeys()])
        }
        catch {}

        return contacts.isEmpty ? nil : contacts[0]
    }
    
    static func getContactID(employee: RLMEmployee) -> String? {
        for contact in contacts {
            if contact.givenName.caseInsensitiveCompare(employee.firstName) == .orderedSame && contact.familyName.caseInsensitiveCompare(employee.lastName) == .orderedSame {
                return contact.identifier
            }
        }
        
        return nil
    }
    
//    static var pullEmployeesAction: Action<([City]), [RLMEmployee], NSError> = Action {
//        var arrayOfSignalProducers: [SignalProducer<[RLMEmployee], NSError>] = []
//        var shouldClean = true
//
//        for city in $0 {
//            let signalProducer = EmployeeService.pull(city: city, shouldClean: shouldClean)
//            shouldClean = false
//            arrayOfSignalProducers.append(signalProducer)
//        }
//        return SignalProducer(arrayOfSignalProducers).flatten(.concat)
//    }
    
//    static func pull(city : City, shouldClean: Bool = false) -> SignalProducer<[RLMEmployee], NSError> {
//        return NetworkService.employeeList(city).jsonSignalProducer([:])
//            .flatMap(FlattenStrategy.concat, { json -> SignalProducer<[RLMEmployee], NSError> in
//                if shouldClean {
//                    let realm = try! Realm()
//                    try! realm.write {
//                        realm.deleteAll()
//                    }
//                }
//                guard let employees = json["employees"].array,
//                    let result = employees.failableMap({$0.employeeToStorage()})
//                    else {
//                        return SignalProducer(error: NSError(domain: "Response can't be parsed", code: 100, userInfo: nil))
//                }
//                return SignalProducer(value: result)
//            })
//    }
}

extension JSON {
    func employeeToStorage() -> RLMEmployee? {
        let employee = RLMEmployee()
        
        guard let firstName = self["fname"].string,
            let lastName = self["lname"].string,
            let position = self["position"].string,
            let contactDetails = self["contact_details"].dictionary
        else {
            return nil
        }
        employee.firstName = firstName
        employee.lastName = lastName
        employee.position = position
        employee.contactID = EmployeeService.getContactID(employee: employee)
        employee.email = contactDetails["email"]?.string
        employee.phone = contactDetails["phone"]?.string
        employee.projects.append(objectsIn: self["projects"].array?.failableMap({$0.string}) ?? [])
        employee.write()
        
        return employee
    }
}
