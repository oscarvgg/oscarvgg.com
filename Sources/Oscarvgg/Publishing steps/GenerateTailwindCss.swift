//
//  GenerateTailwindCss.swift
//  Oscarvgg.com
//
//  Created by Oscar Gonzalez on 29/10/25.
//

import Publish
import ShellOut
import Foundation

extension PublishingStep where Site == Oscarvgg {
    static var generateTailwindCSS: Self {
        .step(named: "Generate Tailwind CSS") { context in
            let rootPath = try context.folder(at: "/").path
            let themePath = try context.folder(at: "Sources/Theme").path
            let cssPath = themePath + "theme.css"
            let resourcesPath = try context.folder(at: "Resources").path
            let cssOutputPath = resourcesPath + "styles.css"
            let nodeDir = "/usr/local/bin/"
            let npxPath = "/usr/local/bin/npx"
            
            let process = Process()
            process.currentDirectoryURL = URL(fileURLWithPath: rootPath)
            
            let env = ProcessInfo.processInfo.environment
            process.environment = ["PATH": "\(nodeDir):\(env["PATH"] ?? "")"]
            
            process.executableURL = URL(fileURLWithPath: npxPath)
            process.arguments = ["tailwindcss", "-i", cssPath, "-o", cssOutputPath]
            
            try process.run()
            process.waitUntilExit()
            
            if process.terminationStatus != 0 {
                throw PublishingError(infoMessage: "Failed to generate tailwind css.")
            }
        }
    }
}
