//
//  MessageDataModel.swift
//  TwitterSampleApp
//
//  Created by Tomoko Tobita on 2022/08/04.
//

import Foundation
import RealmSwift

class MessageDataModel: Object {
    @objc dynamic var id: String = UUID().uuidString //データの編集や削除を行うために識別子をつける
    @objc dynamic var user: String = ""
    @objc dynamic var text: String = ""
    @objc dynamic var recordDate: Date = Date()
}
