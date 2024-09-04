cmake_minimum_required(VERSION 3.16)

project(firstProjectNewQt VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Core Gui Quick Quick3D Quick3DPhysics)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appfirstProjectNewQt
    main.cpp
    window.h window.cpp
)

qt_add_qml_module(appfirstProjectNewQt
    URI firstProjectNewQt
    VERSION 1.0
    QML_FILES
        Main.qml

    RESOURCES
        images/mc.jpg
        images/breaking/destroy_stage_0.png
        images/breaking/destroy_stage_1.png
        images/breaking/destroy_stage_2.png
        images/breaking/destroy_stage_3.png
        images/breaking/destroy_stage_4.png
        images/breaking/destroy_stage_5.png
        images/breaking/destroy_stage_6.png
        images/breaking/destroy_stage_7.png
        images/breaking/destroy_stage_8.png
        images/breaking/destroy_stage_9.png

        SOURCES window.h window.cpp
        RESOURCES block.vert
        RESOURCES images/block.frag
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appfirstProjectNewQt PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appfirstProjectNewQt
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appfirstProjectNewQt PUBLIC
    Qt::Core
    Qt::Gui
    Qt::Quick
    Qt::Quick3D
    Qt::Quick3DPhysics
)

include(GNUInstallDirs)
install(TARGETS appfirstProjectNewQt
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
