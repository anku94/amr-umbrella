#
# gurobi.cmake  umbrella for gurobi solver
# 10-May-2023  ankushj@andrew.cmu.edu
#

# config:
#  GUROBI_BASEURL - base url of tau
#  GUROBI_URLDIR  - subdir in base where it lives
#  GUROBI_URLFILE - tar file within urldir
#  GUROBI_URLMD5  - md5 of tar file
#
#  GUROBI_DEVICE - optional --with-device option
#

if (NOT TARGET gurobi)

#
# umbrella option variables
#
umbrella_defineopt (GUROBI_BASEURL
    "https://packages.gurobi.com"
    STRING "base url for gurobi")
umbrella_defineopt (GUROBI_URLDIR "10.0"
    STRING "subdir in base where it lives")
umbrella_defineopt (GUROBI_URLFILE "gurobi10.0.1_linux64.tar.gz"
    STRING "gurobi tar file name")
umbrella_defineopt (GUROBI_URLMD5 "e92080e8aeb25931ed20fad973a1e79e"
    STRING "MD5 of tar file")

#
# generate parts of the ExternalProject_Add args...
#
umbrella_download (GUROBI_DOWNLOAD gurobi ${GUROBI_URLFILE}
  URL "${GUROBI_BASEURL}/${GUROBI_URLDIR}/${GUROBI_URLFILE}"
  URL_MD5 ${GUROBI_URLMD5})
umbrella_patchcheck (GUROBI_PATCHCMD gurobi)

#
# create gurobi target
# this currently uses the default compiler, and assumes linux etc.
# gurobi not packaged in a very portable manner.
#
ExternalProject_Add (gurobi ${GUROBI_DOWNLOAD} ${GUROBI_PATCHCMD}
    CONFIGURE_COMMAND ""
    BUILD_COMMAND cd <SOURCE_DIR>/linux64/src/build && make
    INSTALL_COMMAND cp <SOURCE_DIR>/linux64/src/build/libgurobi_c++.a ${CMAKE_INSTALL_PREFIX}/lib
    COMMAND cp <SOURCE_DIR>/linux64/include/gurobi_c.h ${CMAKE_INSTALL_PREFIX}/include
    COMMAND cp <SOURCE_DIR>/linux64/include/gurobi_c++.h ${CMAKE_INSTALL_PREFIX}/include
    COMMAND cp <SOURCE_DIR>/linux64/lib/libgurobi.so.10.0.1 ${CMAKE_INSTALL_PREFIX}/lib
    COMMAND cp <SOURCE_DIR>/linux64/lib/libgurobi100.so ${CMAKE_INSTALL_PREFIX}/lib
    UPDATE_COMMAND ""
)

endif (NOT TARGET gurobi)
