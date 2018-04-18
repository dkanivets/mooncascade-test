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
    var filter: MutableProperty<String> { get set }
    func refreshViewModel()
}

class EmployeesViewModel: EmployeesViewModelProtocol {
    lazy var updateItemsAction = EmployeeService.pullEmployeesAction
    var items: [RLMEmployee] {
        let realm = try! Realm()
        let items = Array(realm.objects(RLMEmployee.self))
        
        return items
    }
    var filter: MutableProperty<String> = MutableProperty("")
    
    var sections: [String] {
        var sectionsUnfiltered: [String] = []
        
        for employee in items {
            sectionsUnfiltered.append(employee.position)
        }
        
        return Array(Set(sectionsUnfiltered))
    }
    
    var dataSource: [(title: String, employees: [RLMEmployee])] = []
    
    func refreshViewModel() {
        dataSource = {
            var dataSourceUnsorted: [(title: String, employees: [RLMEmployee])] = []
            
            for section in sections {
                let positionEmployees = items.filter({ $0.position == section })
                    .sorted(by: { $0.lastName < $1.lastName })
                    .filter({ $0.firstName.contains(filter.value)
                        || $0.lastName.contains(filter.value)
                        || $0.position.contains(filter.value)
                        || ($0.email ?? "").contains(filter.value)
                        || $0.projects.filter({ $0.contains(self.filter.value)}).count > 0
                        || filter.value == ""
                    })
                dataSourceUnsorted.append((title: section, employees: positionEmployees))
            }
            
            return dataSourceUnsorted.sorted(by: { $0.title < $1.title })
        }()
    }
}
