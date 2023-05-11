#
# amr-tools.cmake  umbrella for amr-tools
# 10-May-2023  ankushj@andrew.cmu.edu
#

#
# config:
#  AMR_TOOLS_REPO - url of git repository
#  AMR_TOOLS_TAG  - tag to checkout of git
#  AMR_TOOLS_TAR  - cache tar file name (default should be ok)
#

if (NOT TARGET amr-tools)

umbrella_defineopt (AMR_TOOLS_REPO "https://github.com/anku94/amr.git"
     STRING "AMR_TOOLS GIT repository")
umbrella_defineopt (AMR_TOOLS_TAG "main" STRING "AMR_TOOLS GIT tag")
umbrella_defineopt (AMR_TOOLS_TAR "amr-tools-${AMR_TOOLS_TAG}.tar.gz"
     STRING "AMR_TOOLS cache tar file")
#
# generate parts of the ExternalProject_Add args...
#
umbrella_download (AMR_TOOLS_DOWNLOAD amr-tools
                   ${AMR_TOOLS_TAR}
                   GIT_REPOSITORY ${AMR_TOOLS_REPO}
                   GIT_TAG ${AMR_TOOLS_TAG})
umbrella_patchcheck (AMR_TOOLS_PATCHCMD amr-tools)
# TODO: hook up tests (also add to ExternalProject_Add)
# umbrella_testcommand (amr-tools AMR_TOOLS_TESTCMD
    # TEST_COMMAND ctest -R preload -V )

#
# depends
#
include (umbrella/pdlfs-common)
include (umbrella/gurobi)
include (umbrella/tau)

#
# create amr-tools target
#
ExternalProject_Add (amr-tools
    DEPENDS pdlfs-common gurobi tau
    ${AMR_TOOLS_DOWNLOAD} ${AMR_TOOLS_PATCHCMD}
    CMAKE_ARGS -DTAU_ROOT=${CMAKE_INSTALL_PREFIX}
    CMAKE_CACHE_ARGS ${UMBRELLA_CMAKECACHE}
    UPDATE_COMMAND ""
)

endif (NOT TARGET amr-tools)
