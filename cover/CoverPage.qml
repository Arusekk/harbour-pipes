
import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

CoverBackground {
    Label {
        visible: game.dimension !== 0
        anchors.horizontalCenter: parent.horizontalCenter
        text: new Date(null, null, null, null, null, game.time).toLocaleTimeString(Qt.locale(), "HH:mm:ss")
    }
    Rectangle {

        transform: [Rotation { angle: 33 }, Scale { xScale: 2; yScale: 2 }, Translate { x: width/3; y: width/5 }]
        id: rectGrille
        color: Qt.rgba(0, 0, 0, 0.1)
        width: parent.width * 0.9
        height: width
        radius: width * 0.01

        Grid {
            id: grille
            width: parent.width * 0.95
            height: width
            anchors.centerIn: parent
            spacing: 2
            columns: game.dimensionX
            visible: grille.children.length === game.dimensionX * game.dimensionY + 1
            Repeater {
                id: myRepeat
                model: game.pipeState
                PipeLookCnv {
                    connections: model.data & 15
                    inConnectedSet: model.data & 16
                    width: (rectGrille.width - (game.dimensionX - 1) * 2) / game.dimensionX
                    height: width
                    radius: rectGrille.radius
                }
            }
        }
    }

    Label {
        id: label
        anchors.centerIn: parent
        text: qsTr("Pipes")
    }

    CoverActionList {
        id: coverAction

        CoverAction {
            iconSource: "image://theme/icon-cover-new"
            onTriggered: {
               if (!game.applicationActive) {
                    game.activate()
                }
            }
        }
    }

}
