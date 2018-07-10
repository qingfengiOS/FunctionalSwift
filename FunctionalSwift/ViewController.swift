//
//  ViewController.swift
//  FunctionalSwift
//
//  Created by qingfengiOS on 2018/6/27.
//  Copyright © 2018年 qingfengiOS. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //MARK:-Properties
    @IBOutlet weak var tableView: UITableView!
    var dataArray = ["BattleShip",
                     "PackgeCoreImage",
                     "MapFilterReduce",
                     "TheBinarySearchTree",
                     ]
    
    //MARK:-View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }

    //MARK:-TableViewDelegate/DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.dataArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let viewController = viewControllerByClassName(className: self.dataArray[indexPath.row])
        self.navigationController?.pushViewController(viewController!, animated: true)
    }

    //MARK:-CustomMethods
    func viewControllerByClassName(className: String) -> UIViewController? {
        
        guard let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            return nil
        }
        guard let viewControllerName = NSClassFromString(nameSpace + "." + className) else {
            return nil
        }
        guard let type = viewControllerName as? UIViewController.Type else {
            return nil
        }
        let viewController = type.init()
        return viewController
    }
    
}

