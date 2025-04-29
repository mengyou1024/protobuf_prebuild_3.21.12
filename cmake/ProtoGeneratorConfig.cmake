include_guard(GLOBAL)

find_program(PROTOC_EXECUTABLE protoc.exe HINTS "${CMAKE_CURRENT_LIST_DIR}/../bin" NO_DEFAULT_PATH)

message(STATUS "Protobuf compiler found at: ${PROTOC_EXECUTABLE}")

if(NOT PROTOC_EXECUTABLE)
    message(FATAL_ERROR "Protobuf compiler not found. Please install Protobuf and set the path to protoc.exe.")
endif(NOT PROTOC_EXECUTABLE)

function(target_add_proto_files target_name)
    cmake_parse_arguments(PARSE_ARGV 1 PROTOBUF "" "" "PROTO_FILES")

    message(STATUS "Add protobuf files: ${PROTOBUF_PROTO_FILES}")

    if(NOT PROTOBUF_PROTO_FILES)
        message(FATAL_ERROR "No .proto files specified for target ${target_name}")
    endif(NOT PROTOBUF_PROTO_FILES)

    set(PROTO_FILES ${PROTOBUF_PROTO_FILES})
    set(GENERATED_SRCS "")
    set(GENERATED_HDRS "")

    set(GENERATED_DIR "${CMAKE_CURRENT_BINARY_DIR}/protobuf_generated")

    foreach(PROTO_FILE ${PROTOBUF_PROTO_FILES})
        get_filename_component(PROTO_NAME ${PROTO_FILE} NAME_WE)
        get_filename_component(PROTO_DIR ${PROTO_FILE} DIRECTORY)
        set(GENERATED_SRC "${GENERATED_DIR}/${PROTO_NAME}.pb.cc")
        set(GENERATED_HDR "${GENERATED_DIR}/${PROTO_NAME}.pb.h")

        list(APPEND GENERATED_SRCS ${GENERATED_SRC})
        list(APPEND GENERATED_HDRS ${GENERATED_HDR})

        add_custom_command(
            OUTPUT ${GENERATED_SRC} ${GENERATED_HDR}
            COMMAND ${PROTOC_EXECUTABLE}
            ARGS --cpp_out ${GENERATED_DIR} ${PROTO_FILE}
            DEPENDS ${PROTO_FILE}
            COMMENT "Generating C++ code from ${PROTO_FILE}"
            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
            VERBATIM
        )
    endforeach()

    target_sources(${target_name} PRIVATE ${GENERATED_SRCS})
    target_include_directories(${target_name} PRIVATE ${GENERATED_DIR})
    target_link_libraries(${PROJECT_NAME} PRIVATE protobuf::libprotobuf)
endfunction(target_add_proto_files target)
