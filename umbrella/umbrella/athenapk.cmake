#
# athenapk.cmake  umbrella for athenapk
# 10-May-2023  ankushj@andrew.cmu.edu
#

#
# config:
#  ATHENAPK_REPO - url of git repository
#  ATHENAPK_TAG  - tag to checkout of git
#  ATHENAPK_TAR  - cache tar file name (default should be ok)
#

if (NOT TARGET athenapk)

umbrella_defineopt (ATHENAPK_REPO "https://github.com/parthenon-hpc-lab/athenapk.git"
     STRING "ATHENAPK GIT repository")
umbrella_defineopt (ATHENAPK_TAG "pgrete/init-pert" STRING "ATHENAPK GIT tag")
umbrella_defineopt (ATHENAPK_TAR "athenapk-${ATHENAPK_TAG}.tar.gz"
     STRING "ATHENAPK cache tar file")
#
# generate parts of the ExternalProject_Add args...
#kkjjj
umbrella_download (ATHENAPK_DOWNLOAD athenapk
                   ${ATHENAPK_TAR}
                   GIT_REPOSITORY ${ATHENAPK_REPO}
                   GIT_TAG ${ATHENAPK_TAG})
umbrella_patchcheck (ATHENAPK_PATCHCMD athenapk)
# TODO: hook up tests (also add to ExternalProject_Add)
# umbrella_testcommand (athenapk ATHENAPK_TESTCMD
    # TEST_COMMAND ctest -R preload -V )

#
# depends
#
include (umbrella/parthenon)
include (umbrella/tau)

#
# create athenapk target
#
ExternalProject_Add (athenapk
    DEPENDS parthenon tau
    ${ATHENAPK_DOWNLOAD} ${ATHENAPK_PATCHCMD}
    CMAKE_ARGS -DAthenaPK_ENABLE_TESTING=OFF -DTAU_ROOT=${CMAKE_INSTALL_PREFIX}
    CMAKE_CACHE_ARGS ${UMBRELLA_CMAKECACHE}
    UPDATE_COMMAND ""
)

endif (NOT TARGET athenapk)
