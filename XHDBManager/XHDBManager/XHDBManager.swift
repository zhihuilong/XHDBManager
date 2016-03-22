//
//  XHDBManager.swift
//  XHDBManager
//
//  Created by Sunny on 12/23/15.
//  Copyright © 2015 Sunny. All rights reserved.
//

//MARK: - Methods
private func DocumentPath(filename: String) -> NSURL {
    return (NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).first?.URLByAppendingPathComponent("\(filename)"))!
}

class XHDBManager: NSObject {
    
    static let sharedManager = XHDBManager()
    
    private let db = FMDatabase(path: DocumentPath("\((NSBundle.mainBundle().infoDictionary!["\(kCFBundleIdentifierKey)"])!).db").path!)
    
    //MARK: - init and deinit
    override init() {
        super.init()
        setupDB()
    }
    
    private func setupDB() {
        db.open()
        createTable(tableName: "user")
    }
    
    deinit {
        db.close()
    }
    
    //MARK: - CURD
    class func insert(entity: XHDBSerializing) {
        let sql = XHDBAdapter.insertStatement(entity.dynamicType)
        let arguments = XHDBAdapter.columnValuesForUpdate(entity) as [AnyObject]
        commonExecute(sql, arguments: arguments)
    }
    
    class func deleteAll(entityType: XHDBSerializing.Type) {
        commonExecute("delete from \(entityType.tableName)", arguments: nil)
    }
    
    class func query(entityType: XHDBSerializing.Type) -> [XHDBSerializing] {
        
        let sql = "select * from \(entityType.tableName)"
        return XHDBManager.commonQuery(entityType, sql: sql)
    }
    
    class func query(entityType: XHDBSerializing.Type, primaryKey: String) -> XHDBSerializing? {
        
        let sql = "select * from \(entityType.tableName) where \(entityType.primaryKey) = \(primaryKey)"
        
        return XHDBManager.commonQuery(entityType, sql: sql).first
    }
    
    //MARK: - bug need fix
    class func update(entity: XHDBSerializing) {
        let sql = XHDBAdapter.updateStatement(entity.dynamicType)
        let arguments = XHDBAdapter.columnValuesForUpdate(entity) as [AnyObject]
        commonExecute(sql, arguments: arguments)
    }
    
    class func delete(entity: XHDBSerializing) {
        let sql = XHDBAdapter.deleteStatement(entity.dynamicType)
        commonExecute(sql, arguments: nil)
    }
    
    //MARK: - private
    private class func commonExecute(sql: String, arguments: [AnyObject]?) {
        print(sql + "\(arguments)\n")
        if XHDBManager.sharedManager.db.executeUpdate(sql, withArgumentsInArray: arguments) {
            print("exucute success\n")
        } else {
            print("exucute error: \(XHDBManager.sharedManager.db.lastErrorMessage())\n")
        }
    }
    
    private class func commonQuery(entityType: XHDBSerializing.Type, sql: String) -> [XHDBSerializing] {
        
        let result = XHDBManager.sharedManager.db.executeQuery(sql, withArgumentsInArray: nil)
        var entities = [XHDBSerializing]()
        
        while (result.next()) {
            let entity = entityType.init(dictionary: result.resultDictionary())
            entities.append(entity)
        }
        return entities
    }
    
    // create table
    private func createTable(tableName tableName: String) {
        if !db.tableExists(tableName) {
            print("create table if it not existed:\(tableName)")
            do {
                let statement = try String(contentsOfFile: NSBundle.mainBundle().pathForResource("create_\(tableName).sql", ofType: nil)!)
                if !db.executeStatements(statement) {
                    print("\ncreate table Error: \(db.lastErrorMessage())")
                } else {
                    print("\ncreate table success")
                }
            } catch {}
        }
    }
}
