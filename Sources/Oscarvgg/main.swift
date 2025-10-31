import Foundation
import Publish
import Plot

// This type acts as the configuration for your website.
struct Oscarvgg: Website {
    
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case posts
        case about
    }

    struct ItemMetadata: WebsiteItemMetadata {
        var author: Username?
    }

    // Website Configuration:
    var url = URL(string: "https://oscarvgg.com")!
    var name = "OscarVGG"
    var description = "A blog about iOS and Swift development"
    var language: Language { .english }
    var imagePath: Path? { nil }

    var favicon: Favicon? {
        return Favicon(path: "favicon.png", type: "image/x-icon")
    }
    
    @discardableResult
    func publish(additionalSteps: [PublishingStep<Self>] = [],
                 plugins: [Plugin<Self>] = [],
                 file: StaticString = #file) throws -> PublishedWebsite<Self> {

        return try publish(
            at: nil,
            using: [
                .group(plugins.map(PublishingStep.installPlugin)),
                .generateTailwindCSS,
                .copyResourcesWithShell,
                .addMarkdownFiles(),
                .sortItems(by: \.date, order: .descending),
                .group(additionalSteps),
                .generateHTML(withTheme: .oscarvgg, indentation: nil),
                .move404FileForGitHubPages(),
                .unwrap(.default) { config in
                    .generateRSSFeed(
                        including: Set(SectionID.allCases),
                        config: config
                    )
                },
                .generateSiteMap(excluding: [Path("404")]),
                .deploy(using: .customGitHub(
                    "oscarvgg/oscarvgg.com",
                    branch: "gh-pages",
                    useSSH: true)
                )
            ],
            file: file
        )
    }
}

// This will generate your website using the built-in Foundation theme:
try Oscarvgg().publish()
