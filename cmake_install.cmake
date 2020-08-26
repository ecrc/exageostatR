# Install script for directory: /Users/liy0h/exageostatR/src

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES "/Users/liy0h/exageostatR/libexageostat.dylib")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libexageostat.dylib" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libexageostat.dylib")
    execute_process(COMMAND /usr/bin/install_name_tool
      -delete_rpath "/Library/Frameworks/R.framework/Versions/4.0/Resources/library/00LOCK-exageostatR/00new/exageostatr/lib"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libexageostat.dylib")
    execute_process(COMMAND /usr/bin/install_name_tool
      -add_rpath "/usr/local/lib"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libexageostat.dylib")
    execute_process(COMMAND /usr/bin/install_name_tool
      -add_rpath "/opt/intel/compilers_and_libraries_2019.3.199/mac/mkl/lib"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libexageostat.dylib")
    execute_process(COMMAND /usr/bin/install_name_tool
      -add_rpath "/Library/Frameworks/R.framework/Versions/4.0/Resources/library/00LOCK-exageostatR/00new/exageostatr/lib"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libexageostat.dylib")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libexageostat.dylib")
    endif()
  endif()
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE FILE FILES
    "/Users/liy0h/exageostatR/src/src/include/MLE.h"
    "/Users/liy0h/exageostatR/src/include/context.h"
    "/Users/liy0h/exageostatR/src/include/morse_starpu.h"
    "/Users/liy0h/exageostatR/src/include/descriptor.h"
    "/Users/liy0h/exageostatR/src/include/auxiliary.h"
    "/Users/liy0h/exageostatR/src/include/chameleon_starpu.h"
    "/Users/liy0h/exageostatR/src/include/runtime_codelet_d.h"
    "/Users/liy0h/exageostatR/src/include/common.h"
    "/Users/liy0h/exageostatR/src/include/global.h"
    "/Users/liy0h/exageostatR/src/include/compute_z.h"
    "/Users/liy0h/exageostatR/src/include/compute_s.h"
    "/Users/liy0h/exageostatR/src/include/compute_d.h"
    "/Users/liy0h/exageostatR/src/include/compute_c.h"
    "/Users/liy0h/exageostatR/src/include/tile.h"
    "/Users/liy0h/exageostatR/src/include/async.h"
    "/Users/liy0h/exageostatR/src/exageostat_exact/src/include/MLE_exact.h"
    "/Users/liy0h/exageostatR/src/exageostat_exact/runtime/starpu/include/starpu_exageostat.h"
    "/Users/liy0h/exageostatR/src/exageostat_exact/core/include/exageostatcore.h"
    "/Users/liy0h/exageostatR/src/exageostat_approx/src/include/MLE_approx.h"
    "/Users/liy0h/exageostatR/src/exageostat_approx/runtime/starpu/include/starpu_exageostat_approx.h"
    "/Users/liy0h/exageostatR/src/misc/include/MLE_misc.h"
    "/Users/liy0h/exageostatR/src/misc/include/flat_file.h"
    "/Users/liy0h/exageostatR/src/r-wrappers/include/rwrappers.h"
    "/Users/liy0h/exageostatR/src/include/flops.h"
    "/Users/liy0h/exageostatR/src/exageostat_approx/src/include/diag.h"
    "/Users/liy0h/exageostatR/src/exageostat_approx/src/include/MLE_lr.h"
    )
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig" TYPE FILE FILES "/Users/liy0h/exageostatR/exageostat.pc")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/exageostat" TYPE FILE FILES "/Users/liy0h/exageostatR/config.log")
endif()

if(CMAKE_INSTALL_COMPONENT)
  set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
file(WRITE "/Users/liy0h/exageostatR/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
