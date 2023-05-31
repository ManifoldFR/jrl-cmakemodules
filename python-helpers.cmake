# Copyright (C) 2008-2023 LAAS-CNRS, JRL AIST-CNRS, INRIA.
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program.  If not, see <http://www.gnu.org/licenses/>.

# .rst: .. command::  PYTHON_INSTALL(MODULE FILE DEST)
#
# Compile and install a Python file.
#
macro(PYTHON_INSTALL MODULE FILE DEST)

  python_build("${MODULE}" "${FILE}")

  install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/${MODULE}/${FILE}"
          DESTINATION "${DEST}/${MODULE}")
endmacro()

# .rst: .. command:: PYTHON_INSTALL_ON_SITE (MODULE FILE)
#
# Compile and install a Python file in :cmake:variable:`PYTHON_SITELIB`.
#
macro(PYTHON_INSTALL_ON_SITE MODULE FILE)
  python_install("${MODULE}" "${FILE}" ${PYTHON_SITELIB})
endmacro()

# PYTHON_BUILD(MODULE FILE DEST)
# --------------------------------------
#
# Build a Python file from the source directory in the build directory.
#
macro(PYTHON_BUILD MODULE FILE)
  set(INPUT_FILE "${CMAKE_CURRENT_SOURCE_DIR}/${MODULE}/${FILE}")
  if(CMAKE_GENERATOR MATCHES "Visual Studio")
    set(OUTPUT_FILE_DIR "${CMAKE_CURRENT_BINARY_DIR}/${MODULE}/$<CONFIG>")
  else()
    set(OUTPUT_FILE_DIR "${CMAKE_CURRENT_BINARY_DIR}/${MODULE}")
  endif(CMAKE_GENERATOR MATCHES "Visual Studio")
  set(OUTPUT_FILE "${OUTPUT_FILE_DIR}/${FILE}c")

  file(MAKE_DIRECTORY ${OUTPUT_FILE_DIR})

  python_build_file(${INPUT_FILE} ${OUTPUT_FILE})
endmacro()

# PYTHON_BUILD_FILE(FILE)
# --------------------------------------
#
# Build a Python a given file.
#
macro(PYTHON_BUILD_FILE FILE)
  # Regex from IsValidTargetName in CMake/Source/cmGeneratorExpression.cxx
  string(REGEX REPLACE "[^A-Za-z0-9_.+-]" "_" compile_pyc
                       "compile_pyc_${CMAKE_CURRENT_SOURCE_DIR}")
  if(NOT TARGET ${compile_pyc})
    add_custom_target(${compile_pyc} ALL)
  endif()

  if(ARGV1)
    set(OUTPUT_FILE "${ARGV1}")
  else()
    set(OUTPUT_FILE "${FILE}c")
  endif()

  add_custom_command(
    TARGET ${compile_pyc}
    PRE_BUILD
    COMMAND
      "${PYTHON_EXECUTABLE}" -c
      "import py_compile; py_compile.compile(\"${FILE}\",\"${OUTPUT_FILE}\")"
    VERBATIM)

  # Tag pyc file as generated.
  set_source_files_properties("${OUTPUT_FILE}" PROPERTIES GENERATED TRUE)

  # Clean generated files.
  set_property(
    DIRECTORY
    APPEND
    PROPERTY ADDITIONAL_MAKE_CLEAN_FILES "${OUTPUT_FILE}")
endmacro()
