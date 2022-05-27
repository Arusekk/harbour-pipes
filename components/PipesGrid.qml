
import QtQuick 2.0
import Sailfish.Silica 1.0
import "../Source.js" as Source

Rectangle {
    id: rectGrid

    property int connectedCount: 0

    Component.onCompleted: {
        game.newGame.connect(newGame)
        game.checkConnections.connect(clearConnections)
    }

    onConnectedCountChanged: {
        if (connectedCount === game.dimensionX * game.dimensionY)
            game.win()
    }

    function newGame() {
        connectedCount = 0
        buildPipes()
        scramblePipes()
        clearConnections()
    }

    function clearConnections() {
        connectedCount = 0
        for (var i = 0; i < game.dimensionY; i++)
            for (var j = 0; j < game.dimensionX; j++)
                Source.addConn(game.pipeAt(j, i), 0)
        checkConnections(pipeAt(game.dimensionX >> 1, game.dimensionY >> 1))
    }

    function checkConnections(pipe) {
        var pipes = [pipe]
        while (pipes.length) {
            pipe = pipes.pop()
            Source.addConn(pipe, 16)
            connectedCount++
            var neigh = Source.connectedNeigh(pipe, 16)
            for (var i = 0; i < neigh.length; i++) {
                var newpipe = neigh[i]
                Source.addConn(newpipe, 16)
                pipes.push(newpipe)
            }
        }
    }

    function scramblePipes() {
        for (var i = 0; i < game.dimensionY; i++)
            for (var j = 0; j < game.dimensionX; j++)
                Source.doRotateRandom(pipeAt(j,i))
    }

    function buildPipes() {
        game.pipeState.clear()
        for (var i=0; i<game.dimensionY; i++)
            for (var j=0; j<game.dimensionX; j++)
                game.pipeState.append({data: 0})
        var disconnectedPipes = game.dimensionX * game.dimensionY - 1
        var pipe = pipeAt(game.dimensionX >> 1, game.dimensionY >> 1)
        Source.addConn(pipe, 16)
        var acceptablePipes = [pipe]
        while (disconnectedPipes > 0 && acceptablePipes.length) {
            var i = Math.floor(Math.random() * acceptablePipes.length)
            pipe = acceptablePipes[i]
            var newpipe = Source.maybeConnectRandom(pipe)
            if (typeof newpipe === "undefined")
                acceptablePipes[i] = acceptablePipes.pop()
            else {
                acceptablePipes.push(newpipe)
                disconnectedPipes--
            }
        }
    }

    Grid {
        id: pGrid
        anchors.fill: parent
        spacing: insideBorderSize
        columns: game.dimensionX
        Repeater {
            model: game.pipeState
            Pipe {
                connections: model.data & 15
                inConnectedSet: model.data & 16
            }
        }
    }
}
