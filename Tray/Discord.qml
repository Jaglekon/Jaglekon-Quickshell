import QtQuick
import Quickshell.Io
import Quickshell.Services.SystemTray
import "../Modules"
import "../Themes"
import "../Services"

Item {
  implicitWidth: vesktopIcon.implicitWidth
  implicitHeight: vesktopIcon.implicitHeight
  id: vesktopTray

  function isVesktopTrayPresent() {
    for (let i = 0; i < SystemTray.items.values.length; ++i) {
      let item = SystemTray.items.values[i]
      if (item.tooltipTitle && item.tooltipTitle === "Vesktop")
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
      vesktopTray.visible = vesktopTray.isVesktopTrayPresent()
    }
  }

  Process {
    id: vesktopProc
    command: ["vesktop"]
    running: false
  }
  

  Process {
    id: vesktopKill
    command: ["sh", "-c", "pkill -f vesktop"]
    running: false
  }
  
  Click {
    anchors.fill: parent
    onLeftClicked: vesktopProc.running = true
    onRightClicked: vesktopKill.running = true
  }

  ModuleText {
    id: vesktopIcon
    label: "\uf392"
    y: 1
    hovered: moduleRoot.hovered
  }

}