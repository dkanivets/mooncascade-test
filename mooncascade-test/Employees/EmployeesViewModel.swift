//
//  EmployeesViewЬщвуд.swift
//  mooncascade-test
//
//  Created by Dmitry Kanivets on 18.04.18.
//  Copyright © 2018 Dmitry Kanivets. All rights reserved.
//

import Foundation
import RealmSwift
import ReactiveSwift

protocol EmployeesViewModelProtocol {
    var updateItemsAction: Action<[City], [RLMEmployee], NSError> { get }
    var items: [RLMEmployee] { get }
}

class EmployeesViewModel: EmployeesViewModelProtocol {
    lazy var updateItemsAction = EmployeeService.pullEmployeesAction
    var items: [RLMEmployee] {
        let realm = try! Realm()
        let items = Array(realm.objects(RLMEmployee.self))
        
        return items
    }
}
