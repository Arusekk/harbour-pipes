
import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

Page {
    id: page

    property int insideBorderSize: 5
    property real unitSize: game.zoom * Math.min(
        (width  - (game.dimensionX - 1) * insideBorderSize) / game.dimensionX,
        (height - (game.dimensionY - 1) * insideBorderSize) / game.dimensionY
    )

    RemorsePopup { id: remorseMain }

    // Set pinch area
    PinchArea {
        id: pinchArea
        property real initialZoom
        property real zoomTmp: -1
        anchors.fill: parent
        onPinchStarted: {
            if (game.dimensionX !== 0)
                popupZoom.opacity = 1
            initialZoom = game.zoom
            zoomTmp = game.zoom
        }
        onPinchUpdated: {
            zoomTmp = (initialZoom * pinch.scale > zoomProg.maximumValue) ? zoomProg.maximumValue :
                (initialZoom * pinch.scale < zoomProg.minimumValue) ? zoomProg.minimumValue :
                initialZoom * pinch.scale
        }
        onPinchFinished: {
            popupZoom.opacity = 0
            if (game.dimensionX !== 0)
                game.zoom = zoomTmp
            zoomTmp = -1
        }

        Rectangle {
            color: "transparent"
            anchors.fill: parent
        }
    }

    // PopUp Zoom
    Rectangle {
        id: popupZoom
        z: 3
        opacity: 0
        color: Theme.rgba("black", 0.5)
        anchors.fill: page
        Rectangle {
            color: Theme.rgba("black", 0.2)
            width: page.width / 2
            height: popupZoomText.height
            anchors.centerIn: parent
            Column {
                id: popupZoomText
                anchors.horizontalCenter: parent.horizontalCenter
                Label {
                    text: qsTr("Zoom")
                    color: Theme.highlightColor
                    font.pixelSize: Theme.fontSizeLarge
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "x" + zoomProg.value
                }
                ProgressBar {
                    id: zoomProg
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: page.width/2
                    maximumValue: 5
                    minimumValue: 1
                    value: Math.floor(10 * (pinchArea.zoomTmp === -1 ? game.zoom : pinchArea.zoomTmp)) / 10
                }
            }

        }

        Behavior on opacity { NumberAnimation { duration: 200 } }
    }

    SilicaFlickable {
        anchors.fill: parent

        Item {
            anchors.centerIn: parent
            width:  Math.min(parent.width, game.zoom * parent.height * game.dimensionX / game.dimensionY)
            height: Math.min(parent.height, game.zoom * parent.width * game.dimensionY / game.dimensionX)
            SilicaFlickable {
                clip: true
                anchors.fill: parent
                pressDelay: 0
                id: flick
                contentWidth:  game.dimensionX * unitSize + (game.dimensionX - 1) * insideBorderSize
                contentHeight: game.dimensionY * unitSize + (game.dimensionY - 1) * insideBorderSize
                VerticalScrollDecorator {}
                HorizontalScrollDecorator {}

                Column {
                    id: column
                    width: game.zoom * theGrid.width
                    spacing: Theme.paddingLarge
                    PipesGrid { id: theGrid }
                }
            }
        }
        // PullDown
        PullDownMenu {
            enabled: true
            MenuItem {
                    id: menuSettings
                    text: qsTr("Settings")
                    onClicked: {
                            game.pause = true
                            pageStack.push(Qt.resolvedUrl("Settings.qml"))
                    }
            }
            MenuItem {
                    id: menuClear
                    text: qsTr("Scramble pipes")
                    onClicked: remorseMain.execute(qsTr("Scrambling the pipes"), function(){theGrid.scramblePipes()}, 3000)
            }
            MenuItem {
                    id: menuNewGame
                    text: qsTr("New game")
                    onClicked: remorseMain.execute(qsTr("Initializing new game"), function(){theGrid.newGame()}, 3000)
            }
        }
    }
}

