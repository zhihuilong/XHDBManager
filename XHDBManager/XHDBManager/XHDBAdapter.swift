//
//  XHDBAdaptor.swift
//  XHDBManager
//
//  Created by Sunny on 12/23/15.
//  Copyright © 2015 Sunny. All rights reserved.
//

class XHDBAdapter: NSObject {
    
    class func columnValuesForUpdate(entity: XHDBSerializing) -> NSArray {
        
        var columnValues = [AnyObject]()
        let obj = entity as! NSObject
        
        for key in entity.dynamicType.columnsFromProperties.allKeys {
            columnValues.append(obj.valueForKeyPath(key as! String) ?? "")
        }
        return columnValues
    }
    
    class func insertStatement(entity: XHDBSerializing.Type) -> String {
        let columns = entity.columnsFromProperties.allValues
        var columnNames = ""
        var questionMarks = ""
        for index in 0..<columns.count {
            
            if(index != columns.count-1) {
                columnNames += "\(columns[index]), "
                questionMarks += "?, "
            } else {
                columnNames += "\(columns[index])"
                questionMarks += "?"
            }
        }
        
        return "insert into \(entity.tableName) (\(columnNames)) values (\(questionMarks))"
    }
    
    class func deleteStatement(entity: XHDBSerializing.Type) -> String {
        return "delete from \(entity.tableName) where \(XHDBAdapter.whereStatement(entity))"
    }
    
    class func updateStatement(entity: XHDBSerializing.Type) -> String {
        let columns = entity.columnsFromProperties.allValues
        var columnNames = ""
        for index in 0..<columns.count {
            
            if(index != columns.count-1) {
                columnNames += "\(columns[index]) = ?, "
            } else {
                columnNames += "\(columns[index]) = ?"
            }
        }
        
        return "update \(entity.tableName) set \(columnNames) where \(XHDBAdapter.whereStatement(entity))"
    }
    
    //查
    class func whereStatement(entity: XHDBSerializing.Type) -> String {
        return "\(entity.primaryKey) = ?"
    }
}
