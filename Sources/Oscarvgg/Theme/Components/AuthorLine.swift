//
//  File.swift
//  
//
//  Created by Oscar Gonzalez on 12/09/23.
//

import Plot
import Foundation

struct AuthorLine: Component {
    
    let author: Author
    let username: Username
    
    internal init(username: Username) {
        self.username = username
        self.author = Author(username: username)
    }
    
    var body: Component {
        Link(url: "/authors/\(author.pageName)/") {
            Avatar(gravatarHash: author.gravatarHash, size: .small)
            
            Div {
                Paragraph("written by \(author.displayName)")
                    .class("text-base-content text-sm")
            }
            .class("text-left")
        }
        .class("inline-flex items-center justify-center")
    }
}

struct Avatar: Component {
    
    enum Size {
        case small
        case large
        
        var gravatarSize: Int {
            switch self {
            case .small:
                return 40
            case .large:
                return 200
            }
        }
        
        var classSize: String {
            switch self {
            case .small:
                return /*class*/ "w-12 h-12"
            case .large:
                return  /*class*/ "w-48 h-48"
            }
        }
    }
    
    let gravatarHash: String
    let size: Size
    
    var body: Component {
        Div {
            Div {
                Image(url: "https://www.gravatar.com/avatar/\(gravatarHash)?s=\(size.gravatarSize)",
                description: "Author's bio")
            }
            .class("\(size.classSize) rounded-full")
        }
        .class("avatar mr-3")
    }
}
