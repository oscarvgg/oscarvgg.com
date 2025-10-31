//
//  File.swift
//  
//
//  Created by Oscar Gonzalez on 12/09/23.
//

import Foundation

struct Author {
    let pageName: String
    let displayName: String
    let gravatarHash: String
}

enum Username: String, Decodable {
    case oscarvgg
}

extension Author {
    init(username: Username) {
        switch username {
        case .oscarvgg:
            self.init(
                pageName: "oscar-vicente-gonzalez-greco",
                displayName: "Oscar Vicente Gonzalez Greco",
                gravatarHash: "aa59488aa5bff84d04af399e4135a10e104192dd3512f4643ae961d3c890c6aa"
            )
        }
    }
}
