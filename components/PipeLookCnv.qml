
import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle {
    property int connections: parent.connections
    property bool inConnectedSet: parent.inConnectedSet
    id: thisrect
    color: Qt.rgba(0, 0, 0, 0.1)
    Repeater {
        model: 4
        Item {
            property int side: index
            id: thisConn
            anchors.fill: parent
            visible: (thisrect.connections & (1 << index)) !== 0
//            Behavior on opacity { NumberAnimation { duration: 100 } }
            rotation: 90 * side
            clip: true
            Rectangle {
                color: thisrect.inConnectedSet?Theme.highlightColor:Theme.primaryColor
                property int halfWidth: (parent.width + 1) / 6
                width: halfWidth * 2 | (parent.width & 1)
                height: parent.height
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -width - 2
                radius: width
            }
        }
    }
}

