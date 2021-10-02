cmake_minimum_required(VERSION 2.8)

project(code_check_tools)

# install
file(GLOB SCRIPTS *.sh)
install(FILES ${SCRIPTS} DESTINATION bin/)
install(DIRECTORY tools DESTINATION bin/)
