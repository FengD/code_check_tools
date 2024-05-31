cmake_minimum_required(VERSION 2.8)

project(code_check_tools)

# install
file(GLOB SCRIPTS scripts/*.sh)
install(FILES README.md DESTINATION .)
install(PROGRAMS ${SCRIPTS} DESTINATION .)
install(DIRECTORY scripts/tools DESTINATION . USE_SOURCE_PERMISSIONS)
