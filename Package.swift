// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CommandLineTool",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/msmigowski/CoreXLSX.git",
                 .branch("feature/reseting_codables")),
        .package(url: "https://github.com/stencilproject/Stencil.git",
                 .upToNextMajor(from: "0.3.1")),
        .package(url: "https://github.com/jpsim/Yams.git",
                 .upToNextMajor(from: "1.0.1")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "CommandLineTool",
            dependencies: ["CommandLineToolCore"]),
        .target(
            name: "CommandLineToolCore",
            dependencies: ["CoreXLSX", "Stencil", "Yams"])
    ]
)
