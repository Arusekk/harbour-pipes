
import QtQuick 2.0
import "../Source.js" as Source

Rectangle {
        height: unitSize
        width: height

        property int connections: 0
        property bool inConnectedSet: false
        color: Qt.rgba(0, 0, 0, 0.1)

        PipeLookCnv { anchors.fill: parent }
        MouseArea {
                anchors.fill: parent
                onClicked: {
                        Source.doRotate(model.index, true)
                        if (inConnectedSet)
                            rectGrid.clearConnections()
                        else {
                            var neigh = Source.connectedNeigh(model.index, 0)
                            if (neigh.length)
                                rectGrid.checkConnections(model.index)
                        }
                }
        }
}
