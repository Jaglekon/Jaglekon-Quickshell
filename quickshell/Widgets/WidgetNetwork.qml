import QtQuick
import Quickshell.Io
import "../Modules"
import "../Themes"
import "../Services"

ModuleWidget {
  id: moduleRoot
  spacing: 4

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
    implicitWidth: network.implicitWidth
    implicitHeight: network.implicitHeight


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

    Item {
      implicitHeight: network.height
      implicitWidth: network.width

      Row {
        id: network
        spacing: 8


        Item {
          id: vpnWidget
          implicitHeight: vpn.height
          implicitWidth: vpn.width
          property bool clicked: false

          Process {
            id: vpnStart
            command: ["systemctl", "start", "wg-quick-wg0.service"]
            running: false
          }

          Process {
            id: vpnStop
            command: ["systemctl", "stop", "wg-quick-wg0.service"]
            running: false
          }

          ModuleText {
            id: vpn
            label: vpnWidget.clicked
            ? (Network.vpn ? ("󰌾 VPN: " + (Network.vpnName && Network.vpnName.length > 0 ? Network.vpnName : "on")) : "󰌿 No VPN")
            : (Network.vpn ? "󰌾" : "󰌿")
            color: !(Network.vpn) ? Theme.red: (moduleRoot.hovered ? Theme.background_var : Theme.blue)
            hovered: moduleRoot.hovered
          }

          MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.MiddleButton | Qt.LeftButton | Qt.RightButton
            preventStealing: false
            
            cursorShape: Qt.PointingHandCursor
            onClicked: {
              if (mouse.button === Qt.LeftButton) ;
              else if (mouse.button === Qt.RightButton) Network.vpn ? vpnStop.running = true : vpnStart.running = true;
              else if (mouse.button === Qt.MiddleButton) vpnWidget.clicked = !vpnWidget.clicked;
            }
          }
        }

        Item {
          id: networkWidget
          implicitHeight: icon.height
          implicitWidth: icon.width
          property bool clicked: false

          ModuleText {
            id: icon
            label: networkWidget.clicked
            ? moduleRoot.networkIcon() + " " + (Network.rxDelta.toFixed(1) + " KB/s ↓  " + (Network.txDelta !== undefined ? Network.txDelta.toFixed(1) : "0.0") + " KB/s ↑")
            : moduleRoot.networkIcon()
            color: !(Network.wifi || Network.ethernet) ? Theme.red: (moduleRoot.hovered ? Theme.background_var : Theme.blue)
            hovered: moduleRoot.hovered
          }

          MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.MiddleButton | Qt.LeftButton | Qt.RightButton
            preventStealing: false
            
            cursorShape: Qt.PointingHandCursor
            onClicked: {
              if (mouse.button === Qt.LeftButton) nmProc.running = true;
              else if (mouse.button === Qt.RightButton) !Network.ethernet && !Network.wifi ? netOnProc.running = true : netOffProc.running = true
              else if (mouse.button === Qt.MiddleButton) networkWidget.clicked = !networkWidget.clicked;
            }
          }
        }
      }
    }
  }
}
