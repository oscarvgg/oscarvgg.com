//
//  File.swift
//  
//
//  Created by Oscar Gonzalez on 26/07/23.
//

import Foundation
import Plot

extension HTML {
    enum Section {}
}

public typealias Section = ElementComponent<ElementDefinitions.Section>

extension ElementDefinitions {
    /// Definition for the `<section>` element.
    public enum Section: ElementDefinition { public static var wrapper = Node.section }
}

extension Node where Context == HTML.BodyContext {
    static func section(_ nodes: Node<HTML.BodyContext>...) -> Self {
        .element(named: "section", nodes: nodes)
    }
}
