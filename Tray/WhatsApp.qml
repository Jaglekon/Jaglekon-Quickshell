import QtQuick
import Quickshell.Io
import Quickshell.Services.SystemTray
import "../Modules"
import "../Themes"
import "../Services"

Item {
  implicitWidth: whatsAppIcon.implicitWidth
  implicitHeight: whatsAppIcon.implicitHeight
  id: whatsAppTray

  function isWhatsAppTrayPresent() {
    for (let i = 0; i < SystemTray.items.values.length; ++i) {
      let item = SystemTray.items.values[i]
      if (item.tooltipTitle && item.tooltipTitle === "Altus")
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
      whatsAppTray.visible = whatsAppTray.isWhatsAppTrayPresent()
    }
  }

  Process {
    id: whatsAppProc
    command: ["altus"]
    running: false
  }
  

  Process {
    id: whatsAppKill
    command: ["sh", "-c", "pkill -f altus"]
    running: false
  }
  
  Click {
    anchors.fill: parent
    onLeftClicked: whatsAppProc.running = true
    onRightClicked: whatsAppKill.running = true
  }

  ModuleText {
    id: whatsAppIcon
    label: "󰖣"
    hovered: moduleRoot.hovered
  }

}