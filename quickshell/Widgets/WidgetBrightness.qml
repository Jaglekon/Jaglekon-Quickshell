import QtQuick
import "../Modules"
import "../Services"

ModuleWidget {
    id: moduleRoot
    Item {
      anchors.verticalCenter: parent.verticalCenter
      implicitHeight: time.implicitHeight
      implicitWidth: time.implicitWidth

      ModuleText {
        id: time
        label: Brightness.backlightExists ? "There is a backlight" : "There is no backlight"  
        hovered: moduleRoot.hovered
      }
    }
}