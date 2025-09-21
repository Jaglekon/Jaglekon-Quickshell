import QtQuick
import Quickshell.Io
import "../Modules"
import "../Services"

ModuleWidget {
  id: lock
  Item {
    implicitHeight: root.widgetHeight
    implicitWidth: lockText.height
    ModuleText {
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.verticalCenter: parent.verticalCenter
      id: lockText
      label: "󰌾 "
      hovered: lock.hovered
    }
    Process {
      id: lockProc
      command: ["loginctl", "lock-session"]
      running: false
    }
    Click {
      anchors.fill: parent
      onLeftClicked: {
        lockProc.running = true;
      }
    }
  }
}