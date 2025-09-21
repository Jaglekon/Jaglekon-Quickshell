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
  property int updateGeneration: 0  // Track update cycles to prevent race conditions
  
  // Debounce timer to prevent multiple rapid updates
  Timer {
    id: debounceTimer
    interval: 100 // Increased to 100ms for better debouncing
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
    // Stop any existing timer and restart it
    debounceTimer.stop()
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
  }
  
  function doUpdateWorkspaces() {
    if (isUpdating) {
      return
    }
    
    // Increment generation to invalidate any pending updates
    updateGeneration++
    let currentGeneration = updateGeneration
    
    isUpdating = true
    
    // Calculate our base index position among static widgets
    calculateBaseIndex()
    
    // Get current workspaces
    let workspaces = Hyprland.workspaces.values
    
    // Clean up existing widgets immediately
    for (let i = 0; i < createdWidgets.length; i++) {
      if (createdWidgets[i]) {
        createdWidgets[i].destroy()
      }
    }
    createdWidgets = []
    
    // Force immediate update of parent to clear old widgets from layout
    if (parent && parent.updateWidgetIndices) {
      parent.updateWidgetIndices()
    }
    
    // Create new ModuleWidget for each workspace
    for (let i = 0; i < workspaces.length; i++) {
      // Check if this update cycle is still valid
      if (currentGeneration !== updateGeneration) {
        isUpdating = false
        return // Abort if a newer update has started
      }
      
      let workspace = workspaces[i]
      let widget = workspaceWidgetComponent.createObject(parent, {
        "ws": workspace
      })
      if (widget) {
        // Mark this widget as belonging to this WidgetWorkspaces component
        widget.workspaceContainerId = workspacesContainer
        widget.workspaceIndex = i  // Index within this WidgetWorkspaces
        createdWidgets.push(widget)
      }
    }
    
    isUpdating = false
    
    // Final layout update
    if (parent && parent.updateWidgetIndices && currentGeneration === updateGeneration) {
      parent.updateWidgetIndices()
    }
  }
  
  Connections {
    target: Hyprland.workspaces
    function onChanged() {
      updateWorkspaces()
    }
  }
  
  Connections {
    target: Hyprland
    function onFocusedWorkspaceChanged() {
      updateWorkspaces()
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
