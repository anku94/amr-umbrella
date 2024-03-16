#
# psm.cmake  intel/qlogic psm interface to their ib network cards
# 18-Aug-2020  chuck@ece.cmu.edu
#

#
# config:
#  PSM_REPO - url of git repository
#  PSM_TAG  - tag to checkout of git
#  PSM_TAR  - cache tar file name (default should be ok)
#

umbrella_prebuilt_check(psm FILE psm.h)

if (NOT TARGET psm)

#
# umbrella option variables
#
# XXX: use our fork https://github.com/pdlfs/psm.git rather than
# https://github.com/intel/psm.git so we pick up some compile error
# fixes (intel doesn't seem to be maintaining psm anymore).
#
umbrella_defineopt (PSM_REPO "https://github.com/pdlfs/psm.git"
                    STRING "PSM GIT repository")
umbrella_defineopt (PSM_TAG "master" STRING "PSM GIT tag")
umbrella_defineopt (PSM_TAR "psm-${PSM_TAG}.tar.gz" STRING
                    "PSM cache tar file")
umbrella_defineopt (PSM_DEBUG OFF BOOL
                    "Build PSM with debug flags")
umbrella_defineopt (PSM_DISABLE_INLINES OFF BOOL
                    "Patch PSM to disable inline funcs")

set(psm-cppflags "")
set(config-sedcmd "")

if (PSM_DEBUG)
  message(INFO "PSM Debug Build enabled. May be slow")
  set(psm-cppflags "CFLAGS=-fvisibility=default -fno-inline")
endif()

if (PSM_DISABLE_INLINES)
  message(WARNING "PSM will be patched to disable always_inline. May be very slow!!")
  # set(config-sedcmd "sed 's/ __attribute__((always_inline))/ \/*__attribute__((always_inline))*\//g' <SOURCE_DIR>/psm_help.h")
endif()


#
# generate parts of the ExternalProject_Add args...
#
umbrella_download (PSM_DOWNLOAD psm ${PSM_TAR}
                   GIT_REPOSITORY ${PSM_REPO}
                   GIT_TAG ${PSM_TAG})
umbrella_patchcheck (PSM_PATCHCMD psm)

#
# create psm target
#
ExternalProject_Add (psm ${PSM_DOWNLOAD} ${PSM_PATCHCMD}
    CONFIGURE_COMMAND "${config-sedcmd}"
    BUILD_IN_SOURCE 1      # old school makefiles
    BUILD_COMMAND make ${UMBRELLA_COMP}
                       ${UMBRELLA_CPPFLAGS} ${UMBRELLA_LDFLAGS}
    INSTALL_COMMAND
      mkdir -p ${CMAKE_INSTALL_PREFIX}/lib ${CMAKE_INSTALL_PREFIX}/include
      COMMAND cd <SOURCE_DIR> && 
      sh -c "tar cf - libpsm_infinipath.so* | (cd ${CMAKE_INSTALL_PREFIX}/lib && tar xf - )"
      COMMAND cd <SOURCE_DIR>/ipath && 
      sh -c "tar cf - libinfinipath.so* | (cd ${CMAKE_INSTALL_PREFIX}/lib && tar xf - )"
      COMMAND cp <SOURCE_DIR>/psm.h <SOURCE_DIR>/psm_mq.h
                                       ${CMAKE_INSTALL_PREFIX}/include
    UPDATE_COMMAND "")

endif (NOT TARGET psm)
