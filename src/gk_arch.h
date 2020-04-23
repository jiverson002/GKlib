/*!
\file gk_arch.h
\brief This file contains various architecture-specific declerations

\date   Started 3/27/2007
\author George
\version\verbatim $Id: gk_arch.h 21637 2018-01-03 22:37:24Z karypis $ \endverbatim
*/

#ifndef _GK_ARCH_H_
#define _GK_ARCH_H_

/*************************************************************************
* Architecture-specific differences in header files
**************************************************************************/
#ifdef HAVE_EXECINFO_H
#include <execinfo.h>
#endif


#ifdef __MSC__
  #include "ms_stdint.h"
  #include "ms_inttypes.h"
  #include "ms_stat.h"
#else
#ifndef SUNOS
  #include <stdint.h>
#endif
#if !defined(WIN32) && !defined(__MINGW32__)
  #include <sys/resource.h>
#endif
  #include <inttypes.h>
  #include <sys/types.h>
  #include <sys/time.h>
#endif


/*************************************************************************
* Architecture-specific modifications
**************************************************************************/
#ifdef WIN32
typedef ptrdiff_t ssize_t;
#endif


#ifdef SUNOS
#define PTRDIFF_MAX  INT64_MAX
#endif

#if 0
/* MSC does not have INFINITY defined */
#ifndef INFINITY
#define INFINITY FLT_MAX
#endif
#endif

#endif
