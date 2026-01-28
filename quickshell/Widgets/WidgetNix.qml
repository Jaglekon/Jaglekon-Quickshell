import QtQuick
import Quickshell.Hyprland
import Qt5Compat.GraphicalEffects
import "../Modules"
import "../Themes"
import "../Services"
import "../Assets/Logo.js" as Logo

ModuleWidget {
  hoverColor: Theme.purple
  paddingHorizontal: 0
  id: moduleRoot
  property var currentWorkspace: Hyprland.focusedWorkspace.id
  property int angle: currentWorkspace * 30

  Item {
    implicitWidth: root.widgetHeight
    implicitHeight: root.widgetHeight
    Image {
      id: nix
      height: root.widgetHeight * 0.6
      width: root.widgetHeight * 0.6

      property color fg: hovered ? Theme.background_var : Theme.purple

      source: "data:image/svg+xml;utf8," +
            encodeURIComponent(Logo.logo(fg))
      anchors.verticalCenter: parent.verticalCenter
      anchors.horizontalCenter: parent.horizontalCenter
      fillMode: Image.PreserveAspectCrop
      transform: Rotation { 
        origin.x: nix.width * 0.5
        origin.y: nix.width * 0.5
        angle: moduleRoot.angle
        Behavior on angle { NumberAnimation { duration: 500 } }  
      }
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