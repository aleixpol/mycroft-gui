# Set minimum CMake version (required for CMake 3.0 or later)
cmake_minimum_required(VERSION 2.8.12)
 
set(QT_MIN_VERSION "5.9.0")
set(KF5_MIN_VERSION "5.50.0")
 
PROJECT(mycroft-gui)

# Use Extra CMake Modules (ECM) for common functionality.
# See http://api.kde.org/ecm/manual/ecm.7.html
# and http://api.kde.org/ecm/manual/ecm-kde-modules.7.html
IF(POLICY CMP0063)
    CMAKE_POLICY(SET CMP0063 NEW)
ENDIF(POLICY CMP0063)

find_package(ECM 1.6.0 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR})

include(KDEInstallDirs)
include(ECMInstallIcons)
set(CMAKE_AUTOMOC ON)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -Wall -Werror")

#this is used for mycroft spawning. It's horrible and should not be needed, but mycroft packaging is questionable at best
#in any sane world mycroft would install something in $PATH
#the Android case is a temporary hack, adjust it to where and android app can find
if(CMAKE_SYSTEM_NAME STREQUAL "Android")
    set(MYCROFT_CORE_DIR ":")
else(MYCROFT_CORE_DIR "~/mycroft-core")
    set(MYCROFT_CORE_DIR "~/mycroft-core")
endif()

#configure_file(config-mycroft.h.in ${CMAKE_CURRENT_BINARY_DIR}/config-mycroft.h)
include_directories(${CMAKE_CURRENT_BINARY_DIR})

find_package(Qt5 ${QT_MIN_VERSION} CONFIG REQUIRED COMPONENTS
    Quick
    Core
    Qml
    Network
    WebSockets
    WebView
)

if(CMAKE_SYSTEM_NAME STREQUAL "Android")
    find_package(Qt5AndroidExtras ${QT_MIN_VERSION} REQUIRED)
    find_package(Qt5QuickControls2 ${QT_MIN_VERSION} REQUIRED)
    find_package(Qt5Svg ${QT_MIN_VERSION} REQUIRED)
    find_package(Qt5TextToSpeech ${QT_MIN_VERSION} REQUIRED)
    find_package(OpenSSL REQUIRED)
endif()

find_package(KF5 ${KF5_MIN_VERSION} REQUIRED COMPONENTS I18n)

if(NOT CMAKE_SYSTEM_NAME STREQUAL "Android")
    find_package(Qt5Widgets ${QT_MIN_VERSION} REQUIRED)
    find_package(KF5Plasma ${KF5_MIN_VERSION} REQUIRED)
    find_package(KF5KIO ${KF5_MIN_VERSION} REQUIRED) # FIXME look for "KIOWidgets" (KRun) explicitly
    find_package(LibKWorkspace 5.14.90 CONFIG REQUIRED)
endif()

add_definitions(-DQT_DISABLE_DEPRECATED_BEFORE=0)

#add_definitions(-Wno-deprecated)

add_definitions(-DQT_NO_URL_CAST_FROM_STRING -DQT_USE_QSTRINGBUILDER -DQT_NO_CAST_TO_ASCII -DQT_NO_CAST_FROM_ASCII)

add_subdirectory(application)
add_subdirectory(icons)

if(NOT CMAKE_SYSTEM_NAME STREQUAL "Android")
    add_subdirectory(applets)
    add_subdirectory(containments)
endif()

install(FILES MycroftMark2.colors
        DESTINATION ${DATA_INSTALL_DIR}/color-schemes/)

add_subdirectory(import)

# SSP: Disabled, now syncing with mycroft-core instance via sync_skills.sh
#
# install( DIRECTORY skills DESTINATION ${MYCROFT_CORE_DIR}/skills/ui
#     PATTERN "*.qmlc" EXCLUDE
# )

if(NOT CMAKE_SYSTEM_NAME STREQUAL "Android")
    plasma_install_package(lookandfeel org.mycroft.mark2 look-and-feel lookandfeel)
endif()

configure_file(data/mycroft-gui-core-loader.in ${CMAKE_CURRENT_BINARY_DIR}/mycroft-gui-core-loader)
install(PROGRAMS ${CMAKE_CURRENT_BINARY_DIR}/mycroft-gui-core-loader DESTINATION ${KDE_INSTALL_BINDIR})

if (BUILD_TESTING)
    add_subdirectory(autotests)
endif()

