// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SessionData",
  platforms: [
    .iOS(.v14),
    .macOS(.v11),
    .tvOS(.v14),
    .watchOS(.v7),
  ],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "SessionData",
      targets: ["SessionData"])
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "SessionData",
      resources: [
        .copy("../../speakers.json"),
        .copy("../../speakers_en.json"),
        .copy("../../speakers_jp.json"),
        .copy("../../schedule.json"),
        .copy("../../schedule_en.json"),
        .copy("../../schedule_jp.json"),
        .copy("../../sponsors.json"),
        .copy("../../staffs.json"),
        .copy("../../links.json"),
      ]
    ),
    .testTarget(
      name: "SessionDataTests",
      dependencies: ["SessionData"],
      resources: [
        // Keep the relative path because other projects fetch the resources from the root of the project
        .copy("../../speakers.json"),
        .copy("../../speakers_en.json"),
        .copy("../../speakers_jp.json"),
        .copy("../../schedule.json"),
        .copy("../../schedule_en.json"),
        .copy("../../schedule_jp.json"),
        .copy("../../sponsors.json"),
        .copy("../../staffs.json"),
        .copy("../../links.json"),
      ]
    ),
  ]
)
