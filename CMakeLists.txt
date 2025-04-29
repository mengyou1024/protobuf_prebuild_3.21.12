cmake_minimum_required(VERSION 3.10)

project(protobuf)
option(PROTOBUF_USE_MSVC_STATIC_RUNTIME "Use MSVC static runtime" OFF)
add_library(_protobuf STATIC IMPORTED GLOBAL)

if(MSVC)
    set(MSVC_IMPORTED_SUFFIX "d")

    if(CMAKE_BUILD_TYPE STREQUAL Release)
        set(MSVC_IMPORTED_SUFFIX "")
    endif()

    if(PROTOBUF_USE_MSVC_STATIC_RUNTIME)
        set(MSVC_IMPORTED_SUFFIX "${MSVC_IMPORTED_SUFFIX}_s")
    endif()

    set_target_properties(
        _protobuf PROPERTIES
        IMPORTED_LOCATION "${CMAKE_CURRENT_LIST_DIR}/lib/msvc/libprotobuf${MSVC_IMPORTED_SUFFIX}.lib"
    )
elseif(MINGW)
    set_target_properties(
        _protobuf PROPERTIES
        IMPORTED_LOCATION "${CMAKE_CURRENT_LIST_DIR}/lib/mingw/libprotobuf.a"
    )
endif()

target_include_directories(
    _protobuf INTERFACE "${CMAKE_CURRENT_LIST_DIR}/include"
)

add_library(protobuf::libprotobuf ALIAS _protobuf)

find_package(ProtoGenerator REQUIRED PATHS ${CMAKE_CURRENT_LIST_DIR}/cmake)
