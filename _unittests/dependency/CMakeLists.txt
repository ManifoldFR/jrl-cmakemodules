cmake_minimum_required(VERSION 3.22)

set(PROJECT_NAME jrl-cmakemodules-dependency)
set(PROJECT_VERSION 0.0.0)
set(PROJECT_DESCRIPTION "JRL CMake module - dependency")
set(PROJECT_URL http://jrl-cmakemodules.readthedocs.io)
set(INSTALL_DOCUMENTATION OFF)

include(../macros.cmake)

include(../../base.cmake)

COMPUTE_PROJECT_ARGS(PROJECT_ARGS LANGUAGES CXX)
project(${PROJECT_NAME} ${PROJECT_ARGS})

ADD_PROJECT_DEPENDENCY(jrl-cmakemodules-cpp REQUIRED)

check_exist_target(jrl-cmakemodules-cpp::jrl_cmakemodule_lib "")

check_exist_variable(jrl-cmakemodules-cpp_FOUND "")
