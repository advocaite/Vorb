# check for proper folder structure
macro(verify_folder_structure)
    if (CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
      if (UNIX)  # UNIX should include APPLE and CygWIN
        message("\nRun the build script:  build.sh\n")
      elseif(MSVC)  # Should be all flavors of Microsoft Visual Studio compiler
        message("\nRun the build script:  build.bat\n")
      else()
        message(FATAL_ERROR "\nThis system is unsupported: ${CMAKE_SYSTEM_NAME}\n")
      endif()
      message(FATAL_ERROR "You don't want to configure in the source folder!")
    endif()
endmacro(verify_folder_structure)

macro(initialize_for_platform)
# if(APPLE)
#   LIST(APPEND LDFLAGS "-L/usr/local/opt/llvm/lib")
#   set(CMAKE_C_COMPILER "/usr/local/opt/llvm/bin/clang")
#   set(CMAKE_CXX_COMPILER "/usr/local/opt/llvm/bin/clang++")
# endif(APPLE)
  # setup compilers
  if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU" OR
      "${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
      set(warnings "-Wall"
                   "-Wextra"
                   # "-Wformat=2"
                   # "-Wno-format-nonliteral"
                   # "-Wshadow"
                   # "-Wshorten-64-to-32"
                   # "-Wpointer-arith"
                   # "-Wcast-qual"
                   # "-Wmissing-prototypes"
                   # "-Wno-missing-braces"
                   "-Wno-unknown-pragmas"
                   )
        ADD_DEFINITIONS(
#          -std=c++11
#          -stdlib=libc++
          # Other flags
          ${warnings}
      )
      set(CMAKE_CXX_STANDARD 14)
      #set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

  elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
      set(warnings "/W4 /WX /EHsc")
  endif()

  # platform specific initialization
  IF(APPLE)
    # for policy CMP0042
    SET(CMAKE_SKIP_BUILD_RPATH  TRUE)

    # for moody camel thread_local issues
    REMOVE_DEFINITIONS(-DMOODYCAMEL_CPP11_THREAD_LOCAL_SUPPORTED)
    INCLUDE_DIRECTORIES ( /System/Library/Frameworks )
    INCLUDE_DIRECTORIES ( /usr/local/opt/llvm/include )
    FIND_LIBRARY(COCOA_LIBRARY Cocoa)
    FIND_LIBRARY(GLUT_LIBRARY GLUT )
    FIND_LIBRARY(OpenGL_LIBRARY OpenGL )
    MARK_AS_ADVANCED (COCOA_LIBRARY
                      GLUT_LIBRARY
                      OpenGL_LIBRARY)
    SET(EXTRA_LIBS ${COCOA_LIBRARY} ${GLUT_LIBRARY} ${OpenGL_LIBRARY})
  ENDIF (APPLE)
endmacro(initialize_for_platform)
