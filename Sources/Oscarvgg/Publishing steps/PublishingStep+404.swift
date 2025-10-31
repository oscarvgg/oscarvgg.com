//
//  File.swift
//  
//
//  Created by Oscar Gonzalez on 13/09/23.
//

import Foundation
import Publish

extension PublishingStep {
    static func move404FileForGitHubPages() -> Self {
        let stepName = "Move 404 file for GitHub Pages"

        return step(named: stepName) { context in
            guard let orig404Page = context.pages["404"] else {
                throw PublishingError(stepName: stepName,
                                      infoMessage: "Unable to find 404 page")
            }

            let orig404File = try context.outputFile(at: "\(orig404Page.path)/index.html")
            try orig404File.rename(to: "404")

            guard
                let orig404Folder = orig404File.parent,
                let outputFolder = orig404Folder.parent,
                let rootFolder = outputFolder.parent
            else {
                throw PublishingError(stepName: stepName,
                                      infoMessage: "Unable find root, output and 404 folders")
            }

            try context.copyFileToOutput(from: "\(orig404File.path(relativeTo: rootFolder))")
            try orig404Folder.delete()
        }
    }
}
