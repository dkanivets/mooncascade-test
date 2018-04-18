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

struct EmployeeService {
    
    static var pullEmployeesAction: Action<([City]), [RLMEmployee], NSError> = Action {
        var arrayOfSignalProducers: [SignalProducer<[RLMEmployee], NSError>] = []
        
        for city in $0 {
            let signalProducer = EmployeeService.pull(city: city)
            arrayOfSignalProducers.append(signalProducer)
        }
        return SignalProducer(arrayOfSignalProducers).flatten(.concat)
    }
    
    static func pull(city : City) -> SignalProducer<[RLMEmployee], NSError> {
        return NetworkService.employeeList(city).jsonSignalProducer([:])
            .flatMap(FlattenStrategy.concat, { json -> SignalProducer<[RLMEmployee], NSError> in
                guard let employees = json["employees"].array,
                    let result = employees.failableMap({$0.employeeToStorage()})
                    else {
                        return SignalProducer(error: NSError(domain: "Response can't be parsed", code: 100, userInfo: nil))
                }
                return SignalProducer(value: result)
            })
    }
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
        employee.email = contactDetails["email"]?.string
        employee.phone = contactDetails["phone"]?.string
        employee.projects.append(objectsIn: self["projects"].array?.failableMap({$0.string}) ?? [])
        employee.id = firstName + lastName
        employee.write()
        
        return employee
    }
}
