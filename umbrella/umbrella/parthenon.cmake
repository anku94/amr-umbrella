#
# parthenon.cmake  umbrella for parthenon
# 10-May-2023  ankushj@andrew.cmu.edu
#

#
# config:
#  PARTHENON_REPO - url of git repository
#  PARTHENON_TAG  - tag to checkout of git
#  PARTHENON_TAR  - cache tar file name (default should be ok)
#

if (NOT TARGET parthenon)

umbrella_defineopt (PARTHENON_REPO "https://github.com/anku94/parthenon.git"
     STRING "PARTHENON GIT repository")
umbrella_defineopt (PARTHENON_TAG "develop" STRING "PARTHENON GIT tag")
umbrella_defineopt (PARTHENON_TAR "parthenon-${PARTHENON_TAG}.tar.gz"
     STRING "PARTHENON cache tar file")
#
# generate parts of the ExternalProject_Add args...
#
umbrella_download (PARTHENON_DOWNLOAD parthenon
                   ${PARTHENON_TAR}
                   GIT_REPOSITORY ${PARTHENON_REPO}
                   GIT_TAG ${PARTHENON_TAG})
umbrella_patchcheck (PARTHENON_PATCHCMD parthenon)
# TODO: hook up tests (also add to ExternalProject_Add)
# umbrella_testcommand (parthenon PARTHENON_TESTCMD
    # TEST_COMMAND ctest -R preload -V )

#
# depends
#
include (umbrella/amr-tools)
include (umbrella/hdf5)

#
# create parthenon target
#
ExternalProject_Add (parthenon
    DEPENDS amr-tools hdf5
    ${PARTHENON_DOWNLOAD} ${PARTHENON_PATCHCMD}
    CMAKE_ARGS -DBUILD_SHARED_LIBS=ON -DTAU_ROOT=${CMAKE_INSTALL_PREFIX}
    CMAKE_CACHE_ARGS ${UMBRELLA_CMAKECACHE}
    UPDATE_COMMAND ""
)

endif (NOT TARGET parthenon)
