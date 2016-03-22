
XHDBManager
------------

XHDBManager is a database manager object based on FMDB, which is a nice Objective-C wrapper around SQLite. It can automaticly map the entities to the database tables and retrieve the entity back from tables(like the ActiveRecord in the server side).

Example
------------

if you have a User entity, it maybe looked like below:

```
class User: NSObject {
    var ID: String   = ""
    var name: String = ""
    var age: Int     = 0
}
   


```


Features
------------

Rules
------------

1. Your entity class should conform the XHDBAdapter protocol.
2. The statements of creating table should keep in the file named "create_(tableName).sql", such as "create_user.sql"













