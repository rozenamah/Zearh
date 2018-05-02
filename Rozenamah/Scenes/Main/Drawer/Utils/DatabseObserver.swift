//
//  DatabseObserver.swift
//  Rozenamah
//
//  Created by Łukasz Drożdż on 02.05.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import Foundation
import FirebaseDatabase


struct DatabaseObserver: Hashable {
    
    // We store all observers here
    static fileprivate var observers = Set<DatabaseObserver>()
    
    let ref: DatabaseReference
    let handle: UInt
    private let key: String
    
    init(ref: DatabaseReference, handle: UInt) {
        self.ref = ref
        self.handle = handle
        self.key = ref.childByAutoId().key // We us it key to be able to hash
        
        DatabaseObserver.observers.insert(self)
    }
    
    func remove() {
        // Remove handler on this observer
        ref.removeObserver(withHandle: handle)
        
        // Remove from observers
        DatabaseObserver.observers.remove(self)
    }
    
    static func removeAll() {
        // Remove all observers, we use it before logout
        for observer in observers {
            observer.remove()
        }
    }
    
    static func ==(lhs: DatabaseObserver, rhs: DatabaseObserver) -> Bool{
        return lhs.key == rhs.key
    }
    
    var hashValue: Int {
        return key.hashValue
    }
    
}
