import QtQuick
import Quickshell.Io
import "../Modules"
import "../Services"
import "../Themes"

ModuleWidget {
  id: moduleRoot
  property bool clicked: false

  Item {
    implicitWidth: icon.implicitWidth
    implicitHeight: icon.implicitHeight

    Process {
      id: bluemanProc
      command: ["blueman-manager"]
      running: false
    }
    Process {
      id: btOnProc
      command: ["rfkill", "unblock", "bluetooth"]
      running: false
    }
    Process {
      id: btOffProc
      command: ["rfkill", "block", "bluetooth"]
      running: false
    }

    Click {
      anchors.fill: parent
      onMiddleClicked: {
        moduleRoot.clicked = !moduleRoot.clicked;
      }
      onLeftClicked: {
        bluemanProc.running = true;
      }
      onRightClicked: {
        if (!Bluetooth.bluetoothEnabled) {
          btOnProc.running = true;
        } else {
        btOffProc.running = true;
        }
      }
    }

    ModuleText {
      id: icon
      label: clicked
      ? (Bluetooth.bluetoothEnabled
      ? (Bluetooth.bluetoothConnected
      ? "󰂱 " + Bluetooth.bluetoothDeviceName
      : "󰂳  No Device")
      : "󰂲 ")
      : (Bluetooth.bluetoothEnabled
      ? (Bluetooth.bluetoothConnected
      ? "󰂱 "
      : "󰂳 ")
      : "󰂲 ")
      color: !Bluetooth.bluetoothEnabled ? Theme.red: (moduleRoot.hovered ? Theme.background : Theme.blue)
      hovered: moduleRoot.hovered
    }
  }
}