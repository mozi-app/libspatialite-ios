// swift-tools-version:5.9
import PackageDescription

let package = Package(
  name: "libspatialite-Package",
  platforms: [.iOS(.v17)],
  products: [
    // .library(name: "SpatialiteObjC", type: .dynamic, targets: ["SpatialiteObjC", "libspatialite"]),
    .library(name: "MyLibrary", targets: ["libspatialite", "MyLibrary"]),
  ],
  dependencies: [],
  targets: [
    // .binaryTarget(
    //   name: "libspatialite",
    //   url: "https://github.com/mozi-app/libspatialite-ios/releases/download/v5.1.0/libspatialite.xcframework.zip",
    //   checksum: "f152b53c5c042544ec1d97eb50be1f8d129c6d2b33a2b627322930997ffe24ba"
    // ),
    .target(
            name: "MyLibrary"
        ),
    .binaryTarget(
        name: "libspatialite",
        path: "./libspatialite.xcframework"
    ),

    // .target(
    //   name: "SpatialiteObjC",
    //   dependencies: [
    //     "libspatialite"
    //   ],
    //   path: "Sources/SpatialiteObjC",
    //   sources: ["LibSpatialite.m"],
    //   // publicHeadersPath: ".",
    //   cSettings: [
    //       .headerSearchPath("../../.build/artifacts/v3-libspatialite-ios/libspatialite/libspatialite.xcframework/ios-arm64/Headers"),
    //   //     // .define("SPATIALITE_USE_ICONV", to: "1"), // Example for adding macros
    //   //     .unsafeFlags(["-L$../../.build/artifacts/v3-libspatialite-ios/libspatialite/libspatialite.xcframework/ios-arm64"], .when(platforms: [.iOS])),
    //   ],
    //   linkerSettings: [
    //     // .linkedFramework("CoreFoundation"),
    //     // .linkedFramework("libspatialite"),
    //     .linkedLibrary("z"),
    //     .linkedLibrary("iconv"),
    //     .linkedLibrary("c++"),
    //     // .unsafeFlags(["-L$../../.build/artifacts/v3-libspatialite-ios/libspatialite/libspatialite.xcframework/ios-arm64"], .when(platforms: [.iOS])),
    //   ]
    // ),
  ]
)
