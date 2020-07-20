//
//  Note.swift
//  Notes
//
//  Created by Tran Le on 7/20/20.
//  Copyright © 2020 Tran. All rights reserved.
//

import Foundation
import SQLite3

struct Note {
    let id: Int
    var contents: String
}
// handles connecting to db, creating notes, getting notes, and updating notes
class NoteManager {
    // pointer to something that references db
    var database: OpaquePointer!
    // create instance of note manager inside of itself - singleton
    static let main = NoteManager()
    
    private init() {
        
    }
    // connect to db
    func connect() {
        // if already connected, don't do over and over again
        if database != nil {
            return
        }
        do {
            let databaseURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("notes.sqlite3")
            
            if sqlite3_open(databaseURL.path, &database) == SQLITE_OK {
                if sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS notes (contents TEXT)", nil, nil, nil) == SQLITE_OK {
                    
                } else {
                    print("Could not create table")
                }
            } else {
                print("Could not connect")
            }
        } catch let error {
            print("Could not create database")
        }
    }
    // create new note
    func create() -> Int {
        connect()
        // prepare query
        var statement: OpaquePointer!
        if sqlite3_prepare_v2(database, "INSERT INTO notes (contents) VALUES ('New note')", -1, &statement, nil) != SQLITE_OK {
            print("Could not create query")
            return -1
        }
        if sqlite3_step(statement) != SQLITE_DONE {
            print("Could not insert note")
            return -1
        }
        // finalize statement
        sqlite3_finalize(statement)
        return Int(sqlite3_last_insert_rowid(database))
    }
    // get all contents from db
    func getAllNotes() -> [Note] {
        connect()
        
        var result: [Note] = []
        var statement: OpaquePointer!
        
        if sqlite3_prepare_v2(database, "SELECT rowid, contents FROM notes", -1, &statement, nil) != SQLITE_OK {
            print("Error creating select")
            return []
        }
        while sqlite3_step(statement) == SQLITE_ROW {
            // convert to note object
            result.append(Note(id: Int(sqlite3_column_int(statement, 0)), contents: String(cString: sqlite3_column_text(statement, 1))))
        }
        sqlite3_finalize(statement)
        return result
    }
    // save note to db
    func save(note: Note) {
        connect()
        
        var statement: OpaquePointer!
        
        if sqlite3_prepare_v2(database, "UPDATE notes SET contents = ? WHERE rowid = ?", -1, &statement, nil) != SQLITE_OK {
            print("Error creating update statement")
        }
        // bind first parameter
        sqlite3_bind_text(statement, 1, NSString(string: note.contents).utf8String, -1, nil)
        // bind integar/second parameter
        sqlite3_bind_int(statement, 2, Int32(note.id))
        
        if sqlite3_step(statement) != SQLITE_DONE {
            print("Error running update")
        }
        
        sqlite3_finalize(statement)
    }
    // delete notes
    func delete(id: Int) -> Bool {
        connect()
        
        var statement: OpaquePointer!
        
        if sqlite3_prepare_v2(database, "DELETE FROM notes WHERE rowid = ?", -1, &statement, nil) != SQLITE_OK {
            print("Error creating delete statement")
            return false
        }
        sqlite3_bind_int(statement, 1, Int32(id))
        
        if sqlite3_step(statement) != SQLITE_DONE {
            print("Error running delete")
            return false
        }
        sqlite3_finalize(statement)
        return true
    }
}
