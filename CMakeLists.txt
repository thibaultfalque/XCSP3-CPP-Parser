cmake_minimum_required(VERSION 3.6)

include(cmake/prelude.cmake)

set(CMAKE_CXX_STANDARD 11)

project(
    xcsp3parser
    VERSION 1.5.0
    DESCRIPTION "C/C++ parser for the CSP XML format version 3.0"
    HOMEPAGE_URL "https://github.com/xcsp3team/XCSP3-CPP-Parser"
    LANGUAGES CXX
)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/samples")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/lib")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/lib)

set(Xcsp3Parser_VERSION_MAJOR 1)
set(Xcsp3Parser_VERSION_MINOR 0)
set(Xcsp3Parser_VERSION_PATCH 0)
set(VERSION ${Xcsp3Parser_VERSION_MAJOR}.${Xcsp3Parser_VERSION_MINOR}.${Xcsp3Parser_VERSION_PATCH})

include(cmake/project-is-top-level.cmake)
include(cmake/variables.cmake)

find_package(LibXml2 REQUIRED)
message(STATUS ${LIBXML2_LIBRARIES})

set(LIBRARY_NAME xcsp3parser)
set(LIBRARY_NAME_DYNAMIC xcsp3parser_dynamic)

set(LIB_HEADERS
        include/AttributeList.h
        include/UTF8String.h
        include/XCSP3Constants.h
        include/XCSP3Constraint.h
        include/XCSP3CoreParser.h
        include/XCSP3CoreCallbacks.h
        include/XCSP3Manager.h
        include/XCSP3Domain.h
        include/XCSP3Objective.h
        include/XCSP3utils.h
        include/XCSP3Variable.h
        include/XMLParser.h
        include/XCSP3Tree.h
        include/XCSP3TreeNode.h
        )

set(LIB_SOURCES
        src/UTF8String.cc
        src/XCSP3Code.cc
        src/XCSP3CoreParser.cc
        src/XCSP3Manager.cc
        src/XMLParser.cc
        src/XMLParserTags.cc
        src/XCSP3Tree.cc
        src/XCSP3TreeNode.cc
        )

set(APP_HEADERS
        )

set(APP_SOURCES
        samples/XCSP3PrintCallbacks.h
        samples/main.cc
        include/XCSP3TreeNode.h)

# ---- Declare library ----

add_library(
        ${LIBRARY_NAME}
        STATIC
        ${LIB_HEADERS} ${LIB_SOURCES})
        add_library(xcsp3-cpp-parser_xcsp3-cpp-parser ALIAS ${LIBRARY_NAME})
        add_library(xcsp3-cpp-parser::xcsp3-cpp-parser ALIAS ${LIBRARY_NAME})
target_link_libraries(${LIBRARY_NAME} LibXml2::LibXml2)
if (WIN32)
target_compile_options(${LIBRARY_NAME} PRIVATE /MT)
endif()

if(NOT BUILD_SHARED_LIBS)
  target_compile_definitions(${LIBRARY_NAME} PUBLIC XCSP3_CPP_PARSER_STATIC_DEFINE)
endif()

set_target_properties(
    ${LIBRARY_NAME} PROPERTIES
    CXX_VISIBILITY_PRESET hidden
    VISIBILITY_INLINES_HIDDEN YES
    VERSION "${PROJECT_VERSION}"
    SOVERSION "${PROJECT_VERSION_MAJOR}"
    EXPORT_NAME xcsp3-cpp-parser
    OUTPUT_NAME xcsp3-cpp-parser
    FRAMEWORK FALSE
    PUBLIC_HEADER "${LIB_HEADERS}" # specify the public headers
)

target_include_directories(
    ${LIBRARY_NAME} ${warning_guard}
    PUBLIC
    "$<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>"
)

target_include_directories(
    ${LIBRARY_NAME} SYSTEM
    PUBLIC
    "$<BUILD_INTERFACE:${PROJECT_BINARY_DIR}/export>"
)

include_directories(${LIBXML2_INCLUDE_DIR})

target_compile_features(${LIBRARY_NAME} PUBLIC cxx_std_11)

# ---- Sample Application ----

set(APPLICATION_NAME samplesXcsp3)
add_executable(${APPLICATION_NAME} ${APP_SOURCES})
target_link_libraries(${APPLICATION_NAME} ${LIBRARY_NAME} LibXml2::LibXml2)
if (WIN32)
target_compile_options(samplesXcsp3 PRIVATE /MT)
endif()

# ---- Install rules ----

if(NOT CMAKE_SKIP_INSTALL_RULES)
  include(cmake/install-rules.cmake)
endif()

# ---- Developer mode ----

if(NOT xcsp3-cpp-parser_DEVELOPER_MODE)
  return()
elseif(NOT PROJECT_IS_TOP_LEVEL)
  message(
      AUTHOR_WARNING
      "Developer mode is intended for developers of xcsp3-cpp-parser"
  )
endif()

include(cmake/dev-mode.cmake)
