//
//  FirestoreUser.swift
//  tinder-clone
//
//  Created by Alejandro Piguave on 3/1/22.
//

import Foundation
import FirebaseFirestoreSwift

public struct FirestoreApprover: Codable, Equatable {
    @DocumentID var id: String?
    let name: String
    let pictures: [String]
    let liked: [String]
    let passed: [String]
    let isactive: Bool = true
    

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case pictures
        case liked
        case passed
        case isactive
    }
}
