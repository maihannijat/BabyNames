//
//  DatabaseManager.swift
//  Baby Names
//
//  Created by Maihan Nijat on 2017-11-06.
//  Copyright © 2017 Sunzala Technology. All rights reserved.
//

import UIKit
import SQLite3

class DatabaseManager {
    
    var databaseUrl: URL?
    var db: OpaquePointer?
    var statement: OpaquePointer?
    var tableName = "names_table"
    
    init() {
        openDatabase()
    }
    
    //MARK: - Open Database
    // Creates database path and call copyDatabase method.
    func openDatabase(){
        do {
            let documentDir = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            databaseUrl = documentDir.appendingPathComponent("database.sqlite3")
        } catch {
            print(error)
        }
        
        copyDatabase()
        
        if sqlite3_open(databaseUrl?.path, &db) != SQLITE_OK {
            print("Error opening the database")
        }
    }
    
    //MARK: - Copy Database
    // Copy the database from bundle to document directory if doesn't exist.
    func copyDatabase(){
        if !( ((try? databaseUrl?.checkResourceIsReachable()) ?? false)!) {
            print("DB does not exist in documents folder")
            
            let databaseBundleUrl = Bundle.main.resourceURL?.appendingPathComponent("database.sqlite3")
            
            do {
                let fileManager = FileManager.default
                try fileManager.copyItem(atPath: (databaseBundleUrl?.path)!, toPath: (databaseUrl?.path)!)
            } catch let error as NSError {
                print("Couldn't copy file to final location! Error:\(error.description)")
            }
        } else {
            print("Database file found at path: \(String(describing: databaseUrl?.path))")
        }
    }
    
    //MARK: - Get Names
    // Get all the names from the table based on query provided
    func getNames(query: String) -> [Name]{
        var queryString: String!
        
        if query == "true" {
            queryString = "select id, name, native, meaning, origin, is_favorite, gender from \(tableName) WHERE is_favorite='\(query)' ORDER BY name ASC"
        } else {
            queryString = "select id, name, native, meaning, origin, is_favorite, gender from \(tableName) WHERE gender='\(query)' ORDER BY name ASC"
        }
        if sqlite3_prepare_v2(db, queryString, -1, &statement, nil) != SQLITE_OK {
            let errorMessage = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select: \(errorMessage)")
        }

        var name = ""
        var native = ""
        var meaning = ""
        var origin = ""
        var isFavorite = ""
        var gender = ""
        
        var names = [Name]()
        
        // Loop through all records and add the instantiated name object to array.
        while sqlite3_step(statement) == SQLITE_ROW {
            
            let id = sqlite3_column_int64(statement, 0)
            
            if let cString = sqlite3_column_text(statement, 1) {
                name = String(cString: cString)
            }
            if let cString = sqlite3_column_text(statement, 2) {
                native = String(cString: cString)
            }
            if let cString = sqlite3_column_text(statement, 3) {
                meaning = String(cString: cString)
            }
            if let cString = sqlite3_column_text(statement, 4) {
                origin = String(cString: cString)
            }
            if let cString = sqlite3_column_text(statement, 5) {
                isFavorite = String(cString: cString)
                if isFavorite == "" {
                    isFavorite = "false"
                }
            }
            if let cString = sqlite3_column_text(statement, 6) {
                gender = String(cString: cString)
            }
            
            // Ignore the name if any value returned nil
            if Int(id) > 0 && name != "" && native != "" && meaning != "" && origin != "" && isFavorite != "" && gender != "" {
                let name = Name(id: Int(id), name: name, native: native, meaning: meaning, origin: origin, isFavorite: Bool(isFavorite)!, gender: gender )
                names.append(name)
            }

        }
        
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }
        
        statement = nil

        return names
    }
    
    //MARK: - Update Favorite
    // Add or remove a name to the favorite list by passing the id
    func updateFavorite(id: Int, value: String){
        
        let updateStatementString = "UPDATE \(tableName) SET is_favorite = '\(value)' WHERE id = \(id);"
        
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                print("Could not update row.")
            }
        } else {
            print("UPDATE statement could not be prepared")
        }
        sqlite3_finalize(updateStatement)
        
        //closeDatabase()
    }
    
    //MARK: - Close Database
    // Free the memory by closing database
    func closeDatabase(){
        if sqlite3_close(db) != SQLITE_OK {
            print("error closing database")
        }
        
        db = nil
    }
    
}
