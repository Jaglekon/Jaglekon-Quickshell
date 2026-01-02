
import QtQuick
import Quickshell.Services.Mpris
import "../Modules"
import "../Themes"
import "../Services"

Item {
  id: mprisContainer
  implicitHeight: mpris.implicitHeight
  implicitWidth: mpris.implicitWidth
  property int playerNumber: 0
  property var player: Mpris.players.values.length > 0 ? Mpris.players.values[playerNumber] : null
  property string name: MprisPlayerIcons.playerTypeName(player)

  function scrollPlayer(delta) {
    let count = Mpris.players.values.length;
    if (count === 0) return;
    playerNumber = (playerNumber + (delta > 0 ? 1 : -1) + count) % count;
  }

  function togglePlaying() {
    var p = mprisContainer.player;
    if (p && p.canTogglePlaying) p.togglePlaying();
  }
  function next() {
    var p = mprisContainer.player;
    if (p && p.canGoNext) p.next();
  }
  function previous() {
    var p = mprisContainer.player;
    if (p && p.canGoPrevious) p.previous();
  }

  Row {
    id: mpris
    spacing: 10
    Item {
      visible: player !== null
      implicitWidth: iconPrevious.implicitWidth
      implicitHeight: iconPrevious.implicitHeight
      anchors.verticalCenter: parent.verticalCenter

      MouseArea {
        anchors.fill: parent
        preventStealing: false
        cursorShape: Qt.PointingHandCursor
        onClicked: mprisContainer.previous()
      }

      ModuleText {
        id: iconPrevious
        anchors.verticalCenter: parent.verticalCenter
        label: "󰒮"
        hovered: moduleRoot.hovered
      }

    }
    
    Item {
      visible: player !== null
      implicitWidth: iconPlay.implicitWidth
      implicitHeight: iconPlay.implicitHeight
      anchors.verticalCenter: parent.verticalCenter

      MouseArea {
        anchors.fill: parent
        preventStealing: false
        cursorShape: Qt.PointingHandCursor
        onClicked: mprisContainer.togglePlaying()
      }

      ModuleText {
        id: iconPlay
        label: player && player.isPlaying ? "󰏤" : "󰐊"
        font.pixelSize: Theme.fontPixelSize * 1.6
        hovered: moduleRoot.hovered
      }
    }

    Item {
      visible: player !== null
      implicitWidth: iconPlay.implicitWidth
      implicitHeight: iconPlay.implicitHeight
      anchors.verticalCenter: parent.verticalCenter

      MouseArea {
        anchors.fill: parent
        preventStealing: false
        cursorShape: Qt.PointingHandCursor
        onClicked: mprisContainer.next()
      }

      ModuleText {
        id: iconNext
        anchors.verticalCenter: parent.verticalCenter
        label: "󰒭"
        hovered: moduleRoot.hovered
      }
    }

    Loader {
      visible: player !== null
      anchors.verticalCenter: parent.verticalCenter
      active: true
      sourceComponent: name === " " ? ytMusicComponent : playerIconComponent
    }
    Component {
      id: playerIconComponent
      ModuleText {
        id: playerIcon
        anchors.verticalCenter: parent.verticalCenter
        label: name
        hovered: moduleRoot.hovered
        font.pixelSize: Theme.fontPixelSize * 1
      }
    }
    Component {
      id: ytMusicComponent
      YoutubeMusic {
        anchors.verticalCenter: parent.verticalCenter
      }
    }

    Column {
    id: titleColumn
    spacing: 0
    anchors.verticalCenter: parent.verticalCenter

      ModuleText {
        visible: player !== null
        hovered: moduleRoot.hovered
        label: player ? ((player.trackTitle && player.trackTitle.length > maxTitleLength)
        ? player.trackTitle.substring(0, maxTitleLength - 1) + "…"
        : (player.trackTitle || "-")) : "-"
        font.pixelSize: Theme.fontPixelSize * 0.8
      }
      ModuleText {
        visible: player !== null
        hovered: moduleRoot.hovered
        label: player ? ((player.trackArtist && player.trackArtist.length > maxTitleLength)
        ? player.trackArtist.substring(0, maxTitleLength - 1) + "…"
        : (player.trackArtist || "-")) : "-"
        font.pixelSize: Theme.fontPixelSize * 0.8
      }
    } 
  }
}