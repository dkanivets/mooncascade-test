//
//  ViewController.swift
//  mooncascade-test
//
//  Created by Dmitry Kanivets on 18.04.18.
//  Copyright © 2018 Dmitry Kanivets. All rights reserved.
//

import UIKit
import RealmSwift
import ReactiveSwift
import ARSLineProgress

class EmployeesViewController: UIViewController {

    var searchBar: UISearchBar!
    var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var viewModel: EmployeesViewModelProtocol
    
    init (viewModel: EmployeesViewModelProtocol) { 
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBarStyle.prominent
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        navigationItem.titleView = searchBar

        tableView = UITableView()
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        tableView.register(EmployeeTableViewCell.self, forCellReuseIdentifier: EmployeeTableViewCell.reuseIndentifier)
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        viewModel.filter.signal.throttle(0.5, on: QueueScheduler.main).observeValues { [weak self] _ in
            self?.viewModel.refreshViewModel()
            self?.tableView.reloadData()
        }
        
        self.refresh(sender: self)
    }
    
    @objc func refresh(sender: AnyObject) {
        if sender is UIRefreshControl == false {
            ARSLineProgress.show()
        }
        viewModel.updateItemsAction.apply([.tartu, .tallinn]).on(
            failed: { [weak self] error in
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                    alert.dismiss(animated: true, completion: nil)
                })
                alert.addAction(cancel)
                self?.present(alert, animated: true, completion: nil)
            },
            completed: { [weak self] in
                self?.viewModel.refreshViewModel()
                self?.tableView.reloadData()
            },
            terminated: { [weak self] in
                self?.refreshControl.endRefreshing()
                ARSLineProgress.hide()
        }).start()
    }
}

extension EmployeesViewController: UITableViewDataSource, UITableViewDelegate {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource[section].employees.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.dataSource[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EmployeeTableViewCell.reuseIndentifier) as! EmployeeTableViewCell
        cell.setupCell(employee: viewModel.dataSource[indexPath.section].employees[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        navigationController?.pushViewController(EmployeeDetailsViewController(employee: viewModel.dataSource[indexPath.section].employees[indexPath.row]), animated: true)
    }
}

extension EmployeesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String) {
        viewModel.filter.value = textSearched
    }
}
