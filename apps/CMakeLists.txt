# Build programs.
set(GKLIB_PROGRAMS strings gksort fis gkrw gkgraph csrcnv grKx m2mnbrs cmpnbrs
                   splatt2svd)
set(GKLIB_PROGRAMS ${GKLIB_PROGRAMS} PARENT_SCOPE)

foreach(prog ${GKLIB_PROGRAMS})
  add_executable(${prog} ${prog}.c)
  target_link_libraries(${prog} GKlib::gklib)
endforeach()

# install executables
install(TARGETS ${GKLIB_PROGRAMS}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
          COMPONENT   GKlib_Runtime)
