cmake_minimum_required(VERSION 3.17)
project(externpro)
set(XP_INSTALL_INFO "Installers located at https://github.com/smanders/externpro/releases")
include(modules/macpro.cmake)
proInit()
proAddProjectDir(projects)
proExecuteStep()
