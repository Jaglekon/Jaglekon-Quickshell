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
  property var workspaceContainerId: null
  property int workspaceIndex: -1
  property string parentAnchorSide: parent && parent.anchorSide ? parent.anchorSide : "left"
  property bool isFirstWidget: widgetIndex === 0
  property bool isLastWidget: widgetIndex === totalWidgets - 1
  property real animatedWidth: contentRow.implicitWidth + 2 * paddingHorizontal

  property int topLeft: (((parentAnchorSide === "right" || parentAnchorSide === "bottom") && isLastWidget === true) || ((parentAnchorSide === "left" || parentAnchorSide === "top") && isFirstWidget === true)) ? Theme.rounding : Theme.rounding / 3
  property int topRight: (((parentAnchorSide === "left" || parentAnchorSide === "bottom") && isLastWidget === true) || ((parentAnchorSide === "right" || parentAnchorSide === "top") && isFirstWidget === true)) ? Theme.rounding : Theme.rounding / 3
  property int bottomLeft: (((parentAnchorSide === "right" || parentAnchorSide === "top") && isLastWidget === true) || ((parentAnchorSide === "left" || parentAnchorSide === "bottom") && isFirstWidget === true)) ? Theme.rounding : Theme.rounding / 3
  property int bottomRight: (((parentAnchorSide === "left" || parentAnchorSide === "top") && isLastWidget === true) || ((parentAnchorSide === "right" || parentAnchorSide === "bottom") && isFirstWidget === true)) ? Theme.rounding : Theme.rounding / 3

  default property alias content: contentRow.data

  implicitWidth: box.width
  implicitHeight: box.height

  Rectangle {
    id: box
    border.width: Theme.borderSize
    border.color: moduleRoot.borderColor
    color: hovered ? moduleRoot.hoverColor : moduleRoot.backgroundColor
    topLeftRadius: topLeft
    topRightRadius: topRight
    bottomLeftRadius: bottomLeft
    bottomRightRadius: bottomRight
    width: contentRow.implicitWidth + 2 * paddingHorizontal
    height: heightImplicit + 2 * paddingVertical
    clip: true  

    Behavior on width {
      NumberAnimation { 
        duration: 150
        easing.type: Easing.InOutQuad
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

  }
}