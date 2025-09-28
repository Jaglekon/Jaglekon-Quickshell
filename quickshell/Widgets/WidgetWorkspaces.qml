import QtQuick
import Quickshell
import Quickshell.Hyprland
import QtQuick
import "../Services"
import "../Modules"
import "../Themes"

  Repeater {
    model: Hyprland.workspaces.values
    ModuleWidget {
      id: moduleWidget
      property var ws: modelData
      property var wsIcons: WorkspaceIcons.iconsForWorkspace(ws)
      borderColor: ws.id === Hyprland.focusedWorkspace.id ? Theme.purple : "transparent"
      hoverColor: ws.id === Hyprland.focusedWorkspace.id ? Theme.purple : Theme.blue
      paddingHorizontal: 0

      content: [
        Item {
          id: workspaceButton
          implicitWidth: workspaceText.implicitWidth + 12
          implicitHeight: workspaceText.implicitHeight
          ModuleText {
            id: workspaceText
            anchors.centerIn: parent
            label: wsIcons.hasWindows ? ws.id.toString() + " " + wsIcons.icons.join(' ') : ws.id.toString()
            hovered: moduleWidget.hovered
            color: hovered ? Theme.background : (ws.id === Hyprland.focusedWorkspace.id ? Theme.purple : Theme.blue)
          }
          Click {
            anchors.fill: parent
            onLeftClicked: Hyprland.dispatch(`workspace ${ws.id}`)
          }
        }
      ]
    }
  }