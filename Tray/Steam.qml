  
import QtQuick
import Quickshell.Io
import Quickshell.Services.SystemTray
import "../Modules"
import "../Themes"
import "../Services"

Item {
  implicitWidth: steamIcon.implicitWidth
  implicitHeight: steamIcon.implicitHeight
  id: steamTray
  
  function isSteamTrayPresent() {
    for (let i = 0; i < SystemTray.items.values.length; ++i) {
      let item = SystemTray.items.values[i]
      if ((item.appId && item.appId.toLowerCase().indexOf("steam") !== -1) ||
      (item.title && item.title.toLowerCase().indexOf("steam") !== -1)) {
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
      steamTray.visible = steamTray.isSteamTrayPresent()
    }
  }

  Process {
    id: steamProc
    command: ["steam"]
    running: false
  }

  

  Process {
      id: steamKill
      command: ["sh", "-c", "steam -shutdown"]
      running: false
  }

  Click {
    anchors.fill: parent
    onLeftClicked: steamProc.running = true
    onRightClicked: steamKill.running = true
  }

  ModuleText {
    id: steamIcon
    label: " "
    hovered: moduleRoot.hovered
  }
}