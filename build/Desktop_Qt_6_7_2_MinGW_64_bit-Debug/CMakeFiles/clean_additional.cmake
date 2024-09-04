# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles\\appfirstProjectNewQt_autogen.dir\\AutogenUsed.txt"
  "CMakeFiles\\appfirstProjectNewQt_autogen.dir\\ParseCache.txt"
  "appfirstProjectNewQt_autogen"
  )
endif()
