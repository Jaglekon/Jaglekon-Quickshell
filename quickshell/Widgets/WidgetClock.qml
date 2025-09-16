import QtQuick
import "../Modules"
import "../Services"

ModuleWidget {
    id: moduleRoot
    property bool clicked: false
    Item {
      anchors.verticalCenter: parent.verticalCenter
      implicitHeight: time.implicitHeight
      implicitWidth: time.implicitWidth

      ModuleText {
        id: time
        label: moduleRoot.clicked ? Qt.formatDateTime(Clock.clock.date, "  ddd dd MMM hh:mm:ss") : Qt.formatDateTime(Clock.clock.date, "󰥔  hh:mm")
        hovered: moduleRoot.hovered
      }

      Click {
        anchors.fill: parent
        onMiddleClicked: {
          moduleRoot.clicked = !moduleRoot.clicked;
        }
      }
    }
}