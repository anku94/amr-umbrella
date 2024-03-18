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

umbrella_defineopt(AMR_TOOLS_GUROBI OFF BOOL "Build amr-tools with Gurobi")
umbrella_defineopt(AMR_TOOLS_TAU OFF BOOL "Build amr-tools with TAU")

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
set(AMR_TOOLS_DEPENDS )

include (umbrella/pdlfs-common)
list(APPEND AMR_TOOLS_DEPENDS pdlfs-common)

include (umbrella/kokkos)
list(APPEND AMR_TOOLS_DEPENDS kokkos)

if (AMR_TOOLS_GUROBI)
  include (umbrella/gurobi)
  list(APPEND AMR_TOOLS_DEPENDS gurobi)
endif (AMR_TOOLS_GUROBI)

if (AMR_TOOLS_TAU)
  include (umbrella/tau)
  list(APPEND AMR_TOOLS_DEPENDS tau)
endif (AMR_TOOLS_TAU)



#
# create amr-tools target
#
ExternalProject_Add (amr-tools
    DEPENDS ${AMR_TOOLS_DEPENDS}
    ${AMR_TOOLS_DOWNLOAD} ${AMR_TOOLS_PATCHCMD}
    CMAKE_ARGS -DTAU_ROOT=${CMAKE_INSTALL_PREFIX}
    CMAKE_CACHE_ARGS ${UMBRELLA_CMAKECACHE}
    UPDATE_COMMAND ""
)

endif (NOT TARGET amr-tools)
