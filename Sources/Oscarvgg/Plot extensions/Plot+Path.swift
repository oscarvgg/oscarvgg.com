//
//  Plot+Path.swift
//  
//
//  Created by Oscar Gonzalez on 26/07/23.
//

import Foundation
import Plot

public extension HTML {
    
    enum PathContext: HTMLStylableContext {}
    
}

public typealias SvgPath = ElementComponent<ElementDefinitions.SvgPath>

public extension SvgPath {
    /// Add a `d` attribute to the path element.
    func d(_ value: String) -> Component {
        attribute(named: "d", value: value)
    }
}

extension ElementDefinitions {
    /// Definition for the `<path>` element.
    public enum SvgPath: ElementDefinition { public static var wrapper = Node.path }
}

public extension Node where Context == HTML.SvgContext {
    /// Add a `<path>` HTML element within the current context.
    /// - parameter nodes: The element's attributes and child elements.
    static func path(_ nodes: Node<HTML.PathContext>...) -> Node {
        .element(named: "path", nodes: nodes)
    }
}

public extension Node where Context == HTML.PathContext {
    /// Add a `d` attribute to the path element.
    static func d(_ value: String) -> Node {
        .attribute(named: "d", value: value)
    }
}
