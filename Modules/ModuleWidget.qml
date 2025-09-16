import QtQuick
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
  default property alias content: contentRow.data

  Behavior on width {
        NumberAnimation { duration: 2000; easing.type: Easing.InOutQuad }
    }

  implicitWidth: box.implicitWidth
  implicitHeight: box.implicitHeight

  Rectangle {
    id: box
    color: hovered ? moduleRoot.hoverColor : moduleRoot.backgroundColor
    radius: Theme.rounding + 3
    border.width: Theme.borderSize
    border.color: moduleRoot.borderColor
    implicitWidth: contentRow.implicitWidth + 2 * paddingHorizontal
    implicitHeight: heightImplicit + 2 * paddingVertical

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