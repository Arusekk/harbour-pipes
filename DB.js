.import QtQuick.LocalStorage 2.0 as LS

function save(gridAt, dimensionX, dimensionY){
    var str = ""
    for (var i = 0; i < dimensionY; i++)
        for (var j = 0; j < dimensionX; j++) {
            var state = gridAt(j, i)
            str += String.fromCharCode(48 + state)
        }
    setSave(dimensionX, dimensionY, str)
}

function getDatabase() {
    return LS.LocalStorage.openDatabaseSync("Pipes", "1.0", "StorageDatabase", 100000)
}

function initialize() {
    var db = getDatabase()
    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS tcompleted(dimensionX INT, dimensionY INT,isCompleted BOOLEAN, PRIMARY KEY(dimensionX, dimensionY))')
                    tx.executeSql('CREATE TABLE IF NOT EXISTS tsave(dimensionX INT, dimensionY INT, save TEXT, PRIMARY KEY(dimensionX, dimensionY))')
                    tx.executeSql('CREATE TABLE IF NOT EXISTS ttime(dimensionX INT, dimensionY INT, time INT, PRIMARY KEY(dimensionX, dimensionY))')
                    tx.executeSql('CREATE TABLE IF NOT EXISTS tsavedtime(dimensionX INT, dimensionY INT, time INT, PRIMARY KEY(dimensionX, dimensionY))')
                    tx.executeSql('CREATE TABLE IF NOT EXISTS tsettings(param TEXT, value INT, PRIMARY KEY(param))')
                    tx.executeSql('INSERT OR IGNORE INTO tsettings(param, value) VALUES (\'autoLoadSave\', 1), (\'dimensionX\', 7), (\'dimensionY\', 9)')
                })
}
function initializeSaves() {
    var db = getDatabase()
    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS tsave(dimensionX INT, dimensionY INT, save TEXT, PRIMARY KEY(dimensionX, dimensionY))')
                })
}

function setIsCompleted(dimensionX, dimensionY, isCompleted) {
    var db = getDatabase()
    var ret = false
    db.transaction(function(tx) {
        var rs = tx.executeSql('INSERT OR REPLACE INTO tcompleted VALUES (?, ?, ?);', [dimensionX, dimensionY, isCompleted])
        if (rs.rowsAffected > 0) {
            ret = true
        }
        else {
            ret = false
        }
    }
    )
    return ret
}
function setSave(dimensionX, dimensionY, save) {
    var db = getDatabase()
    var ret = false
    db.transaction(function(tx) {
        var rs = tx.executeSql('INSERT OR REPLACE INTO tsave VALUES (?, ?, ?);', [dimensionX, dimensionY, save])
        if (rs.rowsAffected > 0) {
            ret = true
        }
        else {
            ret = false
        }
    }
    )
    return ret
}
function setTime(dimensionX, dimensionY, time) {
    var db = getDatabase()
    var ret = false
    db.transaction(function(tx) {
        var rs = tx.executeSql('INSERT OR REPLACE INTO ttime VALUES (?, ?, ?);', [dimensionX, dimensionY, time])
        if (rs.rowsAffected > 0) {
            ret = true
        }
        else {
            ret = false
        }
    }
    )
    return ret
}
function setSavedTime(dimensionX, dimensionY, time) {
    var db = getDatabase()
    var ret = false
    db.transaction(function(tx) {
        var rs = tx.executeSql('INSERT OR REPLACE INTO tsavedtime VALUES (?, ?, ?);', [dimensionX, dimensionY, time])
        if (rs.rowsAffected > 0) {
            ret = true
        }
        else {
            ret = false
        }
    }
    )
    return ret
}
function setParameter(param, value){
    var db = getDatabase()
    var ret = false
    db.transaction(function(tx) {
        var rs = tx.executeSql('INSERT OR REPLACE INTO tsettings VALUES (?, ?);', [param, value])
        if (rs.rowsAffected > 0) {
            ret = true
        }
        else {
            ret = false
        }
    }
    )
    return ret
}

function isCompleted(dimensionX, dimensionY) {
    var db = getDatabase()
    var ret = true
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT isCompleted FROM tcompleted WHERE (dimensionX=? AND dimensionY=?);', [dimensionX, dimensionY])
        if (rs.rows.length > 0) {
            ret = true
        } else {
            ret = false
        }
    })
    return ret
}

function eraseSave(dimensionX, dimensionY){
    var db = getDatabase()
    var ret = true
    db.transaction(function(tx) {
        var rs = tx.executeSql('DELETE FROM tsave WHERE (dimensionX=? AND dimensionY=?);', [dimensionX, dimensionY])
        if (rs.rows.length > 0) {
            ret = true
        } else {
            ret = false
        }
    })
    return ret
}

function getNbCompletedLevel(dimensionX){
    var db = getDatabase()
    var ret = 0
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT COUNT(*) AS myCount FROM tcompleted WHERE (dimensionX=? AND isCompleted=\'true\');', [dimensionX])
        if (rs.rows.length > 0) {
            ret = rs.rows.item(0).myCount
        } else {
            ret = 0
        }
    })
    return ret
}


function getSave(dimensionX, dimensionY) {
    var db = getDatabase()
    var ret = ""
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT save FROM tsave WHERE (dimensionX=? AND dimensionY=?);', [dimensionX, dimensionY])

        if (rs.rows.length > 0) {
            ret = rs.rows.item(0).save
        } else {
            ret = ""
        }
    })
    return ret
}
function getTime(dimensionX, dimensionY) {
    var db = getDatabase()
    var ret = 0
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT time FROM ttime WHERE (dimensionX=? AND dimensionY=?);', [dimensionX, dimensionY])

        if (rs.rows.length > 0) {
            ret = rs.rows.item(0).time
        }
    })
    return ret
}
function getSavedTime(dimensionX, dimensionY) {
    var db = getDatabase()
    var ret = 0
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT time FROM tsavedtime WHERE (dimensionX=? AND dimensionY=?);', [dimensionX, dimensionY])

        if (rs.rows.length > 0) {
            ret = rs.rows.item(0).time
        }
    })
    return ret
}
function getParameter(param){
    var db = getDatabase()
    var ret = -1
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT value FROM tsettings WHERE (param=?);', [param])

        if (rs.rows.length > 0) {
            ret = rs.rows.item(0).value
        } else {
            ret = -1
        }
    })
    return ret
}

function destroyData() {
    var db = getDatabase()
    db.transaction(function(tx) {
        var rs = tx.executeSql('DROP TABLE tsave')
        rs = rs && tx.executeSql('DROP TABLE tcompleted')
        rs = rs && tx.executeSql('DROP TABLE tsavedtime')
        rs = rs && tx.executeSql('DROP TABLE ttime')
    })
}
function destroySaves() {
    var db = getDatabase()
    db.transaction(function(tx) {
        var rs = tx.executeSql('DROP TABLE tsave')
        rs = rs && tx.executeSql('DROP TABLE tsavedtime')
    })
}
function destroySettings(){
    var db = getDatabase()
    db.transaction(function(tx) {
        var rs = tx.executeSql('DROP TABLE tsettings')
    })
    initialize()
}
