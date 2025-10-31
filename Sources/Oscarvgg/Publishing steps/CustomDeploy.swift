//
//  CustomDeploy.swift
//  
//
//  Created to fix Publish deploy path bug
//

import Foundation
import Publish
import Files

// DeploymentMethod variant so Publish runs it only with --deploy / -d
extension DeploymentMethod where Site == Oscarvgg {
    static func customGitHub(_ repository: String, branch: String, useSSH: Bool) -> Self {
        DeploymentMethod(name: "Deploy to GitHub") { context in
            let outputPath = try context.outputFolder(at: "/").path
            let publishPath = outputPath.replacingOccurrences(of: "/Output", with: "/.publish")
            let gitDeployPath = "\(publishPath)/GitDeploy"
            
            // Create .publish/GitDeploy directory if it doesn't exist
            let fileManager = FileManager.default
            try? fileManager.createDirectory(atPath: publishPath, withIntermediateDirectories: true)
            
            // Clone or update the git repository
            let repoURL = useSSH ? "git@github.com:\(repository).git" : "https://github.com/\(repository).git"
            
            if fileManager.fileExists(atPath: gitDeployPath) {
                // Pull latest changes
                let pullProcess = Process()
                pullProcess.currentDirectoryURL = URL(fileURLWithPath: gitDeployPath)
                pullProcess.executableURL = URL(fileURLWithPath: "/usr/bin/git")
                pullProcess.arguments = ["pull", "origin", branch]
                try pullProcess.run()
                pullProcess.waitUntilExit()
            } else {
                // Clone the repository
                let cloneProcess = Process()
                cloneProcess.currentDirectoryURL = URL(fileURLWithPath: publishPath)
                cloneProcess.executableURL = URL(fileURLWithPath: "/usr/bin/git")
                cloneProcess.arguments = ["clone", "--branch", branch, repoURL, "GitDeploy"]
                try cloneProcess.run()
                cloneProcess.waitUntilExit()
            }
            
            // Remove all files except .git
            let contents = try fileManager.contentsOfDirectory(atPath: gitDeployPath)
            for item in contents where item != ".git" {
                try fileManager.removeItem(atPath: "\(gitDeployPath)/\(item)")
            }
            
            // Copy Output contents to GitDeploy using rsync to preserve structure
            let rsyncProcess = Process()
            rsyncProcess.executableURL = URL(fileURLWithPath: "/usr/bin/rsync")
            rsyncProcess.arguments = ["-av", "--exclude=.DS_Store", "\(outputPath)/", "\(gitDeployPath)/"]
            try rsyncProcess.run()
            rsyncProcess.waitUntilExit()
            
            if rsyncProcess.terminationStatus != 0 {
                throw PublishingError(infoMessage: "Failed to copy files to GitDeploy")
            }
            
            // Git add, commit, and push
            let addProcess = Process()
            addProcess.currentDirectoryURL = URL(fileURLWithPath: gitDeployPath)
            addProcess.executableURL = URL(fileURLWithPath: "/usr/bin/git")
            addProcess.arguments = ["add", "-A"]
            try addProcess.run()
            addProcess.waitUntilExit()
            
            let commitProcess = Process()
            commitProcess.currentDirectoryURL = URL(fileURLWithPath: gitDeployPath)
            commitProcess.executableURL = URL(fileURLWithPath: "/usr/bin/git")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let commitMessage = "Publish deploy \(dateFormatter.string(from: Date()))"
            commitProcess.arguments = ["commit", "-m", commitMessage]
            try commitProcess.run()
            commitProcess.waitUntilExit()
            
            let pushProcess = Process()
            pushProcess.currentDirectoryURL = URL(fileURLWithPath: gitDeployPath)
            pushProcess.executableURL = URL(fileURLWithPath: "/usr/bin/git")
            pushProcess.arguments = ["push", "origin", branch]
            try pushProcess.run()
            pushProcess.waitUntilExit()
            
            if pushProcess.terminationStatus != 0 {
                throw PublishingError(infoMessage: "Failed to push to GitHub")
            }
        }
    }
}

