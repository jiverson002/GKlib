cmake_minimum_required(VERSION 3.0)

# ...
project(GKlib
  VERSION      0.0.1
  DESCRIPTION  "A library of various helper routines and frameworks used by many of the lab's software."
  HOMEPAGE_URL "http://glaros.dtc.umn.edu/gkhome/index.php"
  LANGUAGES    C)

include(GKlibSystem.cmake)

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

target_link_libraries(${PROJECT_NAME}
  PRIVATE m)

add_library(GKlib::gklib ALIAS ${PROJECT_NAME})

# FIXME: Correctly link against libm when necessary
#if(UNIX)
#  target_link_libraries(GKlib m)
#endif(UNIX)

#-------------------------------------------------------------------------------
# APPS configuration
#-------------------------------------------------------------------------------
add_subdirectory("apps")

#-------------------------------------------------------------------------------
# INSTALL configuration
#-------------------------------------------------------------------------------
#install(TARGETS GKlib
#  ARCHIVE DESTINATION lib/${LINSTALL_PATH}
#  LIBRARY DESTINATION lib/${LINSTALL_PATH})
#install(FILES ${GKlib_includes} DESTINATION include/${HINSTALL_PATH})
