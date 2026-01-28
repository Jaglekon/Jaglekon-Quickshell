import QtQuick
import Qt5Compat.GraphicalEffects
import Quickshell.Io
import Quickshell.Services.SystemTray
import "../Modules"
import "../Themes"
import "../Services"
import "../Tray"

ModuleWidget {
  id: moduleRoot

  property int amountItems: SystemTray.items.values.length
  property var trayItems: SystemTray.items.values
  
  paddingHorizontal: anyTrayVisible ? 10 : 0
  
  Repeater {
    model: amountItems

    Rectangle {
      id: rect
      height: root.widgetHeight * 0.5
      width: root.widgetHeight * 0.5

      color: "transparent"

      Image {
        anchors.fill: parent
        source: Qt.resolvedUrl(trayItems[index].icon)
        fillMode: Image.PreserveAspectCrop

        ColorOverlay {
          anchors.fill: parent
          source: parent
          color: moduleRoot.hovered ? Theme.background : Theme.blue
          opacity: 0.75
        }
      }
      MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        cursorShape: Qt.PointingHandCursor
        
        onClicked: {
          if (mouse.button === Qt.LeftButton) {
            trayItems[index].activate();
          } else if (mouse.button === Qt.RightButton) {
            trayItems[index].display(topBar, topBar.width - (amountItems - index) * rect.width, Math.round(root.widgetHeight));
          }else if (mouse.button === Qt.MiddleButton) {
            trayItems[index].secondaryActivate();
          }
        }
      }
    }
  }
}