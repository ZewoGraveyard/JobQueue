import PackageDescription

let package = Package(
    name: "Base64",
    dependencies: [
        .Package(url: "https://github.com/SwiftX/C7.git", majorVersion: 0, minor: 4)
    ]
)
