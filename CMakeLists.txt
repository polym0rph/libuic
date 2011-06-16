################################################################################
# libuic CMAKE BUILD CONFIG
#
# CMAKE HELP: http://www.cmake.org/cmake/help/cmake-2-8-docs.html
################################################################################

# cmake requirements
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

# project name
PROJECT("libuic" C CXX)


# libuic
SET(UI_CONTROLLER_LIB_NAME "uic")

# include
INCLUDE_DIRECTORIES(${PROJECT_BINARY_DIR} "include")

# src
FILE(GLOB UI_CONTROLLER_SRC_FILES src/*.mm)

# build libuic
SET(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -framework Cocoa")
ADD_LIBRARY(${UI_CONTROLLER_LIB_NAME} SHARED ${UI_CONTROLLER_SRC_FILES})


# documentation
FIND_PACKAGE(Doxygen)

IF(DOXYGEN_FOUND)
  # Add docs target
  ADD_CUSTOM_TARGET(docs
    ${DOXYGEN_EXECUTABLE} ${CMAKE_SOURCE_DIR}/Doxyfile
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMENT "Generating documentation with Doxygen"
    VERBATIM)
ELSE(DOXYGEN_FOUND)
  MESSAGE(WARNING "Doxygen not found.")
ENDIF(DOXYGEN_FOUND)

# cleanup docs folder on "make clean"
SET_PROPERTY(DIRECTORY APPEND PROPERTY
  ADDITIONAL_MAKE_CLEAN_FILES ${CMAKE_SOURCE_DIR}/docs/doxygen)


# sample-app
SET(SAMPLE_APP_EXECUTABLE_NAME "sample-app")

# src
FILE(GLOB SAMPLE_APP_SRC_FILES sample-app/*.cpp)

# link dirs
LINK_DIRECTORIES("${CMAKE_SOURCE_DIR}/build")

# build sample-app
ADD_EXECUTABLE(${SAMPLE_APP_EXECUTABLE_NAME} ${SAMPLE_APP_SRC_FILES})
TARGET_LINK_LIBRARIES(${SAMPLE_APP_EXECUTABLE_NAME} uic curses)
