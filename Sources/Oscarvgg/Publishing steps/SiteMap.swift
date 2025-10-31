//
//  File.swift
//  
//
//  Created by Oscar Gonzalez on 13/09/23.
//

import Foundation
import Publish

extension PublishingStep {
    
    static func generateSiteMap(excluding excludedPaths: Set<Publish.Path> = []) -> Self {
        PublishingStep.step(named: "Generate site map") { context in
            let generator = OscarvggSiteMapGenerator(
                excludedPaths: excludedPaths,
                indentation: nil,
                context: context
            )
            
            try generator.generate()
        }
    }
}
