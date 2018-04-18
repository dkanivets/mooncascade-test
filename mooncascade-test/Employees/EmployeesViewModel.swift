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
    var dataSource: [(title: String, employees: [RLMEmployee])] { get }
    var filter: String { get set }
}

class EmployeesViewModel: EmployeesViewModelProtocol {
    lazy var updateItemsAction = EmployeeService.pullEmployeesAction
    var items: [RLMEmployee] {
        let realm = try! Realm()
        let items = Array(realm.objects(RLMEmployee.self))
        
        return items
    }
    var filter: String = ""
    
    var sections: [String] {
        var sectionsUnfiltered: [String] = []
        
        for employee in items {
            sectionsUnfiltered.append(employee.position)
        }
        
        return Array(Set(sectionsUnfiltered))
    }
    
    var dataSource: [(title: String, employees: [RLMEmployee])] {
        var dataSourceUnsorted: [(title: String, employees: [RLMEmployee])] = []
        
        for section in sections {
            let positionEmployees = items.filter({ $0.position == section })
                .sorted(by: { $0.lastName < $1.lastName })
                .filter({ $0.firstName.contains(filter)
                    || $0.lastName.contains(filter)
                    || $0.position.contains(filter)
                    || ($0.email ?? "").contains(filter)
                    || $0.projects.filter({ $0.contains(self.filter)}).count > 0 })
            dataSourceUnsorted.append((title: section, employees: positionEmployees))
        }
        
        return dataSourceUnsorted.sorted(by: { $0.title < $1.title })
    }
}
