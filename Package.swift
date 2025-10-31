// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "Oscarvgg",
    platforms: [.macOS(.v12)],
    products: [
        .executable(
            name: "Oscarvgg",
            targets: ["Oscarvgg"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/johnsundell/publish.git", from: "0.9.0")
    ],
    targets: [
        .executableTarget(
            name: "Oscarvgg",
            dependencies: [
                .product(name: "Publish", package: "publish")
            ]
        )
    ]
)
