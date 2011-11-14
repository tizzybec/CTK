#
# Log4Qt
#
SET(Log4Qt_DEPENDS)
ctkMacroShouldAddExternalProject(Log4Qt_LIBRARIES add_project)
IF(${add_project})

  # Sanity checks
  IF(DEFINED Log4Qt_DIR AND NOT EXISTS ${Log4Qt_DIR})
    MESSAGE(FATAL_ERROR "Log4Qt_DIR variable is defined but corresponds to non-existing directory")
  ENDIF()

  SET(Log4Qt_enabling_variable Log4Qt_LIBRARIES)

  SET(proj Log4Qt)
  SET(proj_DEPENDENCIES)

  SET(Log4Qt_DEPENDS ${proj})

  IF(NOT DEFINED Log4Qt_DIR)

    SET(revision_tag 8d3558b0f636cbf8ff83)
    IF(${proj}_REVISION_TAG)
      SET(revision_tag ${${proj}_REVISION_TAG})
    ENDIF()

    # Set CMake OSX variable to pass down the external project
    set(CMAKE_OSX_EXTERNAL_PROJECT_ARGS)
    if(APPLE)
      list(APPEND CMAKE_OSX_EXTERNAL_PROJECT_ARGS
        -DCMAKE_OSX_ARCHITECTURES=${CMAKE_OSX_ARCHITECTURES}
        -DCMAKE_OSX_SYSROOT=${CMAKE_OSX_SYSROOT}
        -DCMAKE_OSX_DEPLOYMENT_TARGET=${CMAKE_OSX_DEPLOYMENT_TARGET})
    endif()

#     MESSAGE(STATUS "Adding project:${proj}")
    ExternalProject_Add(${proj}
      SOURCE_DIR ${CMAKE_BINARY_DIR}/${proj}
      BINARY_DIR ${proj}-build
      PREFIX ${proj}${ep_suffix}
      GIT_REPOSITORY "${git_protocol}://github.com/commontk/Log4Qt.git"
      GIT_TAG ${revision_tag}
      CMAKE_GENERATOR ${gen}
      INSTALL_COMMAND ""
      UPDATE_COMMAND ""
      CMAKE_CACHE_ARGS
        -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
        -DCMAKE_CXX_FLAGS:STRING=${ep_common_cxx_flags}
        #-DCMAKE_C_FLAGS:STRING=${ep_common_c_flags} # Not used
        -DCMAKE_INSTALL_PREFIX:PATH=${ep_install_dir}
        ${CMAKE_OSX_EXTERNAL_PROJECT_ARGS}
        -DQT_QMAKE_EXECUTABLE:FILEPATH=${QT_QMAKE_EXECUTABLE}
      DEPENDS
        ${proj_DEPENDENCIES}
      )
    SET(Log4Qt_DIR ${CMAKE_BINARY_DIR}/${proj}-build)

    # Since Log4Qt is statically build, there is not need to add its corresponding
    # library output directory to CTK_EXTERNAL_LIBRARY_DIRS

  ELSE()
    ctkMacroEmptyExternalProject(${proj} "${proj_DEPENDENCIES}")
  ENDIF()

  LIST(APPEND CTK_SUPERBUILD_EP_VARS Log4Qt_DIR:PATH)

  SET(${Log4Qt_enabling_variable}_INCLUDE_DIRS Log4Qt_INCLUDE_DIRS)
  SET(${Log4Qt_enabling_variable}_FIND_PACKAGE_CMD Log4Qt)

ENDIF()
