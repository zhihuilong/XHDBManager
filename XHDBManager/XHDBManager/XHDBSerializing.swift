//
//  XHDBSerializing.swift
//  XHDBManager
//
//  Created by Sunny on 1/14/16.
//  Copyright © 2016 Sunny. All rights reserved.
//

protocol XHDBSerializing: NSObjectProtocol {
    static var tableName: String { get }
    static var primaryKey: String { get }
    static var columnsFromProperties: NSDictionary { get }
    init(dictionary: NSDictionary)
}
