import QtQuick 2.0
import Sailfish.Silica 1.0
import "../DB.js" as DB
import "../components"

Dialog {
    id: winPage
    property int dimDelta: DB.getParameter("increasingDifficulty")?1:0
    property int nextDimensionX: game.dimensionX + dimDelta
    property int nextDimensionY: game.dimensionY + dimDelta

    property int dimensionXcpy
    property string titlecpy
    property int time
    property ListModel modelcpy: ListModel {}

    Component.onCompleted: {
        dimensionXcpy = game.dimensionX
        titlecpy = game.dimensionX + "x" + game.dimensionY
        time = DB.getTime(game.dimensionX, game.dimensionY)
        for (var y = 0; y < game.dimensionY; y++)
            for (var x = 0; x < game.dimensionX; x++)
                modelcpy.append({"data": game.pipeState.get(game.pipeAt(x, y)).data})
    }

    canAccept: nextDimensionX !== -1 && nextDimensionY !== -1

    Column {
        anchors.fill: parent
        DialogHeader {
            title: qsTr("Puzzle completed!")
            acceptText: qsTr("Next puzzle")
            cancelText: qsTr("Back")
        }
        SectionHeader {
            text: qsTr("Solution")
        }
        Rectangle {
            border.width: 5
            border.color: Theme.rgba(Theme.highlightColor, 0.3)
            width: parent.width * 3 / 4
            height: width
            color: Theme.rgba("black", 0.1)
            anchors.horizontalCenter: parent.horizontalCenter
            Grid {
                id: myFinalGrid
                anchors.centerIn: parent
                width:  0.9 * Math.min(parent.width, parent.height * game.dimensionX / game.dimensionY)
                height: 0.9 * Math.min(parent.height, parent.width * game.dimensionY / game.dimensionX)
                columns: dimensionXcpy
                spacing: 5
                Repeater {
                    model: modelcpy
                    PipeLookCnv {
                        width: (myFinalGrid.width - (dimensionXcpy - 1) * myFinalGrid.spacing) / dimensionXcpy
                        height: width
                        inConnectedSet: true
                        connections: model.data & 15
                    }
                }
            }
        }
        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: titlecpy
        }
        Label {
            anchors.topMargin: Theme.paddingLarge
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.highlightColor
            text: qsTr("Your time:")
        }
        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: game.time === 0 ? "xx:xx:xx" :
                  game.time >= 60*60*23 ? "24:00:00+" :
                  new Date(null, null, null, null, null, game.time).toLocaleTimeString(Qt.locale(), "HH:mm:ss")
        }
        Label {
            anchors.topMargin: Theme.paddingLarge
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.highlightColor
            text: qsTr("Best time:")
        }
        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: time === 0 ? "xx:xx:xx" :
                  time >= 60*60*23 ? "24:00:00+" :
                  new Date(null, null, null, null, null, time).toLocaleTimeString(Qt.locale(), "HH:mm:ss")
        }
    }
    onAccepted: {
        game.dimensionX = nextDimensionX
        game.dimensionY = nextDimensionY
        game.gridUpdated()
    }
}
