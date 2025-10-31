//
//  File.swift
//
//
//  Created by Oscar Gonzalez on 24/07/23.
//

import Foundation
import Plot
import Publish

struct NavigationBar<T>: Component where T: Website {

    private let selectedSection: T.SectionID?
    private let context: PublishingContext<T>

    init(selectedSection: T.SectionID? = nil, context: PublishingContext<T>) {
        self.selectedSection = selectedSection
        self.context = context
    }

    var body: Component {

        Div {
            Div {
                Link(url: "/") {
                    Text("oscarvgg")
                }
                .class("btn btn-ghost normal-case text-2xl")
            }
            .class("flex-1")

            Navigation {
                //                List(T.SectionID.allCases) { section in
                //                    ListItem {
                //                        Link(url: "/\(context.sections[section].path.string)/") {
                //                            Text(context.sections[section].title)
                //                        }
                //                    }
                //                    .class(section == selectedSection ? "selected" : "")
                //                }
//                List {
//                    ListItem {
//                        Link(url: "/blog/") {
//                            Text("Blog")
//                        }
//                    }
//                    ListItem {
//                        Link(url: "/help/") {
//                            Text("Help")
//                        }
//                    }
//                    ListItem {
//                        Link(url: "/about/") {
//                            Text("About")
//                        }
//                    }
//                    .class(section == selectedSection ? "selected" : "")
//                }
//                .class("menu menu-horizontal px-1")
            }
            .class("flex-none")
        }
        .class("navbar container mx-auto")
    }
}
