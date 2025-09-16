import QtQuick
import "../Modules"
import "../Themes"
import "../Services"

ModuleWidget {
  hoverColor: Theme.purple
  paddingHorizontal: 0
  id: moduleRoot

  Item {
    implicitWidth: root.widgetHeight
    implicitHeight: root.widgetHeight
    Image {
      id: nix
      height: root.widgetHeight * 0.6
      width: root.widgetHeight * 0.6
      source: hovered ? Qt.resolvedUrl(Theme.logo_back) : Qt.resolvedUrl(Theme.logo)
      anchors.verticalCenter: parent.verticalCenter
      anchors.horizontalCenter: parent.horizontalCenter
      fillMode: Image.PreserveAspectCrop
    }
    
    Click {
      anchors.fill: parent
      onLeftClicked: {
        var idx = typeof modelData !== 'undefined' ? modelData : 0;
        var arr = root.openPowerMenu ? root.openPowerMenu.slice() : [];
        var i = arr.indexOf(idx);
        if (i === -1) {
          arr.push(idx);
        } else {
          arr.splice(i, 1);
        }
        root.openPowerMenu = arr;
      }
    }
  }
}