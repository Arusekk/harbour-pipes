
import QtQuick 2.0

Image {
        anchors.left: parent.left
        anchors.leftMargin: -parent.connections*parent.width
        anchors.top: parent.top
        anchors.topMargin: -parent.inConnectedSet*parent.height
        width: 16*parent.width
        height: 2*parent.height
        fillMode: Image.PreserveAspectCrop
        smooth: true
        source: Qt.resolvedUrl("../PipesJ2ME-res/" + best(parent.height) + ".png")

        function best(v) {
                if (v <= 9) return 9;
                if (v <= 15) return 15;
                if (v <= 21) return 21;
                return 42;
        }
}

