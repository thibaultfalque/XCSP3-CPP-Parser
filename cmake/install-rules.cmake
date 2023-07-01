if(PROJECT_IS_TOP_LEVEL)
  set(
      CMAKE_INSTALL_INCLUDEDIR "include/xcsp3-cpp-parser-${PROJECT_VERSION}"
      CACHE PATH ""
  )
endif()

include(CMakePackageConfigHelpers)
include(GNUInstallDirs)

# find_package(<package>) call for consumers to find this project
set(package xcsp3-cpp-parser)

install(
    DIRECTORY
    include/
    DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
    COMPONENT xcsp3-cpp-parser_Development
)

install(
    TARGETS xcsp3parser
    EXPORT xcsp3-cpp-parserTargets
    RUNTIME #
    COMPONENT xcsp3-cpp-parser_Runtime
    LIBRARY #
    COMPONENT xcsp3-cpp-parser_Runtime
    NAMELINK_COMPONENT xcsp3-cpp-parser_Development
    ARCHIVE #
    COMPONENT xcsp3-cpp-parser_Development
    INCLUDES #
    DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
)

write_basic_package_version_file(
    "${package}ConfigVersion.cmake"
    COMPATIBILITY SameMajorVersion
)

# Allow package maintainers to freely override the path for the configs
if (VCPKG_TARGET_TRIPLET)
# Allow package maintainers to freely override the path for the configs
set(
    xcsp3parser_INSTALL_CMAKEDIR "${CMAKE_INSTALL_PREFIX}/share/${package}"
    CACHE PATH "CMake package config location relative to the install prefix"
)
else ()
set(
    xcsp3parser_INSTALL_CMAKEDIR "${CMAKE_INSTALL_LIBDIR}/cmake/${package}"
    CACHE PATH "CMake package config location relative to the install prefix"
)
endif ()
mark_as_advanced(xcsp3-cpp-parser_INSTALL_CMAKEDIR)

install(
    FILES cmake/install-config.cmake
    DESTINATION "${xcsp3-cpp-parser_INSTALL_CMAKEDIR}"
    RENAME "${package}Config.cmake"
    COMPONENT xcsp3-cpp-parser_Development
)

install(
    FILES "${PROJECT_BINARY_DIR}/${package}ConfigVersion.cmake"
    DESTINATION "${xcsp3-cpp-parser_INSTALL_CMAKEDIR}"
    COMPONENT xcsp3-cpp-parser_Development
)

install(
    EXPORT xcsp3-cpp-parserTargets
    NAMESPACE xcsp3-cpp-parser::
    DESTINATION "${xcsp3-cpp-parser_INSTALL_CMAKEDIR}"
    COMPONENT xcsp3-cpp-parser_Development
)

if(PROJECT_IS_TOP_LEVEL)
  include(CPack)
endif()
