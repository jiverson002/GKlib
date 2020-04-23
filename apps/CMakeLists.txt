# Where the header files reside
#include_directories(../)

# Build program.
set(GKLIB_PROGRAMS
  strings gksort fis gkrw gkgraph csrcnv grKx m2mnbrs cmpnbrs splatt2svd)

foreach(prog ${GKLIB_PROGRAMS})
  add_executable(${prog} ${prog}.c)
  target_link_libraries(${prog} GKlib::gklib)
endforeach()

# Install
#install(TARGETS ${GKLIB_PROGRAMS} RUNTIME DESTINATION bin)
