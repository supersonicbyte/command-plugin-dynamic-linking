// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "command-plugin-dynamic-linking",
    products: [
        // Products can be used to vend plugins, making them visible to other packages.
        .plugin(
            name: "command-plugin-dynamic-linking",
            targets: ["command-plugin-dynamic-linking"]),
    ],
    dependencies: [
        .package(path: "LocalPackages/DynamicLib")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "Core",
            dependencies: [
                .product(name: "DynamicLib", package: "DynamicLib")
            ]
        ),
        .plugin(
            name: "command-plugin-dynamic-linking",
            capability: .command(intent: .custom(
                verb: "command_plugin_dynamic_linking",
                description: "prints hello world"
            )),
            dependencies: [
                "Core"
            ]
        )
    ]
)
