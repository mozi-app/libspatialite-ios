libspatialite-ios
=================

This is a fork of [libspatialiate-ios](https://github.com/gstf/libspatialite-ios) containing
additional impprovements and bugfixes from the following forks:

 * https://github.com/davenquinn/libspatialite-ios
 * https://github.com/smellman/libspatialite-ios
 * https://github.com/iulian0512/libspatialite-ios

This fork adds support for a single xcframework target containing support for:
 * macOS
 * iOS
 * iOS Simulator

**Additionally, this fork removes the build for SQLite itself and instead uses
the system version of SQLite.** The system version of SQLite is intended to be
dynamically linked, so it is not necessary to statically link it.

**This fork is compatible with GRDB**

**There is no longer support for AMD64/X86_64 simulators.**

Requirements
------------
Xcode 16+ with Command Line Tools installed.

Installation
------------
Building the framework will take some time, but is invoked simply by running:
```
make
```

Note that the `Makefile` has been optimized for a system with 12 cores.
