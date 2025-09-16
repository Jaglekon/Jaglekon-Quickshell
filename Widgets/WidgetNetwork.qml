import QtQuick
import Quickshell.Io
import "../Modules"
import "../Themes"
import "../Services"

ModuleWidget {
  id: moduleRoot
  spacing: 4
  property bool clicked: false

  function networkIcon()
  {
    if (Network.ethernet)
      return "󰌗 ";
    if (Network.wifi)
    {
      if (Network.networkStrength > 80) return "󰤨 ";
      if (Network.networkStrength > 60) return "󰤥 ";
      if (Network.networkStrength > 40) return "󰤢 ";
      if (Network.networkStrength > 20) return "󰤟 ";
      return "󰤯 ";
    }
    return " ";
  }

  Item {
    implicitWidth: icon.implicitWidth
    implicitHeight: icon.implicitHeight


    Process {
      id: nmProc
      command: ["nm-connection-editor"]
      running: false
    }
    Process {
      id: netOnProc
      command: ["nmcli", "networking", "on"]
      running: false
    }

    Process {
      id: netOffProc
      command: ["nmcli", "networking", "off"]
      running: false
    }

    Click {
      anchors.fill: parent
      onMiddleClicked: {
        moduleRoot.clicked = !moduleRoot.clicked;
      }
      onLeftClicked: {
        nmProc.running = true;
      }
      onRightClicked: {
        if (!Network.ethernet && !Network.wifi) {
          netOnProc.running = true;
        } else {
          netOffProc.running = true;
        }
      }
    }

    ModuleText {
      id: icon
      label: clicked
      ? moduleRoot.networkIcon() + "  " + (Network.rxDelta.toFixed(1) + " KB/s ↓  " + (Network.txDelta !== undefined ? Network.txDelta.toFixed(1) : "0.0") + " KB/s ↑")
      : moduleRoot.networkIcon()
      color: !(Network.wifi || Network.ethernet) ? Theme.red: (moduleRoot.hovered ? Theme.background : Theme.blue)
      hovered: moduleRoot.hovered
    }
  }
}
