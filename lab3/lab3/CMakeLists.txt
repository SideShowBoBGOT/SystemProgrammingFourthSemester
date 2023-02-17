cmake_minimum_required(VERSION 3.5)

project(lab3 LANGUAGES C)

add_executable(lab3 main.c)

install(TARGETS lab3
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
