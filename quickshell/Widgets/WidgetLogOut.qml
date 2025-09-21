import QtQuick
import Quickshell.Io
import "../Modules"
import "../Services"

ModuleWidget {
  id: logOut
  Item {
    implicitHeight: root.widgetHeight
    implicitWidth: logText.height
    ModuleText {
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.verticalCenter: parent.verticalCenter
      id: logText
      label: "󰗽 "
      hovered: logOut.hovered
    }
    Process {
      id: logOutProc
      command: ["hyprctl", "dispatch", "exit"]
      running: false
    }
    Click {
      anchors.fill: parent
      onLeftClicked: {
        logOutProc.running = true;
      }
    }
  }
}