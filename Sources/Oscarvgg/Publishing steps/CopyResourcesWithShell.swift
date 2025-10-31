//
//  File.swift
//  
//
//  Created by Oscar Gonzalez on 13/09/23.
//

import Foundation
import Publish

extension PublishingStep where Site == Oscarvgg {
  static var copyResourcesWithShell: Self {
    step(named: "Copy Resources Manually") { context in
      let resourcesPath = try context.folder(at: "Resources").path.replacingOccurrences(of: " ", with: "\\ ")
      let outputPath = try context.outputFolder(at: "/").path.replacingOccurrences(of: " ", with: "\\ ")
      
      let process = Process()
      process.executableURL = URL(fileURLWithPath: "/bin/bash")
      process.arguments = ["-c", "cp -R \(resourcesPath)/ \(outputPath)/"]
      
      try process.run()
      process.waitUntilExit()
      
      if process.terminationStatus != 0 {
        throw PublishingError(infoMessage: "Failed to copy resources using cp command.")
      }
    }
  }
}
