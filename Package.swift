import PackageDescription

let package = Package(
    name: "SwiftServer",
    targets: [
        Target(
            name: "examples",
            dependencies: [.Target(name: "HTTP")]),
        Target(
            name: "HTTP",
            dependencies: [.Target(name: "utils")])
    ]
)
