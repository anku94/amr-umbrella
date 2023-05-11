#
# pdlfs-common.cmake  umbrella for pdlfs-common config'd as pdlfs-common
# 29-Sep-2017  chuck@ece.cmu.edu
#

#
# config:
#  PDLFS_COMMON_REPO - url of git repository
#  PDLFS_COMMON_TAG  - tag to checkout of git
#  PDLFS_COMMON_TAR  - cache tar file name (default should be ok)
#  PDLFS_OPTIONS       - common pdlfs options
#

if (NOT TARGET pdlfs-common)

#
# umbrella option variables
#
umbrella_defineopt (PDLFS_COMMON_REPO
     "https://github.com/pdlfs/pdlfs-common.git"
     STRING "pdlfs-common GIT repository")
umbrella_defineopt (PDLFS_COMMON_TAG "master" STRING "pdlfs-common GIT tag")
umbrella_defineopt (PDLFS_COMMON_TAR
     "pdlfs-common-${PDLFS_COMMON_TAG}.tar.gz"
     STRING "pdlfs-common cache tar file")
umbrella_buildtests(pdlfs-common PDLFS_COMMON_BUILDTESTS)


#
# generate parts of the ExternalProject_Add args...
#
umbrella_download (PDLFS_COMMON_DOWNLOAD pdlfs-common ${PDLFS_COMMON_TAR}
                   GIT_REPOSITORY ${PDLFS_COMMON_REPO}
                   GIT_TAG ${PDLFS_COMMON_TAG})
umbrella_patchcheck (PDLFS_COMMON_PATCHCMD pdlfs-common)
umbrella_testcommand (pdlfs-common PDLFS_COMMON_TESTCMD TEST_COMMAND
      ctest -E "gigaplus_test|autocompact_test|db_test|index_block_test" )

#
# depends
#
include (umbrella/mercury)

#
# create pdlfs-common target
#
ExternalProject_Add (pdlfs-common DEPENDS mercury
    ${PDLFS_COMMON_DOWNLOAD} ${PDLFS_COMMON_PATCHCMD}
    CMAKE_ARGS ${PDLFS_OPTIONS} -DBUILD_SHARED_LIBS=ON
        -DBUILD_TESTS=${PDLFS_COMMON_BUILDTESTS}
        -DPDLFS_COMMON_LIBNAME=pdlfs-common
    CMAKE_CACHE_ARGS ${UMBRELLA_CMAKECACHE}
    UPDATE_COMMAND ""
    ${PDLFS_COMMON_TESTCMD}
)

endif (NOT TARGET pdlfs-common)
