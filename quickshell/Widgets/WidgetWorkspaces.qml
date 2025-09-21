import QtQuick
import "../Services"
import Quickshell
import Quickshell.Hyprland
import QtQuick
import "../Modules"
import "../Themes"

Item {
  id: workspacesContainer
  
  property var createdWidgets: []
  property bool isUpdating: false
  property int baseWidgetIndex: -1  // Position where this WidgetWorkspaces sits among static widgets
  
  // Debounce timer to prevent multiple rapid updates
  Timer {
    id: debounceTimer
    interval: 50 // Wait 50ms before actually updating
    running: false
    repeat: false
    onTriggered: {
      if (!isUpdating) {
        doUpdateWorkspaces()
      }
    }
  }
  
  Component {
    id: workspaceWidgetComponent
    ModuleWidget {
      id: workspaceWidget
      property var ws: null
      property var wsIcons: ws ? WorkspaceIcons.iconsForWorkspace(ws) : null
      
      hoverColor: ws && ws.id === (Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id : -1) ? Theme.purple : Theme.blue
      borderColor: ws && (ws.id === (Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id : -1))
        ? (hovered ? Theme.purple : Theme.purple_border)
        : "transparent"

      content: [
        Item {
          implicitWidth: iconRow.implicitWidth
          implicitHeight: iconRow.implicitHeight
          Row {
            id: iconRow
            anchors.centerIn: parent
            spacing: 3

            ModuleText {
              anchors.verticalCenter: parent.verticalCenter
              label: ws ? ws.id.toString() : ""
              color: workspaceWidget.hovered ? (Theme.background_var) : (ws && ws.id === Hyprland.focusedWorkspace.id ? Theme.purple : Theme.blue)
              hovered: workspaceWidget.hovered
            }

            Repeater {
              model: wsIcons ? wsIcons.icons : []
              ModuleText {
                anchors.verticalCenter: parent.verticalCenter
                label: modelData
                hovered: workspaceWidget.hovered
                color: hovered ? (Theme.background_var) : (ws && ws.id === Hyprland.focusedWorkspace.id ? Theme.purple : Theme.blue)
                font.pixelSize: (modelData === "󰑋") ? Theme.fontPixelSize * 1.3 : Theme.fontPixelSize
              }
            }
          }
          Click {
            anchors.fill: parent
            onLeftClicked: if (ws) Hyprland.dispatch(`workspace ${ws.id}`)
          }
        }
      ]
    }
  }
  
  function updateWorkspaces() {
    debounceTimer.restart()
  }
  
  function calculateBaseIndex() {
    if (!parent) {
      baseWidgetIndex = 0
      return
    }
    
    // Find our position among the parent's children
    let ourIndex = -1
    for (let i = 0; i < parent.children.length; i++) {
      if (parent.children[i] === workspacesContainer) {
        ourIndex = i
        break
      }
    }
    
    if (ourIndex === -1) {
      baseWidgetIndex = 0
      return
    }
    
    // Count static widgets (non-dynamic widgets) that come before us
    let staticWidgetsBefore = 0
    for (let i = 0; i < ourIndex; i++) {
      let child = parent.children[i]
      // Count only static widgets that have widgetIndex property but aren't our dynamic widgets
      if (child && typeof child.widgetIndex !== 'undefined' && 
          createdWidgets.indexOf(child) === -1) {
        staticWidgetsBefore++
      }
    }
    
    baseWidgetIndex = staticWidgetsBefore
    console.log("WidgetWorkspaces baseWidgetIndex calculated as:", baseWidgetIndex)
  }
  
  function doUpdateWorkspaces() {
    if (isUpdating) {
      return
    }
    
    isUpdating = true
    
    // Calculate our base index position among static widgets
    calculateBaseIndex()
    
    // Get current workspaces
    let workspaces = Hyprland.workspaces.values
    
    // Clean up existing widgets
    for (let i = 0; i < createdWidgets.length; i++) {
      if (createdWidgets[i]) {
        createdWidgets[i].destroy()
      }
    }
    createdWidgets = []
    
    // Create new ModuleWidget for each workspace
    for (let i = 0; i < workspaces.length; i++) {
      let workspace = workspaces[i]
      let widget = workspaceWidgetComponent.createObject(parent, {
        "ws": workspace
      })
      if (widget) {
        // Mark this widget as belonging to this WidgetWorkspaces component
        widget.workspaceContainerId = workspacesContainer
        widget.workspaceIndex = i  // Index within this WidgetWorkspaces
        createdWidgets.push(widget)
        console.log("Created workspace widget", i, "with workspaceContainerId:", workspacesContainer)
      }
    }
    
    // Force the parent ModuleBar to update indices for all widgets
    if (parent && parent.updateWidgetIndices) {
      Qt.callLater(parent.updateWidgetIndices)
    }
    
    isUpdating = false
  }
  
  Connections {
    target: Hyprland.workspaces
    function onChanged() {
      Qt.callLater(updateWorkspaces)
    }
  }
  
  Connections {
    target: Hyprland
    function onFocusedWorkspaceChanged() {
      Qt.callLater(updateWorkspaces)
    }
  }
  
  Component.onCompleted: {
    updateWorkspaces()
  }
  
  Component.onDestruction: {
    // Clean up when destroyed
    for (let i = 0; i < createdWidgets.length; i++) {
      if (createdWidgets[i]) {
        createdWidgets[i].destroy()
      }
    }
  }
}
