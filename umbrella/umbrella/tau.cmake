#
# tau.cmake  umbrella for tau package
# 10-May-2023  ankushj@andrew.cmu.edu
#

#
# config:
#  TAU_BASEURL - base url of tau
#  TAU_URLDIR  - subdir in base where it lives
#  TAU_URLFILE - tar file within urldir
#  TAU_URLMD5  - md5 of tar file
#
#  TAU_DEVICE - optional --with-device option
#

if (NOT TARGET tau)

#
# umbrella option variables
#
umbrella_defineopt (TAU_BASEURL
    "http://tau.uoregon.edu"
    STRING "base url for tau")
umbrella_defineopt (TAU_URLFILE "tau.tgz"
    STRING "tau tar file name")
umbrella_defineopt (TAU_URLMD5 "69aebc5790a17a1548a03cd01ae10c35"
    STRING "MD5 of tar file")

#
# generate parts of the ExternalProject_Add args...
#
umbrella_download (TAU_DOWNLOAD tau ${TAU_URLFILE}
  URL "${TAU_BASEURL}/${TAU_URLFILE}"
    URL_MD5 ${TAU_URLMD5}
    DOWNLOAD_EXTRACT_TIMESTAMP TRUE)
umbrella_patchcheck (TAU_PATCHCMD tau)

#
# depends
#
include (umbrella/mvapich)
include (umbrella/pdt)

# ./configure -mpi -mpiinc=/users/ankushj/repos/amr-workspace/install/include -mpilib=/users/ankushj/repos/amr-workspace/install/lib -bfd=download -dwarf=download -otf=download -unwind=download -pdt=/users/ankushj/repos/amr-workspace/tau-psm-2004/pdtoolkit-3.25.1 -PROFILEPHASE -ompt

#
# create tau target
# TAU infers compiler from the configured MPI source
# we do not pass UMBRELLA_COMP to it.
#

ExternalProject_Add (tau DEPENDS mvapich pdt
    ${TAU_DOWNLOAD} ${MVAPICH_PATCHCMD}
    CONFIGURE_COMMAND <SOURCE_DIR>/configure 
                      -prefix=${CMAKE_INSTALL_PREFIX}
                      -mpi -mpiinc=${CMAKE_INSTALL_PREFIX}/include
                      -mpilib=${CMAKE_INSTALL_PREFIX}/lib
                      -pdt=${CMAKE_INSTALL_PREFIX}
                      -bfd=download -dwarf=download 
                      -otf=download -unwind=download -PROFILEPHASE -ompt
                      BUILD_IN_SOURCE 1  # Designed this way
                      UPDATE_COMMAND "")

endif (NOT TARGET tau)
