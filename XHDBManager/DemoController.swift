//
//  DemoController.swift
//  XHDBManager
//
//  Created by Sunny on 3/1/16.
//  Copyright © 2016 Sunny. All rights reserved.
//

import UIKit

class DemoController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        demo()
    }
    
    func demo() {
        let dictionary = ["id"   : "1234",
                          "name" : "Sunny",
                          "age"  : 21]
        let user = User(dictionary: dictionary)
        XHDBManager.insert(user)
        
        if let queriedUser = XHDBManager.query(User.self).first as? User {
            print("queriedUser.name : \(queriedUser.name)")
        }
        
    }
}

//example entity
class User: NSObject, XHDBSerializing {
    var ID: String   = ""
    var name: String = ""
    var age: Int     = 0

    static var primaryKey: String {
        return "id"
    }
    
    static var tableName: String {
        return "user"
    }
    
    static var columnsFromProperties: NSDictionary {
        return ["ID"   : "id",
                "name" : "name",
                "age"  : "age"]
    }
    
    required init(dictionary: NSDictionary) {
        super.init()
        for (JSONKey, JSONValue) in dictionary {
            let keyPath = JSONKey as! String
            //自动转换
            for (key, value) in User.columnsFromProperties {
                if keyPath == value as! String {
                    self.setValue(JSONValue, forKeyPath: key as! String)
                }
            }
        }
    }
    
    // debug
    override var description: String {
        for (key, _) in User.columnsFromProperties {
            print("\(key) == \(self.valueForKeyPath(key as! String))")
        }
        return ""
    }
}