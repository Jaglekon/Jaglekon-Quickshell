import QtQuick

MouseArea {
  id: clickable
  anchors.fill: parent
  hoverEnabled: true
  acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
  preventStealing: true


  signal leftClicked
  signal rightClicked
  signal middleClicked
  signal scrolled(var wheel)

  onClicked: function(mouse) {
    if (mouse.button === Qt.LeftButton) clickable.leftClicked()
    else if (mouse.button === Qt.RightButton) clickable.rightClicked()
    else if (mouse.button === Qt.MiddleButton) clickable.middleClicked()
  }

  onWheel: function(wheel) {
    clickable.scrolled(wheel)
  }
  cursorShape: Qt.PointingHandCursor
}