import QtQuick
import Quickshell.Io
import "../Modules"
import "../Services"

ModuleWidget {
  id: turnOff
  Item {
    implicitHeight: root.widgetHeight
    implicitWidth: powerText.height
    Process {
      id: turnOffProc
      command: ["systemctl", "poweroff"]
      running: false
    }
    ModuleText {
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.verticalCenter: parent.verticalCenter
      id: powerText
      label: "⏻ "
      hovered: turnOff.hovered
    }
    Click {
      anchors.fill: parent
      onLeftClicked: {
        turnOffProc.running = true;
      }
    }
  }
}