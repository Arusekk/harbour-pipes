# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-pipes

CONFIG += sailfishapp_qml

DISTFILES += qml/harbour-pipes.qml \
    qml/cover/CoverPage.qml \
    qml/pages/PipesPage.qml \
    qml/pages/WinPage.qml \
    qml/pages/Settings.qml \
    rpm/harbour-pipes.changes.in \
    rpm/harbour-pipes.changes.run.in \
    rpm/harbour-pipes.spec \
    rpm/harbour-pipes.yaml \
    translations/*.ts \
    harbour-pipes.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-pipes.ts \
    translations/harbour-pipes-pl.ts
