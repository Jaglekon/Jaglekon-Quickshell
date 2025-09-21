import QtQuick
import QtQuick.Effects;
import "../Themes"

Item {
  id: moduleRoot
  signal clicked
  signal rightClicked
  property bool hovered: false
  property int spacing: 6
  property int paddingHorizontal: 8
  property int paddingVertical: 11
  property color hoverColor: Theme.blue
  property color backgroundColor: "transparent"
  property color borderColor: "transparent"
  property int heightImplicit: Theme.fontPixelSize
  property int widgetIndex: -1
  property int totalWidgets: 1 
  property var workspaceContainerId: null  // Reference to WidgetWorkspaces component if this is a dynamic widget
  property int workspaceIndex: -1  // Index within the WidgetWorkspaces component
  property string parentAnchorSide: parent && parent.anchorSide ? parent.anchorSide : "left"
  property bool isFirstWidget: widgetIndex === 0
  property bool isLastWidget: widgetIndex === totalWidgets - 1
  property real animatedWidth: contentRow.implicitWidth + 2 * paddingHorizontal

  // Calculate radius for each corner - compacted version
  function getCornerRadius(corner) {
    const sides = {
      "topLeft": parentAnchorSide === "right" ? isLastWidget : isFirstWidget,
      "topRight": parentAnchorSide === "right" ? isFirstWidget : (parentAnchorSide === "left" ? isLastWidget : isFirstWidget), 
      "bottomLeft": parentAnchorSide === "right" ? isLastWidget : (parentAnchorSide === "bottom" ? isFirstWidget : (parentAnchorSide === "top" ? isLastWidget : isFirstWidget)),
      "bottomRight": parentAnchorSide === "right" ? isFirstWidget : (parentAnchorSide === "left" ? isLastWidget : (parentAnchorSide === "top" ? isLastWidget : isFirstWidget))
    }
    return sides[corner] ? Theme.rounding : 2
  }

  default property alias content: contentRow.data

  implicitWidth: box.width
  implicitHeight: box.height

  Rectangle {
    id: box
    color: "transparent"
    radius: Theme.rounding + 3
    width: contentRow.implicitWidth + 2 * paddingHorizontal
    height: heightImplicit + 2 * paddingVertical
    clip: true  
    z: parent.z

    Behavior on width {
      NumberAnimation { 
        duration: 150
        easing.type: Easing.InOutQuad
      }
    }

    // Corner rectangles with preserved masking - compacted
    Repeater {
      model: [
        { corner: "topLeft", maskId: topLeftMask },
        { corner: "topRight", maskId: topRightMask },
        { corner: "bottomLeft", maskId: bottomLeftMask },
        { corner: "bottomRight", maskId: bottomRightMask }
      ]
      
      Rectangle {
        anchors.fill: parent
        border.width: Theme.borderSize
        border.color: moduleRoot.borderColor
        color: hovered ? moduleRoot.hoverColor : moduleRoot.backgroundColor
        radius: getCornerRadius(modelData.corner)
        layer.enabled: true
        layer.effect: MultiEffect {
          maskEnabled: true
          maskSource: modelData.maskId
        }
      }
    }

    Item {
      id: topLeftMask
      anchors.fill: parent
      layer.enabled: true
      visible: false
      Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        width: parent.width / 2
        height: parent.height / 2
        color: "white"
      }
    }
    
    Item {
      id: topRightMask
      anchors.fill: parent
      layer.enabled: true
      visible: false
      Rectangle {
        anchors.right: parent.right
        anchors.top: parent.top
        width: parent.width / 2
        height: parent.height / 2
        color: "white"
      }    
    }

    Item {
      id: bottomLeftMask
      anchors.fill: parent
      layer.enabled: true
      visible: false
      Rectangle {
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width: parent.width / 2
        height: parent.height / 2
        color: "white"
      }
    }
    
    Item {
      id: bottomRightMask
      anchors.fill: parent
      layer.enabled: true
      visible: false
      Rectangle {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        width: parent.width / 2
        height: parent.height / 2
        color: "white"
      }    
    }

    Row {
      id: contentRow
      anchors.centerIn: parent
      spacing: moduleRoot.spacing
    }
    
  }

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    onEntered: hovered = true
    onExited: hovered = false
    acceptedButtons: Qt.NoButton
    cursorShape: undefined
    z: 10  // Above all the rectangles
  }
  }