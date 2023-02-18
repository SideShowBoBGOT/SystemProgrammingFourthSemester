cmake_minimum_required(VERSION 3.5)

project(lab4 LANGUAGES C)

add_executable(lab4 main.c)

install(TARGETS lab4
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
