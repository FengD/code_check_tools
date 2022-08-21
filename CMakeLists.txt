cmake_minimum_required(VERSION 2.8)

project(code_check_tools)

# install
file(GLOB SCRIPTS scripts/*.sh)
install(FILES README.md DESTINATION .)
install(FILES ${SCRIPTS} DESTINATION . PERMISSIONS WORLD_EXECUTE)
install(DIRECTORY scripts/tools DESTINATION . USE_SOURCE_PERMISSIONS)
