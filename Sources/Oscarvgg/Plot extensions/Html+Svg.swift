//
//  File.swift
//  
//
//  Created by Oscar Gonzalez on 21/02/21.
//

import Foundation
import Plot

public extension HTML {
    
    enum SvgContext: HTMLStylableContext {}
    
}

public typealias SVG = ElementComponent<ElementDefinitions.SVG>

public extension Component {
    /// Add a `width` attribute to the SVG element.
    func width(_ value: Int) -> Component {
        attribute(named: "width", value: String(value))
    }
    
    /// Add a `height` attribute to the SVG element.
    func height(_ value: Int) -> Component {
        attribute(named: "height", value: String(value))
    }
    
    /// Add a `viewBox` attribute to the SVG element.
    func viewBox(_ value: String) -> Component {
        attribute(named: "viewBox", value: value)
    }
    
    /// Add a `fillRule` attribute to the SVG element.
    func fillRule(_ value: String) -> Component {
        attribute(named: "fill-rule", value: value)
    }
    
    /// Add a `clipRule` attribute to the SVG element.
    func clipRule(_ value: String) -> Component {
        attribute(named: "clip-rule", value: value)
    }
}

extension ElementDefinitions {
    /// Definition for the `<svg>` element.
    public enum SVG: ElementDefinition { public static var wrapper = Node.svg }
}

public extension Node where Context == HTML.BodyContext {
    /// Add a `<svg>` HTML element within the current context.
    /// - parameter nodes: The element's attributes and child elements.
    static func svg(_ nodes: Node<HTML.SvgContext>...) -> Node {
        .element(named: "svg", nodes: nodes)
    }
}

public extension Node where Context == HTML.AnchorContext {
    /// Add a `<svg>` HTML element within the current context.
    /// - parameter nodes: The element's attributes and child elements.
    static func svg(_ nodes: Node<HTML.SvgContext>...) -> Node {
        .element(named: "svg", nodes: nodes)
    }
}

public extension Node where Context == HTML.SvgContext {
    /// Add an `<use>` HTML element within the current context.
    static func use(_ attributes: Attribute<HTML.LinkContext>...) -> Node {
        .selfClosedElement(named: "use", attributes: attributes)
    }
    
    /// Add a `width` attribute to the SVG element.
    static func width(_ value: Int) -> Node {
        .attribute(named: "width", value: String(value))
    }
    
    /// Add a `height` attribute to the SVG element.
    static func height(_ value: Int) -> Node {
        .attribute(named: "height", value: String(value))
    }
    
    /// Add a `viewBox` attribute to the SVG element.
    static func viewBox(_ value: String) -> Node {
        .attribute(named: "viewBox", value: value)
    }
    
    /// Add a `fillRule` attribute to the SVG element.
    static func fillRule(_ value: String) -> Node {
        .attribute(named: "fill-rule", value: value)
    }
    
    /// Add a `clipRule` attribute to the SVG element.
    static func clipRule(_ value: String) -> Node {
        .attribute(named: "clip-rule", value: value)
    }
}
