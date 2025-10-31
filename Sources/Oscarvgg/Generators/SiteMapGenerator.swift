//
//  File.swift
//  
//
//  Created by Oscar Gonzalez on 13/09/23.
//

import Plot
import Publish
import Foundation

struct OscarvggSiteMapGenerator<Site: Website> {
    let excludedPaths: Set<Publish.Path>
    let indentation: Indentation.Kind?
    let context: PublishingContext<Site>

    func generate() throws {
        let sections = context.sections.sorted {
            $0.id.rawValue < $1.id.rawValue
        }

        let pages = context.pages.values.sorted {
            $0.path < $1.path
        }

        let siteMap = makeSiteMap(for: sections, pages: pages, site: context.site)
        let xml = siteMap.render(indentedBy: indentation)
        let file = try context.createOutputFile(at: "sitemap.xml")
        try file.write(xml)
    }
}

private extension OscarvggSiteMapGenerator {
    func shouldIncludePath(_ path: Publish.Path) -> Bool {
        !excludedPaths.contains(where: {
            path.string.hasPrefix($0.string)
        })
    }

    func makeSiteMap(for sections: [Publish.Section<Site>], pages: [Page], site: Site) -> Plot.SiteMap {
        Plot.SiteMap(
            .forEach(sections) { section in
                guard shouldIncludePath(section.path) else {
                    return .empty
                }

                return .group(
                    .url(
                        .loc("\(site.url(for: section))/"),
                        .changefreq(.daily),
                        .priority(1.0),
                        .lastmod(max(
                            section.lastModified,
                            section.lastItemModificationDate ?? .distantPast
                        ))
                    ),
                    .forEach(section.items) { item in
                        guard shouldIncludePath(item.path) else {
                            return .empty
                        }

                        return .url(
                            .loc("\(site.url(for: item))/"),
                            .changefreq(.monthly),
                            .priority(0.5),
                            .lastmod(item.lastModified)
                        )
                    }
                )
            },
            .forEach(pages) { page in
                guard shouldIncludePath(page.path) else {
                    return .empty
                }

                return .url(
                    .loc("\(site.url(for: page))/"),
                    .changefreq(.monthly),
                    .priority(0.5),
                    .lastmod(page.lastModified)
                )
            }
        )
    }
}
