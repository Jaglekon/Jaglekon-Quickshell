import QtQuick
import Quickshell.Io
import "../Modules"
import "../Services"

ModuleWidget {
  id: reboot
  Item {
    implicitHeight: root.widgetHeight
    implicitWidth: rebootText.height
    Process {
      id: rebootProc
      command: ["systemctl", "reboot"]
      running: false
    }
    ModuleText {
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.verticalCenter: parent.verticalCenter
      id: rebootText
      label: " "
      hovered: reboot.hovered
    }
    Click {
      anchors.fill: parent
      onLeftClicked: {
        rebootProc.running = true;
      }
    }
  }
}