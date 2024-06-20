cmake_minimum_required(VERSION 3.10)

project(example)

add_subdirectory(.. protobuf)

add_executable(${PROJECT_NAME} main.cpp Person.pb.cc)

target_include_directories(${PROJECT_NAME} PUBLIC "include")

target_link_libraries(${PROJECT_NAME} PRIVATE protobuf::libprotobuf)
