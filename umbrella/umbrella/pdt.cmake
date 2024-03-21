#
# pdt.cmake  umbrella for pdt package
# 30-Jul-2020  chuck@ece.cmu.edu
#

#
# config:
#  PDT_BASEURL - base url of pdt
#  PDT_URLDIR  - subdir in base where it lives
#  PDT_URLFILE - tar file within urldir
#  PDT_URLMD5  - md5 of tar file
#
#  PDT_DEVICE - optional --with-device option
#

if (NOT TARGET pdt)

#
# umbrella option variables
#
umbrella_defineopt (PDT_BASEURL
    "http://tau.uoregon.edu"
    STRING "base url for pdt")
umbrella_defineopt (PDT_URLFILE "pdt.tar.gz"
    STRING "pdt tar file name")
umbrella_defineopt (PDT_URLMD5 "a248b1d6874390dcb30feea16a26e0ef"
    STRING "MD5 of tar file")

#
# generate parts of the ExternalProject_Add args...
#
umbrella_download (PDT_DOWNLOAD pdt ${PDT_URLFILE}
  URL "${PDT_BASEURL}/${PDT_URLFILE}"
    URL_MD5 ${PDT_URLMD5})
umbrella_patchcheck (PDT_PATCHCMD pdt)

#
# depends
#

#
# create pdt target
#
ExternalProject_Add (pdt 
    ${PDT_DOWNLOAD} ${MVAPICH_PATCHCMD}
    CONFIGURE_COMMAND <SOURCE_DIR>/configure ${UMBRELLA_COMP}
                      ${UMBRELLA_CPPFLAGS} ${UMBRELLA_LDFLAGS}
                      -prefix=${CMAKE_INSTALL_PREFIX}
                      BUILD_IN_SOURCE 1  # Designed this way
                      UPDATE_COMMAND "")

endif (NOT TARGET pdt)
