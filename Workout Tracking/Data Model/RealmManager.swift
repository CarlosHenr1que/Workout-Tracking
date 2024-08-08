//
//  RealmManager.swift
//  Workout Tracking
//
//  Created by Carlos Henrique Matos Borges on 18/07/24.
//

import Foundation
import RealmSwift

class RealmManager {
    static let shared = RealmManager()
    private var realm: Realm
    
    private init() {
        realm = try! Realm()
    }
    
    func getRealm() -> Realm {
        return realm
    }
    
    func fetchAll<T: Object>(_ objectType: T.Type) -> Results<T> {
        return realm.objects(objectType)
    }
    
    func fetch<T: Object>(_ objectType: T.Type, filter: String, args: Any...) -> Results<T> {
        return realm.objects(objectType).filter(filter, args)
    }
    
    func add(_ object: Object) {
        try! realm.write {
            realm.add(object)
        }
    }
    
    func delete(_ object: Object) {
        try! realm.write {
            realm.delete(object)
        }
    }
    
    func update(_ block: () -> Void) {
        try! realm.write {
            block()
        }
    }
}
