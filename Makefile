XCODE_DEVELOPER = $(shell xcode-select --print-path)
#used for selecting the sdk dir
IOS_PLATFORM ?= iPhoneOS

# Pick latest SDK in the directory
IOS_PLATFORM_DEVELOPER = ${XCODE_DEVELOPER}/Platforms/${IOS_PLATFORM}.platform/Developer
IOS_SDK = ${IOS_PLATFORM_DEVELOPER}/SDKs/$(shell ls ${IOS_PLATFORM_DEVELOPER}/SDKs | sort -r | head -n1)


all: build_arches
	${CURDIR}/./run_make_framework.sh
	
# Build separate architectures
# see https://www.innerfence.com/howto/apple-ios-devices-dates-versions-instruction-sets
build_arches:
	${MAKE} arch IOS_ARCH=arm64 IOS_PLATFORM=MacOSX OSX_HOST=arm-apple-darwin OSX_TARGET=arm64-apple-macos12.0 IOS_ARCH_DIR=arm64-macos OS_TARGET=Darwin
	${MAKE} arch IOS_ARCH=arm64 IOS_PLATFORM=iPhoneOS IOS_HOST=arm-apple-darwin IOS_TARGET=arm64-apple-ios17.0 IOS_ARCH_DIR=arm64-ios OS_TARGET=iOS
	${MAKE} arch IOS_ARCH=arm64 IOS_PLATFORM=iPhoneSimulator IOS_HOST=arm-apple-darwin IOS_TARGET=arm64-apple-ios17.0-simulator IOS_ARCH_DIR=arm64-sim OS_TARGET=iOS

BUILD_DIR = ${CURDIR}/build
PREFIX = ${BUILD_DIR}/${IOS_ARCH_DIR}
LIBDIR = ${PREFIX}/lib
BINDIR = ${PREFIX}/bin
INCLUDEDIR = ${PREFIX}/include
UTHASHDIR = ${CURDIR}/uthash

CXX = ${XCODE_DEVELOPER}/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++
CC = ${XCODE_DEVELOPER}/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang
CFLAGS =-target "${IOS_TARGET}${OSX_TARGET}" -isysroot ${IOS_SDK} -I${IOS_SDK}/usr/include -I${INCLUDEDIR} -I${UTHASHDIR} -Os -fembed-bitcode
CXXFLAGS =-target "${IOS_TARGET}${OSX_TARGET}" -stdlib=libc++ -std=c++11 -isysroot ${IOS_SDK} -I${IOS_SDK}/usr/include -I${INCLUDEDIR} -I${UTHASHDIR} -Os -fembed-bitcode
LDFLAGS =-stdlib=libc++ -isysroot ${IOS_SDK} -L${LIBDIR} -L${IOS_SDK}/usr/lib -arch ${IOS_ARCH}

arch: ${LIBDIR}/libspatialite.a

${LIBDIR}/libspatialite.a: ${LIBDIR}/libproj.a ${LIBDIR}/libgeos.a ${LIBDIR}/rttopo.a ${LIBDIR}/libicu.a ${CURDIR}/spatialite
	cd spatialite && env \
	CXX=${CXX} \
	CC=${CC} \
	CFLAGS="${CFLAGS}" \
	CXXFLAGS="${CXXFLAGS}" \
	LDFLAGS="${LDFLAGS} -liconv -lgeos -lgeos_c -lc++ -licudata -licui18n -licuuc -lsqlite3" \
	./configure --host=${IOS_HOST} \
	--prefix=${PREFIX} \
	--with-geosconfig=${BINDIR}/geos-config \
	--disable-freexl \
    --disable-minizip \
    --disable-gcov \
    --disable-examples \
    --disable-libxml2 \
    --disable-shared \
	--disable-dynamic-extensions \
	&& make clean install-strip

${CURDIR}/spatialite:
	curl http://www.gaia-gis.it/gaia-sins/libspatialite-sources/libspatialite-5.1.0.tar.gz > spatialite.tar.gz
	tar -xzf spatialite.tar.gz
	rm spatialite.tar.gz
	mv libspatialite-5.1.0 spatialite
	./patch-spatialite
	./change-deployment-target spatialite

${CURDIR}/rttopo:
	curl -L https://download.osgeo.org/librttopo/src/librttopo-1.1.0.tar.gz > rttopo.tar.gz
	tar -xzf rttopo.tar.gz
	rm rttopo.tar.gz
	mv librttopo-1.1.0 rttopo
	./change-deployment-target rttopo

${LIBDIR}/rttopo.a: ${CURDIR}/rttopo
	cd rttopo && env \
	CXX=${CXX} \
	CC=${CC} \
	CFLAGS="${CFLAGS}" \
	CXXFLAGS="${CXXFLAGS}" \
	LDFLAGS="${LDFLAGS} -liconv -lgeos -lgeos_c -lc++" \
	./configure --host=${IOS_HOST} \
	--prefix=${PREFIX} \
	--disable-shared \
	--with-geosconfig=${BINDIR}/geos-config \
	&& make install


${LIBDIR}/libproj.a: ${CURDIR}/proj
	cd proj && cmake \
	-DCMAKE_SYSTEM_NAME="${OS_TARGET}" \
	-DCMAKE_CXX_COMPILER="${CXX}" \
	-DCMAKE_C_COMPILER="${CC}" \
	-DCMAKE_C_FLAGS="${CFLAGS}" \
	-DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
	-DCMAKE_INSTALL_PREFIX:PATH="${PREFIX}" \
	-DCMAKE_OSX_ARCHITECTURES=${IOS_ARCH} \
	-DCMAKE_OSX_SYSROOT:PATH="${IOS_SDK}" \
	-DBUILD_APPS=OFF \
	-DBUILD_SHARED_LIBS=OFF \
	-DBUILD_TESTING=OFF \
	-DENABLE_CURL=OFF \
	-DENABLE_TIFF=OFF \
	-DSQLITE3_INCLUDE_DIR=${IOS_SDK}/usr/include \
	&& cmake --build . --config Release -j 12 && cmake --install . --config Release

${CURDIR}/proj:
	curl -L https://download.osgeo.org/proj/proj-9.2.1.tar.gz > proj.tar.gz
	tar -xzf proj.tar.gz
	rm proj.tar.gz
	mv proj-9.2.1 proj

${LIBDIR}/libgeos.a: ${CURDIR}/geos
	cd geos && cmake \
	-DCMAKE_CXX_COMPILER="${CXX}" \
	-DCMAKE_C_COMPILER="${CC}" \
	-DCMAKE_C_FLAGS="${CFLAGS}" \
	-DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
	-DCMAKE_INSTALL_PREFIX:PATH="${PREFIX}" \
	-DCMAKE_OSX_ARCHITECTURES=${IOS_ARCH} \
	-DCMAKE_OSX_SYSROOT:PATH="${IOS_SDK}" -DBUILD_GEOSOP:BOOL=OFF -DBUILD_SHARED_LIBS:BOOL=OFF -DBUILD_TESTING:BOOL=OFF \
	&& cmake --build . --config Release -j 12 && cmake --install . --config Release

${CURDIR}/geos:
	curl https://download.osgeo.org/geos/geos-3.12.0.tar.bz2 > geos.tar.bz2
	tar -xzf geos.tar.bz2
	rm geos.tar.bz2
	mv geos-3.12.0 geos

${LIBDIR}/libicu.a: ${CURDIR}/icu
	mkdir -p "${CURDIR}/icu/build/${IOS_ARCH_DIR}" && cd "${CURDIR}/icu/build/${IOS_ARCH_DIR}" && \
	CXX=${CXX} \
	CC=${CC} \
	CFLAGS="${CFLAGS}" \
	CXXFLAGS="${CXXFLAGS}" \
	LDFLAGS="${LDFLAGS}" \
	${CURDIR}/icu/source/./runConfigureICU MacOSX \
	--host="arm-64-linux" \
	--prefix="${PREFIX}" \
	--with-cross-build="${CURDIR}/icu/build/intermediate_osx" \
	--enable-static \
	--enable-shared=no \
	--enable-extras=no \
	--enable-strict=no \
	--enable-icuio=no \
	--enable-layout=no \
	--enable-layoutex=no \
	--enable-tools=no \
	--enable-tests=no \
	--enable-samples=no \
	--enable-dyload=no \
	--with-data-packaging=archive \
	&& make -j12 install

${CURDIR}/icu:
	curl -L https://github.com/unicode-org/icu/releases/download/release-73-2/icu4c-73_2-src.tgz -o icu.tgz
	tar -xzf icu.tgz
	rm icu.tgz
	ICU_INSTALL_DIR="${CURDIR}/icu" \
	./build_icu_intermediate.sh 



clean:
	rm -rf build geos proj spatialite include lib rttopo sqlite3 libspatialite.xcframework icu
