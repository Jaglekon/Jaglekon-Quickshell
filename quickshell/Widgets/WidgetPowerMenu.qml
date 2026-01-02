import QtQuick
import Quickshell.Io
import "../Modules"
import "../Services"

Column {
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
}
