import QtQuick
import "../Themes"

Rectangle {
    id: bar
    default property alias content: bar.data
    property string anchorSide: "left" // "left", "right", "top", "bottom"
    property bool autoCenter: true // Disable to manually position the bar
    anchors.verticalCenter: autoCenter && (anchorSide === "left" || anchorSide === "right") ? parent.verticalCenter : undefined
    anchors.horizontalCenter: autoCenter && (anchorSide === "top" || anchorSide === "bottom") ? parent.horizontalCenter : undefined
    color: Theme.background_var
    radius: Theme.rounding

    height: getVisibleChildrenHeight()
    width: getVisibleChildrenWidth()

    function getVisibleChildrenHeight() {
        if (anchorSide === "top" || anchorSide === "bottom") {
            // Vertical layout: sum all heights
            let totalHeight = 0
            for (let i = 0; i < children.length; i++) {
                let child = children[i]
                if (child && child.visible && typeof child.widgetIndex !== 'undefined') {
                    totalHeight += child.implicitHeight
                }
            }
            return totalHeight
        } else {
            // Horizontal layout: max height
            let maxHeight = 0
            for (let i = 0; i < children.length; i++) {
                let child = children[i]
                if (child && child.visible && typeof child.widgetIndex !== 'undefined') {
                    maxHeight = Math.max(maxHeight, child.implicitHeight)
                }
            }
            return maxHeight
        }
    }
    
    function getVisibleChildrenWidth() {
        if (anchorSide === "top" || anchorSide === "bottom") {
            // Vertical layout: max width
            let maxWidth = 0
            for (let i = 0; i < children.length; i++) {
                let child = children[i]
                if (child && child.visible && typeof child.widgetIndex !== 'undefined') {
                    maxWidth = Math.max(maxWidth, child.implicitWidth)
                }
            }
            return maxWidth
        } else {
            // Horizontal layout: sum all widths
            let totalWidth = 0
            for (let i = 0; i < children.length; i++) {
                let child = children[i]
                if (child && child.visible && typeof child.widgetIndex !== 'undefined') {
                    totalWidth += child.implicitWidth
                }
            }
            return totalWidth
        }
    }

    function updateWidgetIndices() {
        let allChildren = []
        
        // Collect all children and their original positions
        for (let i = 0; i < children.length; i++) {
            let child = children[i]
            if (child && typeof child.widgetIndex !== 'undefined' && child.visible) {
                allChildren.push({
                    widget: child,
                    originalIndex: i,
                    isWorkspace: child.workspaceContainerId !== null,
                    workspaceIndex: child.workspaceIndex || 0,
                    containerId: child.workspaceContainerId
                })
            }
        }
        
        // Sort to group workspace widgets by their container and maintain original order
        allChildren.sort(function(a, b) {
            // If both are from the same workspace container, sort by workspaceIndex
            if (a.isWorkspace && b.isWorkspace && a.containerId === b.containerId) {
                return a.workspaceIndex - b.workspaceIndex
            }
            
            // If one is workspace and one isn't, but they have the same originalIndex,
            // this means the workspace widgets should be grouped together at that position
            if (a.isWorkspace && !b.isWorkspace) {
                // Find the original index of the WidgetWorkspaces component
                let workspaceComponentIndex = -1
                for (let i = 0; i < children.length; i++) {
                    if (children[i] === a.containerId) {
                        workspaceComponentIndex = i
                        break
                    }
                }
                if (workspaceComponentIndex < b.originalIndex) {
                    return -1  // Workspace group comes before this static widget
                } else {
                    return 1   // Workspace group comes after this static widget
                }
            }
            
            if (!a.isWorkspace && b.isWorkspace) {
                // Find the original index of the WidgetWorkspaces component
                let workspaceComponentIndex = -1
                for (let i = 0; i < children.length; i++) {
                    if (children[i] === b.containerId) {
                        workspaceComponentIndex = i
                        break
                    }
                }
                if (a.originalIndex < workspaceComponentIndex) {
                    return -1  // Static widget comes before workspace group
                } else {
                    return 1   // Static widget comes after workspace group
                }
            }
            
            // Both are static widgets, sort by original index
            return a.originalIndex - b.originalIndex
        })
        
        // Assign sequential indices
        let widgets = []
        for (let i = 0; i < allChildren.length; i++) {
            let widget = allChildren[i].widget
            widget.widgetIndex = i
            widget.totalWidgets = allChildren.length
            widgets.push(widget)
        }
        
        if (anchorSide === "right") {
            // Right-to-left horizontal anchoring
            for (let i = 0; i < widgets.length; i++) {
                let widget = widgets[i]
                
                if (i === 0) {
                    widget.anchors.right = bar.right
                    widget.anchors.left = undefined
                    widget.anchors.top = undefined
                    widget.anchors.bottom = undefined
                    widget.anchors.verticalCenter = bar.verticalCenter
                    widget.anchors.horizontalCenter = undefined
                } else {
                    let prevWidget = widgets[i - 1]
                    widget.anchors.right = Qt.binding(function() { return prevWidget.left })
                    widget.anchors.left = undefined
                    widget.anchors.top = undefined
                    widget.anchors.bottom = undefined
                    widget.anchors.verticalCenter = bar.verticalCenter
                    widget.anchors.horizontalCenter = undefined
                }
            }
        } else if (anchorSide === "top") {
            // Top-to-bottom vertical anchoring
            for (let i = 0; i < widgets.length; i++) {
                let widget = widgets[i]
                
                if (i === 0) {
                    widget.anchors.top = bar.top
                    widget.anchors.bottom = undefined
                    widget.anchors.left = undefined
                    widget.anchors.right = undefined
                    widget.anchors.horizontalCenter = bar.horizontalCenter
                    widget.anchors.verticalCenter = undefined
                } else {
                    let prevWidget = widgets[i - 1]
                    widget.anchors.top = Qt.binding(function() { return prevWidget.bottom })
                    widget.anchors.bottom = undefined
                    widget.anchors.left = undefined
                    widget.anchors.right = undefined
                    widget.anchors.horizontalCenter = bar.horizontalCenter
                    widget.anchors.verticalCenter = undefined
                }
            }
        } else if (anchorSide === "bottom") {
            // Bottom-to-top vertical anchoring
            for (let i = 0; i < widgets.length; i++) {
                let widget = widgets[i]
                
                if (i === 0) {
                    widget.anchors.bottom = bar.bottom
                    widget.anchors.top = undefined
                    widget.anchors.left = undefined
                    widget.anchors.right = undefined
                    widget.anchors.horizontalCenter = bar.horizontalCenter
                    widget.anchors.verticalCenter = undefined
                } else {
                    let prevWidget = widgets[i - 1]
                    widget.anchors.bottom = Qt.binding(function() { return prevWidget.top })
                    widget.anchors.top = undefined
                    widget.anchors.left = undefined
                    widget.anchors.right = undefined
                    widget.anchors.horizontalCenter = bar.horizontalCenter
                    widget.anchors.verticalCenter = undefined
                }
            }
        } else {
            // Left-to-right horizontal anchoring (default)
            for (let i = 0; i < widgets.length; i++) {
                let widget = widgets[i]
                
                if (i === 0) {
                    widget.anchors.left = bar.left
                    widget.anchors.right = undefined
                    widget.anchors.top = undefined
                    widget.anchors.bottom = undefined
                    widget.anchors.verticalCenter = bar.verticalCenter
                    widget.anchors.horizontalCenter = undefined
                } else {
                    let prevWidget = widgets[i - 1]
                    widget.anchors.left = Qt.binding(function() { return prevWidget.right })
                    widget.anchors.right = undefined
                    widget.anchors.top = undefined
                    widget.anchors.bottom = undefined
                    widget.anchors.verticalCenter = bar.verticalCenter
                    widget.anchors.horizontalCenter = undefined
                }
            }
        }
        
        for (let i = 0; i < children.length; i++) {
            let child = children[i]
            if (child && typeof child.widgetIndex !== 'undefined' && !child.visible) {
                child.widgetIndex = -1
                child.anchors.left = undefined
                child.anchors.right = undefined
            }
        }
        
        heightChanged()
        widthChanged()
    }

    onChildrenChanged: updateWidgetIndices()
    Component.onCompleted: updateWidgetIndices()
    
    Connections {
        target: bar
        function onChildrenChanged() {
            for (let i = 0; i < bar.children.length; i++) {
                let child = bar.children[i]
                if (child && typeof child.widgetIndex !== 'undefined') {
                    child.visibleChanged.connect(function() {
                        bar.updateWidgetIndices()
                    })
                }
            }
        }
    }
}