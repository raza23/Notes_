//
//  Note.swift
//  Notes_
//
//  Created by Raza Shareef on 5/11/20.
//  Copyright © 2020 raza_s. All rights reserved.
//

import Foundation
import SQLite3

struct Note {
    let id: Int
    var contents: String
}

class NoteManager {
    var database: OpaquePointer!
    
    static let main = NoteManager()
    
    private init() {
    }
    
    func connect(){
        if database != nil {
            return
        }
        do{
            let databaseUrl = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("notes.sqlite3")
            
            if sqlite3_open(databaseUrl.path, &database) == SQLITE_OK {
                if sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS notes (contents TEXT)", nil, nil, nil) == SQLITE_OK {
                    
                } else { print ("cant create table")}
                
            } else {
                print("Cant connect")
            }
        }
        catch let error {
            print ("Cant create DB")
        }
    }
    
    func create() -> Int {
        connect()
        var statement: OpaquePointer!
        
        
        
        if sqlite3_prepare_v2(database, "INSERT INTO notes (contents) VALUES ('New Note')", -1, &statement, nil) != SQLITE_OK {
            print("cant create query")
            return -1
                
            }
        if sqlite3_step(statement) != (SQLITE_DONE) {
            print ("cant create note")
            return -1
        }
        sqlite3_finalize(statement)
        return Int(sqlite3_last_insert_rowid(database))
    }
    
    func getAllNotes() -> [Note] {
        
        var result: [Note] = []
        connect()
        var statement: OpaquePointer!
        if sqlite3_prepare(database, "SELECT rowid,contents FROM notes", -1, &statement, nil) != SQLITE_OK {
            print ("error selecting")
            return []
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            result.append(Note(id: Int(sqlite3_column_int(statement, 0)), contents: String(cString: sqlite3_column_text(statement, 1))))
        }
        sqlite3_finalize(statement)
        return result
        
    }
    
    func save(note: Note) {
        connect()
        
        var statement: OpaquePointer!
        if sqlite3_prepare(database, "UPDATE notes SET contents = ? WHERE rowid = ?", -1, &statement, nil) != SQLITE_OK {
            print ("error while updating")
            
        }
        
        sqlite3_bind_text(statement, 1, NSString(string: note.contents).utf8String, -1, nil)
        sqlite3_bind_int(statement,2, Int32(note.id))
        if sqlite3_step(statement) != SQLITE_DONE {
            print ("error running update")
        }
        
        sqlite3_finalize(statement)
    }
}
            
            
        
            
       
            

