import QtQuick
import "../Services"
import Quickshell
import Quickshell.Hyprland
import QtQuick
import "../Modules"
import "../Themes"

Row {
  id: row
  spacing: 0
  anchors.verticalCenter: parent.verticalCenter
  Repeater {
    model: Hyprland.workspaces.values
    ModuleWidget {
      id: moduleWidget
      property var ws: modelData
      property var wsIcons: WorkspaceIcons.iconsForWorkspace(ws)
      //backgroundColor: ws.id === (Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id : -1) ? Theme.blue : "transparent"
      hoverColor: ws.id === (Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id : -1) ? Theme.purple : Theme.blue
      borderColor: (ws.id === (Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id : -1))
        ? (hovered ? Theme.purple : Theme.purple_border)
        : "transparent"

      content: [
        Item {
          id: workspaceButton
          implicitWidth: iconRow.implicitWidth
          implicitHeight: iconRow.implicitHeight
          Row {
            id: iconRow
            anchors.centerIn: parent
            spacing: 3

            ModuleText {
              anchors.verticalCenter: parent.verticalCenter
              id: workspaceNumber
              label: ws.id.toString()
              color: hovered ? (Theme.background_var) : (ws.id === Hyprland.focusedWorkspace.id ? Theme.purple : Theme.blue)
              hovered: moduleWidget.hovered
            }

            Repeater {
              //model: wsIcons.hasWindows ? wsIcons.icons : [ws.id.toString()]
              model: wsIcons.icons
              ModuleText {
                anchors.verticalCenter: parent.verticalCenter
                id: workspaceText
                label: modelData
                hovered: moduleWidget.hovered
                color: hovered ? (Theme.background_var) : (ws.id === Hyprland.focusedWorkspace.id ? Theme.purple : Theme.blue)
                font.pixelSize: (modelData === "󰑋") ? Theme.fontPixelSize * 1.3 : Theme.fontPixelSize
              }
            }
          }
          Click {
            anchors.fill: parent
            onLeftClicked: Hyprland.dispatch(`workspace ${ws.id}`)
          }
        }
      ]
    }
  }
}
