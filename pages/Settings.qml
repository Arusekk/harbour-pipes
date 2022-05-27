import QtQuick 2.0
import Sailfish.Silica 1.0
import "../DB.js" as DB

Page {
    id: settingsPage

    RemorsePopup { id: remorseSettings }
    Column {
        spacing: Theme.paddingMedium
        width: parent.width

        PageHeader { title: qsTr("Settings") }
        TextSwitch {
            checked: DB.getParameter("increasingDifficulty") === 1
            text: qsTr("Increasing difficulty")
            description: checked ?
                qsTr("Difficulty will increase whenever you complete a level") :
                qsTr("You must increase difficulty yourself in this settings page")
            onClicked: DB.setParameter("increasingDifficulty", checked ? 1 : 0)
        }
        Slider {
            id: sliderX
            width: parent.width
            label: qsTr("Horizontal dimension")
            minimumValue: 2
            maximumValue: 30
            stepSize: 1
            value: game.dimensionX
            valueText: value
        }
        Slider {
            id: sliderY
            width: parent.width
            label: qsTr("Vertical dimension")
            minimumValue: 2
            maximumValue: 30
            stepSize: 1
            value: game.dimensionY
            valueText: value
        }
        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Warning: the chosen size exceeds\nthe recommended maximum of 100 tiles.\nThe game may work really slow.")
            color: "red"
            visible: sliderX.value * sliderY.value > 100
        }
        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Clear ALL databases (saves & progress)")
            onClicked: {
                remorseSettings.execute(qsTr("Clearing ALL Databases"), function(){
                    DB.destroyData()
                    DB.initialize()
                })
            }
        }
        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Clear only saves database")
            onClicked: {
                remorseSettings.execute(qsTr("Clearing only saves database"), function(){
                    DB.destroySaves()
                    DB.initializeSaves()
                })
            }
        }
        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Reset settings")
            onClicked: {
                remorseSettings.execute(qsTr("Resetting settings"), function(){
                    DB.destroySettings()
                    pageStack.pop()
                })
            }
        }
    }
    Component.onDestruction: {
        game.pause = false
        game.dimensionX = sliderX.value
        game.dimensionY = sliderY.value
    }
}
