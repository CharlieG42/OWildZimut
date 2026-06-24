# OWildZimut - QtCreator Project File
# For PySide6/QML application

TARGET = OWildZimut
TEMPLATE = app

QT += qml quick widgets
CONFIG += c++17

# Python source
SOURCES += main.py

# QML resources
RESOURCES += 
    qml/main.qml 
    qml/LayerItem.qml 
    qml/LayerRenderer.qml 
    qml/MapView.qml

# Output directory
DESTDIR = bin

# QML import paths
QML_IMPORT_PATH = $$PWD/qml
QML_DESIGNER_IMPORT_PATH = $$PWD/qml

# For QtCreator Python support
QMAKE_ENV += PYTHONPATH=/usr/bin/python3

# Include PySide6 modules
unix {
    LIBS += -L/usr/lib/python3/dist-packages/PySide6 -lPySide6
}

win32 {
    LIBS += -L$$PWD/venv/Lib/site-packages/PySide6 -lPySide6
}