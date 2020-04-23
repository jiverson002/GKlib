# Helper modules.

# Add compiler flags.
if(MSVC)
  set(GKlib_COPTS "/Ox")
  set(GKlib_COPTIONS "-DWIN32 -DMSC -D_CRT_SECURE_NO_DEPRECATE -DUSE_GKREGEX")
elseif(MINGW)
  set(GKlib_COPTS "-DUSE_GKREGEX")
else()
  set(GKlib_COPTIONS "-DLINUX -D_FILE_OFFSET_BITS=64")
endif(MSVC)
if(CYGWIN)
  set(GKlib_COPTIONS "${GKlib_COPTIONS} -DCYGWIN")
endif(CYGWIN)
if(CMAKE_COMPILER_IS_GNUCC)
# GCC opts.
  set(GKlib_COPTIONS "${GKlib_COPTIONS} -std=c99 -fno-strict-aliasing")
  set(GKlib_COPTIONS "${GKlib_COPTIONS} -march=native")
  if(NOT MINGW)
      set(GKlib_COPTIONS "${GKlib_COPTIONS} -fPIC")
  endif(NOT MINGW)
# GCC warnings.
  set(GKlib_COPTIONS "${GKlib_COPTIONS} -Werror -Wall -pedantic -Wno-unused-function -Wno-unused-variable -Wno-unknown-pragmas -Wno-unused-label")
endif(CMAKE_COMPILER_IS_GNUCC)

# Intel compiler
if(${CMAKE_C_COMPILER_ID} MATCHES "Intel")
  set(GKlib_COPTIONS "${GKlib_COPTIONS} -xHost -std=c99")
endif()

# Finally set the official C flags.
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${GKlib_COPTIONS} ${GKlib_COPTS}")
