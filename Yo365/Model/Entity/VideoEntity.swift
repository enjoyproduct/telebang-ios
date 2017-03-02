//
//  VideoEntity.swift
//  Yo365
//
//  Created by Billy on 2/28/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import Foundation
import RealmSwift

public class VideoEntity: Object {
    dynamic var videoID: Int = 0
    dynamic var videoName: String = ""
    dynamic var videoThumbnail: String = ""
    dynamic var videoSeries: String = ""
    dynamic var videoCreateAt: String = ""
    dynamic var userID: Int = 0
    
    func save() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(self)
            }
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
    
    func delete() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(self)
            }
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
}
