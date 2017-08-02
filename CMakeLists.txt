file(GLOB LIBSRCS
    "src/*.h"
    "src/*.c"
)

find_file(HAVE_CURSES_H curses.h)
find_file(HAVE_NCURSES_H ncurses.h)
find_file(HAVE_SYS_CDEFS_H sys/cdefs.h)
find_file(HAVE_TERMCAP_H termcap.h)
find_file(HAVE_TERM_H term.h)

configure_file(cmakeconfig.h.in config.h)
include_directories(include ${CMAKE_CURRENT_BINARY_DIR} src)

if(MSVC)
    add_definitions(-FI config.h)
else()
    # GCC or Clang
    add_definitions(-include config.h)
endif()

add_library(edit STATIC ${LIBSRCS})

