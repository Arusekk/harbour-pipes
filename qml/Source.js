.import "DB.js" as DB

function loadSave(save) {
	game.pipeState.clear()
	for (var i=0; i<save.length; i++)
		game.pipeState.append({data: save.charCodeAt(i) - 48})
}

function save(){
	if (game.dimensionX !== -1 && !game.won){
		DB.save(function(i, j){return game.pipeState.get(game.pipeAt(i, j)).data}, game.dimensionX, game.dimensionY)
		DB.setSavedTime(game.dimensionX, game.dimensionY, game.time)
	}
}

var cCONN_UP = 1
var cCONN_RIGHT = 2
var cCONN_DOWN = 4
var cCONN_LEFT = 8
var cCONN_OVERFLOW = 17

function connectedDeltas(gridX, gridY, connections, all) {
	var chk = []
	if (gridY > 0 &&
	    (connections&cCONN_UP))
		chk.push([0, -1, cCONN_DOWN])
	if (gridX+1 < game.dimensionX &&
	    ((connections&cCONN_RIGHT) || all))
		chk.push([1, 0, cCONN_LEFT])
	if (gridY+1 < game.dimensionY &&
	    ((connections&cCONN_DOWN) || all))
		chk.push([0, 1, cCONN_UP])
	if (gridX > 0 &&
	    ((connections&cCONN_LEFT) || all))
		chk.push([-1, 0, cCONN_RIGHT])
	return chk
}

function updateNeighbours(gridX, gridY, inConnectedSet) {
	var chk = connectedDeltas(gridX, gridY)
	for (var i = 0; i < chk.length; i++) {
		var v = chk[i]
		var pipe = rectGrid.pipeAt(gridX + v[0], gridY + v[1])
		if (pipe.connections&v[2])
			pipe.inConnectedSet = inConnectedSet
	}
}
function connectedNeigh(idx, inSet) {
	var gridX = idx % game.dimensionX
	var gridY = (idx - gridX) / game.dimensionX
	var deltas = connectedDeltas(gridX, gridY, game.pipeState.get(idx).data)
	var ret = []
	for (var i = 0; i < deltas.length; i++) {
		var delta = deltas[i]
		var neigh = game.pipeAt(gridX + delta[0], gridY + delta[1])
		var neighconn = game.pipeState.get(neigh).data;
		if ((neighconn & delta[2]) && (inSet ^ neighconn & 16))
			ret.push(neigh)
	}
	return ret
}

function rotate(connections, clockwise) {
	if (clockwise) {
		connections <<= 1
		if (connections & cCONN_OVERFLOW)
			connections ^= cCONN_OVERFLOW
	}
	else {
		if (connections & cCONN_OVERFLOW)
			connections ^= cCONN_OVERFLOW
		connections >>= 1
	}
	return connections
}
function rotateRandom(connections) {
	for (var i = Math.random()*4; i > 0; i -= 1)
		connections = rotate(connections, true)
	return connections
}
function doRotate(idx, clockwise) {
	var conn = game.pipeState.get(idx).data
	conn = (conn & 16) | rotate(conn & 15, clockwise)
	game.pipeState.set(idx, {data: conn})
}
function doRotateRandom(idx) {
	var conn = game.pipeState.get(idx).data
	conn = (conn & 16) | rotateRandom(conn & 15)
	game.pipeState.set(idx, {data: conn})
}

function addConn(idx, v) {
	game.pipeState.set(idx, {data: (game.pipeState.get(idx).data & 15) | v})
}

function maybeConnectRandom(idx) {
	var connections = game.pipeState.get(idx).data
	var gridX = idx % game.dimensionX
	var gridY = (idx - gridX) / game.dimensionX
	var chk = [], targ, targConn
	if (gridY > 0 && !(connections&cCONN_UP)) {
		targ = game.pipeAt(gridX, gridY-1)
		targConn = game.pipeState.get(targ).data
		if (!(targConn & 16))
			chk.push([targ, cCONN_DOWN, cCONN_UP])
	}
	if (gridX+1 < game.dimensionX && !(connections&cCONN_RIGHT)) {
		targ = game.pipeAt(gridX+1, gridY)
		targConn = game.pipeState.get(targ).data
		if (!(targConn & 16))
			chk.push([targ, cCONN_LEFT, cCONN_RIGHT])
	}
	if (gridY+1 < game.dimensionY && !(connections&cCONN_DOWN)) {
		targ = game.pipeAt(gridX, gridY+1)
		targConn = game.pipeState.get(targ).data
		if (!(targConn & 16))
			chk.push([targ, cCONN_UP, cCONN_DOWN])
	}
	if (gridX > 0 && !(connections&cCONN_LEFT)) {
		targ = game.pipeAt(gridX-1, gridY)
		targConn = game.pipeState.get(targ).data
		if (!(targConn & 16))
			chk.push([targ, cCONN_RIGHT, cCONN_LEFT])
	}
	if (!chk.length)
		return
	var i = Math.floor(Math.random() * chk.length)
	targ = chk[i][0]
	addConn(targ, chk[i][1] | 16)
	addConn(idx, chk[i][2] | 16)
	return targ
}
