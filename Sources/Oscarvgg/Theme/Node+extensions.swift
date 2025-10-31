//
//  Node+extensions.swift
//  Oscarvgg
//
//  Created by Oscar Gonzalez on 29/10/25.
//

import Foundation
import Publish
import Plot

private extension Node where Context == HTML.BodyContext {
    static func mainContentWrapper(_ nodes: Node...) -> Node {
        .div(.class("md:container mx-auto pt-10 px-4"), .group(nodes))
    }
    
    static func mainNavigation<T: Website>(
        _ sectionIDs: T.SectionID.AllCases,
        _ selectedSection: T.SectionID?,
        _ context: PublishingContext<T>) -> Node<HTML.BodyContext> {
            return .nav(
                .ul(.forEach(sectionIDs) { section in
                        .li(.a(
                            .class(section == selectedSection ? "selected" : ""),
                            .href(context.sections[section].path),
                            .text(context.sections[section].title)
                        ))
                }
                ))
        }
    
    static func itemList<T: Website>(for items: [Item<T>], on site: T) -> Node {
        return .ul(
            .class("item-list"),
            .forEach(items) { item in
                    .li(.article(
                        .h2(.a(
                            .href(item.path),
                            .text(item.title)
                        )),
                        .tagList(for: item, on: site),
                        .p(.text(item.description))
                    ))
            }
        )
    }
    
    static func tagList<T: Website>(for item: Item<T>, on site: T) -> Node {
        return .ul(.class("tag-list"), .forEach(item.tags) { tag in
                .li(.a(
                    .href(site.path(for: tag)),
                    .text(tag.string)
                ))
        })
    }
    
    static func articleMetadataLine(for item: Item<Oscarvgg>, on site: Oscarvgg) -> Node {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        return
            .div(
                .class("mb-10"),
                .div(
                    .class("my-2 text-sm"),
                    .text("Published on \(dateFormatter.string(from: item.date))")
                ),
                .ul(
                    .class("flex flex-row gap-2 flex-wrap my-2 items-center justify-items-start list-none p-0 m-0 pl-0 mt-0"),
                    .forEach(item.tags) { tag in
                            .li(
                                .class("text-sm p-2 font-medium rounded bg-accent items-center justify-center"),
                                .a(.href("/\(site.path(for: tag))/"), .text(tag.string), .class("text-white no-underline"))
                            )
                    }
                ),
                .unwrap(item.metadata.author, { username in
                        .div(
                            .class("mt-4"),
                            .component(AuthorLine(username: username))
                        )
                })
            )
    }
    
    static func bottomLists<T: Website>(for context: PublishingContext<T>) -> Node {
        let allTags = context
            .allTags
            .sorted { (tag1, tag2) -> Bool in
                return tag1.string < tag2.string
            }
        
        return .div(
            .class("bottom-lists"),
            .div(.class("site-name"),
                 .h2(.text("OscarVGG")),
                 .p(.text(context.site.description))
            ),
            .div(.class("links"),
                 .div(.class("link-list"),
                      .h3(.text("Tags")),
                      .ul(.forEach(allTags) { tag in
                              .li(.a(
                                .href(context.site.path(for: tag)),
                                .text(tag.string)
                              ))
                      })
                 ),
                 .div(.class("link-list"),
                      .h3(.text("Follow")),
                      .ul(
                        .li(.a(
                            .href("https://twitter.com/oscarvgg"),
                            .text("Twitter")
                        )),
                        .li(.a(
                            .href("https://www.linkedin.com/in/oscarvgg"),
                            .text("LinkedIn")
                        )),
                        .li(.a(
                            .href("/feed.rss"),
                            .text("RSS")
                        ))
                      )
                 ),
                 .div(.class("link-list"),
                      .h3(.text("Info")),
                      .ul(
                        .li(.a(
                            .href("/about"),
                            .text("About")
                        )),
                        .li(.a(
                            .href("mailto:contact@oscarvgg.com"),
                            .text("Email")
                        ))
                      )
                 )
            )
        )
    }
    
    static func linkedInTag() -> Node {
        .raw(
                """
                <script type="text/javascript">
                _linkedin_partner_id = "5989689";
                window._linkedin_data_partner_ids = window._linkedin_data_partner_ids || [];
                window._linkedin_data_partner_ids.push(_linkedin_partner_id);
                </script><script type="text/javascript">
                (function(l) {
                if (!l){window.lintrk = function(a,b){window.lintrk.q.push([a,b])};
                window.lintrk.q=[]}
                var s = document.getElementsByTagName("script")[0];
                var b = document.createElement("script");
                b.type = "text/javascript";b.async = true;
                b.src = "https://snap.licdn.com/li.lms-analytics/insight.min.js";
                s.parentNode.insertBefore(b, s);})(window.lintrk);
                </script>
                <noscript>
                <img height="1" width="1" style="display:none;" alt="" src="https://px.ads.linkedin.com/collect/?pid=5989689&fmt=gif" />
                </noscript>
                """
        )
    }
}

public extension Node where Context == HTML.DocumentContext {
    
    static func addScripts() -> Node {
        .group([
            .googleTrackerHead(),
            .microsoftClarityHead(),
            .mailerLiteUniversalHead(),
            .facebookPixel()
        ])
    }
    
    static func googleTrackerHead() -> Node {
        .head(
            .script(.src("https://www.googletagmanager.com/gtag/js?id=G-T0WWL4KDTV")),
            .script(
    """
        window.dataLayer = window.dataLayer || [];
        function gtag(){dataLayer.push(arguments);}
        gtag('js', new Date());
    
        gtag('config', 'G-T0WWL4KDTV');
    """
            ))
    }
    
    static func microsoftClarityHead() -> Node {
        .head(
            .raw(
                """
                <!-- Clarity tracking code for https://align.day/ -->
                <script>
                (function(c,l,a,r,i,t,y){        c[a]=c[a]||function(){(c[a].q=c[a].q||[]).push(arguments)};        t=l.createElement(r);t.async=1;t.src="https://www.clarity.ms/tag/"+i+"?ref=bwt";        y=l.getElementsByTagName(r)[0];y.parentNode.insertBefore(t,y);    })(window, document, "clarity", "script", "irjgxuuujn");
                </script>
                """
            ))
    }
    
    static func mailerLiteUniversalHead() -> Node {
        .head(
            .raw(
        """
            <!-- MailerLite Universal -->
            <script>
                (function(w,d,e,u,f,l,n){w[f]=w[f]||function(){(w[f].q=w[f].q||[])
                .push(arguments);},l=d.createElement(e),l.async=1,l.src=u,
                n=d.getElementsByTagName(e)[0],n.parentNode.insertBefore(l,n);})
                (window,document,'script','https://assets.mailerlite.com/js/universal.js','ml');
                ml('account', '593743');
            </script>
            <!-- End MailerLite Universal -->
        """
            ))
    }
    
    static func facebookPixel() -> Node {
        .head(
            .raw(
            """
                <!-- Meta Pixel Code -->
                <script>
                !function(f,b,e,v,n,t,s)
                {if(f.fbq)return;n=f.fbq=function(){n.callMethod?
                n.callMethod.apply(n,arguments):n.queue.push(arguments)};
                if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';
                n.queue=[];t=b.createElement(e);t.async=!0;
                t.src=v;s=b.getElementsByTagName(e)[0];
                s.parentNode.insertBefore(t,s)}(window, document,'script',
                'https://connect.facebook.net/en_US/fbevents.js');
                fbq('init', '1030949014998046');
                fbq('track', 'PageView');
                </script>
                <noscript><img height="1" width="1" style="display:none"
                src="https://www.facebook.com/tr?id=1030949014998046&ev=PageView&noscript=1"
                /></noscript>
                <!-- End Meta Pixel Code -->
            """
            )
        )
    }
    
    /// Add an HTML `<head>` tag within the current context, based
    /// on inferred information from the current location and `Website`
    /// implementation.
    /// - parameter location: The location to generate a `<head>` tag for.
    /// - parameter site: The website on which the location is located.
    /// - parameter titleSeparator: Any string to use to separate the location's
    ///   title from the name of the website. Default: `" | "`.
    /// - parameter stylesheetPaths: The paths to any stylesheets to add to
    ///   the resulting HTML page. Default: `styles.css`.
    /// - parameter rssFeedPath: The path to any RSS feed to associate with the
    ///   resulting HTML page. Default: `feed.rss`.
    /// - parameter rssFeedTitle: An optional title for the page's RSS feed.
    static func head<T: Website>(
        for location: Location,
        on site: T,
        addTrailingSlashToCanonical: Bool,
        titleSeparator: String = " | ",
        stylesheetPaths: [Path] = ["/styles.css"],
        rssFeedPath: Path? = .defaultForRSSFeed,
        rssFeedTitle: String? = nil
    ) -> Node {
        var title = location.title
        
        if location is TagListPage {
            title = "All Tags "
            title.append(titleSeparator + site.name)
        } else if let tagPage = location as? TagDetailsPage {
            title = "\(tagPage.tag.string.capitalized) "
            title.append(titleSeparator + site.name)
        } else if title.isEmpty {
            title = site.name
        } else {
            title.append(titleSeparator + site.name)
        }
        
        var description = location.description
        
        if description.isEmpty {
            description = site.description
        }
        
        return .head(
            .encoding(.utf8),
            .siteName(site.name),
            .url(site.url(for: location), addTrailingSlashToCanonical: addTrailingSlashToCanonical),
            .title(title),
            .description(description),
            .twitterCardType(location.imagePath == nil ? .summary : .summaryLargeImage),
            .forEach(stylesheetPaths, { .stylesheet($0) }),
            .viewport(.accordingToDevice),
            .caveatFont(),
            .unwrap(site.favicon, { .favicon($0) }),
            .unwrap(rssFeedPath, { path in
                let title = rssFeedTitle ?? "Subscribe to \(site.name)"
                return .rssFeedLink(path.absoluteString, title: title)
            }),
            .unwrap(location.imagePath ?? site.imagePath, { path in
                let url = site.url(for: path)
                return .socialImageLink(url)
            })
        )
    }
}

public extension Node where Context == HTML.HeadContext {
    /// Declare the HTML page's canonical URL, for social sharing and SEO.
    /// - parameter url: The URL to declare as this document's canonical URL.
    static func url(_ url: URLRepresentable, addTrailingSlashToCanonical: Bool) -> Node {
        var url = url.description
        
        if addTrailingSlashToCanonical {
            url += "/"
        }
        
        return .group([
            .link(.rel(.canonical), .href(url)),
            .meta(.name("twitter:url"), .content("\(url)")),
            .meta(.property("og:url"), .content("\(url)"))
        ])
    }
    
    static func caveatFont() -> Node {
        return .raw("""
                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                <link href="https://fonts.googleapis.com/css2?family=Caveat:wght@500&display=swap" rel="stylesheet">
            """)
    }
}
