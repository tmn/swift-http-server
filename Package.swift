import PackageDescription

let package = Package(
    name: "SwiftServer",
    targets: [
        Target(
            name: "HTTP",
            dependencies: [.Target(name: "utils"), .Target(name: "libc")]),
        Target(
            name: "utils",
            dependencies: [.Target(name: "libc")]),
        Target(
            name: "examples",
            dependencies: [.Target(name: "HTTP")])
    ]
)
