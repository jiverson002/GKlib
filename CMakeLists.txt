cmake_minimum_required(VERSION 3.10)

# ...
project(GKlib
  VERSION      0.0.1
  DESCRIPTION  "A library of various helper routines and frameworks used by many of the lab's software."
  HOMEPAGE_URL "http://glaros.dtc.umn.edu/gkhome/index.php"
  LANGUAGES    C)

# ...
include(GKlibSystem.cmake)

# Include required CMake modules
include(CheckCSourceCompiles)
include(CheckFunctionExists)
include(CheckIncludeFile)
include(CMakePackageConfigHelpers)
include(GNUInstallDirs)

#-------------------------------------------------------------------------------
# COMMAND-LINE OPTIONS
#-------------------------------------------------------------------------------
option(ASSERT  "turn asserts on"        OFF)
option(ASSERT2 "additional assertions"  OFF)
option(DEBUG   "add debugging support"  OFF)
option(GPROF   "add gprof support"      OFF)
option(GKRAND  "enable GKRAND support"  OFF)
option(GKREGEX "enable GKREGEX support" OFF)
option(OPENMP  "enable OpenMP support"  OFF)
option(PCRE    "enable PCRE support"    OFF)

#-------------------------------------------------------------------------------
# LIBRARY configuration
#-------------------------------------------------------------------------------
add_library(${PROJECT_NAME})

target_sources(${PROJECT_NAME}
  PRIVATE src/b64.c src/blas.c src/cache.c src/csr.c src/error.c src/evaluate.c
          src/fkvkselect.c src/fs.c src/getopt.c src/gk_util.c src/gkregex.c
          src/graph.c src/htable.c src/io.c src/itemsets.c src/mcore.c
          src/memory.c src/pqueue.c src/random.c src/rw.c src/seq.c src/sort.c
          src/string.c src/timers.c src/tokenizer.c)

target_include_directories(${PROJECT_NAME}
  PUBLIC  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src>
          $<INSTALL_INTERFACE:src>)

if(NOT MSVC)
  target_link_libraries(${PROJECT_NAME}
    PUBLIC m)
endif()

set_target_properties(${PROJECT_NAME} PROPERTIES
  SOVERSION ${PROJECT_VERSION_MAJOR}
  VERSION   ${PROJECT_VERSION})

add_library(GKlib::gklib ALIAS ${PROJECT_NAME})

#-------------------------------------------------------------------------------
# OPENMP configuration
#-------------------------------------------------------------------------------
find_package(OpenMP)
if(OpenMP_C_FOUND)
  target_compile_definitions(${PROJECT_NAME}
    PUBLIC __OPENMP__)

  target_link_libraries(${PROJECT_NAME}
    PUBLIC OpenMP::OpenMP_C)
endif()

#-------------------------------------------------------------------------------
# OPTIONS configuration
#-------------------------------------------------------------------------------
if(NOT ASSERT)
  target_compile_definitions(${PROJECT_NAME} PUBLIC NDEBUG)
endif()
if(NOT ASSERT2)
  target_compile_definitions(${PROJECT_NAME} PUBLIC NDEBUG2)
endif()
if(DEBUG)
  target_compile_definitions(${PROJECT_NAME} PUBLIC DEBUG)
endif()
if(GPROF)
  check_c_compiler_flag("-pg" HAS_GPROF_SUPPORT)
  if (HAS_GPROF_SUPPORT)
    target_compile_options(${PROJECT_NAME} PUBLIC "-pg")
  else()
    message(STATUS "GPROF support is not available.")
  endif()
endif()
if(GKRAND)
  target_compile_definitions(${PROJECT_NAME} PUBLIC USE_GKRAND)
endif()
if(GKREGEX)
  target_compile_definitions(${PROJECT_NAME} PUBLIC USE_GKREGEX)
endif()
if(PCRE)
  target_compile_definitions(${PROJECT_NAME} PUBLIC __WITHPCRE__)
endif()

#-------------------------------------------------------------------------------
# FEATURE AVAILABILITY checks
#-------------------------------------------------------------------------------
check_include_file(execinfo.h HAVE_EXECINFO_H)
if(HAVE_EXECINFO_H)
  target_compile_definitions(${PROJECT_NAME} PUBLIC HAVE_EXEC_INFO_H)
endif()

check_function_exists(getline HAVE_GETLINE)
if(HAVE_GETLINE)
  target_compile_definitions(${PROJECT_NAME} PUBLIC HAVE_GETLINE)
endif()

if(NOT DEFINED HAVE_TLS)
  foreach(tls_name "__thread" "__declspec(thread)")
    unset(HAVE_TLS CACHE)
    check_c_source_compiles("${tls_name} int x; int main(void) { return 0; }"
      HAVE_TLS)
    if (HAVE_TLS)
      set(TLS_NAME ${tls_name} CACHE STRING "Thread local keyword")
      break()
    endif()
  endforeach()
endif()
if(HAVE_TLS)
  target_compile_definitions(${PROJECT_NAME} PUBLIC "__thread=${TLS_NAME}")
endif()

#-------------------------------------------------------------------------------
# APPS configuration
#-------------------------------------------------------------------------------
add_subdirectory("apps")

#-------------------------------------------------------------------------------
# PACKAGE configuration
#-------------------------------------------------------------------------------
configure_package_config_file(GKlibConfig.cmake.in cmake/GKlibConfig.cmake
  INSTALL_DESTINATION lib/cmake/GKlib)

write_basic_package_version_file(cmake/GKlibConfigVersion.cmake
  VERSION       ${PROJECT_VERSION}
  COMPATIBILITY SameMajorVersion)

install(TARGETS ${PROJECT_NAME} EXPORT GKlibTargets
  RUNTIME  DESTINATION ${CMAKE_INSTALL_BINDIR}
           COMPONENT   GKlib_Runtime
  LIBRARY  DESTINATION ${CMAKE_INSTALL_LIBDIR}
           COMPONENT          GKlib_Runtime
           NAMELINK_COMPONENT GKlib_Development
  ARCHIVE  DESTINATION ${CMAKE_INSTALL_LIBDIR}
           COMPONENT   GKlib_Development
  INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

install(EXPORT GKlibTargets
  FILE        GKlibTargets.cmake
  NAMESPACE   GKlib::
  DESTINATION lib/cmake/GKlib
  COMPONENT   GKlib_Development)

install(DIRECTORY "${CMAKE_SOURCE_DIR}/src/"
  DESTINATION     ${CMAKE_INSTALL_INCLUDEDIR}/GKlib
  COMPONENT       GKlib_Development
  FILES_MATCHING
  PATTERN         "*[.]h")

install(
  FILES       ${CMAKE_CURRENT_BINARY_DIR}/cmake/GKlibConfig.cmake
              ${CMAKE_CURRENT_BINARY_DIR}/cmake/GKlibConfigVersion.cmake
  DESTINATION lib/cmake/GKlib
  COMPONENT   GKlib_Development)
