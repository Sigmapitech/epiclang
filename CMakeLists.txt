cmake_minimum_required(VERSION 3.12)
project(banana-clang)

set(CMAKE_C_COMPILER clang)
set(CMAKE_CXX_COMPILER clang++)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN YES)

find_package(LLVM REQUIRED CONFIG)
find_package(Clang REQUIRED CONFIG)

include_directories("include")
include_directories(SYSTEM ${LLVM_INCLUDE_DIRS})
add_definitions(${LLVM_DEFINITIONS})

file(GLOB_RECURSE SOURCE_FILES "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp")
file(GLOB_RECURSE HEADER_FILES "${CMAKE_CURRENT_SOURCE_DIR}/include/*.hpp")

add_library(banana_clang SHARED ${SOURCE_FILES} ${HEADER_FILES})
target_link_libraries(banana_clang PRIVATE ${llvm_libs})
add_compile_options(
    -Wall -Wextra
    -Wno-unused-command-line-argument
    -Wno-unused-parameter
)

install(TARGETS banana_clang DESTINATION lib)
install(DIRECTORY include/ DESTINATION include)
