import QtQuick
import Quickshell.Io
import Quickshell.Services.Mpris
import "../Modules"
import "../Themes"
import "../Services"

Item {
  implicitWidth: feishinIcon.implicitWidth
  implicitHeight: feishinIcon.implicitHeight
  id: feishinTray
  function isFeishinTrayPresent() {
    for (let i = 0; i < Mpris.players.values.length; ++i) {
      let item = Mpris.players.values[i]
      if (item.identity.indexOf("Feishin") !== -1)
      {
        return true
      }
    }
    return false
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: {
      feishinTray.visible = feishinTray.isFeishinTrayPresent()
    }
  }

  Process {
    id: feishinProc
    command: ["feishin"]
    running: false
  }
  

  Process {
    id: feishinKill
    command: ["sh", "-c", "gdbus call --session --dest org.mpris.MediaPlayer2.Feishin --object-path /org/mpris/MediaPlayer2 --method org.mpris.MediaPlayer2.Quit"]
    running: false
  }
  
  Click {
    anchors.fill: parent
    onLeftClicked: feishinProc.running = true
    onRightClicked: feishinKill.running = true
  }

  ModuleText {
    id: feishinIcon
    label: "󰽰 "
    hovered: moduleRoot.hovered
  }

}