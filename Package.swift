// swift-tools-version:5.9
import PackageDescription

let package = Package(
  name: "libspatialite",
  platforms: [.iOS(.v17), .macOS(.v12)],
  products: [
    .library(name: "SpatialiteObjC", type: .dynamic, targets: ["SpatialiteObjC"]),
    .library(name: "libspatialite", targets: ["libspatialite"]),
  ],
  targets: [
    .binaryTarget(
      name: "libspatialite",
      url: "https://github.com/mozi-app/libspatialite-ios/releases/download/v0.2.0/libspatialite.xcframework.zip",
      checksum: "aa5164d10e594acf80fdce4a691611290995749761a8fad63476d92e25cb81d6"
    ),
    .target(
      name: "SpatialiteObjC",
      dependencies: [
        "libspatialite"
      ],
      path: "Sources/SpatialiteObjC",
      exclude: [],
      sources: ["LibSpatialite.m"],
      linkerSettings: [
        .linkedLibrary("z"),
        .linkedLibrary("iconv"),
        .linkedLibrary("c++"),
        .linkedLibrary("sqlite3"),
      ]
    ),
  ]
)
