
import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"
import "Source.js" as Source
import "DB.js" as DB


ApplicationWindow {
    id: game
    initialPage: Component { PipesPage {} }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")

    signal gridUpdated
    signal win
    signal newGame
    signal checkConnections

    property int time: 0

    property bool won: false
    property bool pause: false

    property int dimensionX: 0
    property int dimensionY: 0
    property real zoom: 1

    property string save: ""

    property bool completedSet: false
    property int maxHeight: 0
    property int maxWidth: 0
    property var pipeState: ListModel {}

    function pipeAt(x, y) {
        return y * dimensionX + x
    }

    onDimensionXChanged: {
        DB.setParameter("dimensionX", dimensionX)
        if (completedSet)
            gridUpdated()
    }
    onDimensionYChanged: {
        DB.setParameter("dimensionY", dimensionY)
        if (completedSet)
            gridUpdated()
    }

    Component.onCompleted: {
        DB.initialize()
        dimensionX = DB.getParameter("dimensionX")
        dimensionY = DB.getParameter("dimensionY")

        //Parameters
        completedSet = true
        gridUpdated()
    }
    Component.onDestruction: {
        Source.save()
    }
    onApplicationActiveChanged: {
        if(!applicationActive){
            Source.save()
            game.pause=true
        } else {
            if(pageStack.depth === 1)
                game.pause=false
        }
    }

    onGridUpdated: {
        if (DB.getParameter("autoLoadSave"))
            save = DB.getSave(game.dimensionX, game.dimensionY)
        else
            save = ""
        maxWidth=0
        maxHeight=0
        won=false
        if (save) {
            Source.loadSave(save)
            game.time = DB.getSavedTime(dimensionX, dimensionY)
            game.checkConnections()
        } else {
            game.newGame()
            game.time = 0
        }
        pause = false
        game.zoom = 1
    }

    onWin: {
        game.won = true
        DB.setIsCompleted(dimensionX, dimensionY, 'true')
        DB.eraseSave(dimensionX, dimensionY)
        if (DB.getTime(dimensionX, dimensionY) === 0 || DB.getTime(dimensionX, dimensionY) > game.time)
            DB.setTime(dimensionX, dimensionY, game.time)
        pageStack.push(Qt.resolvedUrl("pages/WinPage.qml"))
    }

    Timer {
        id: myTimer
        repeat: true
        onTriggered: if (!won && !pause) game.time++

        Component.onCompleted: myTimer.start()
    }
}
