import Quickshell;
import QtQuick;
import Quickshell.Hyprland;
import Quickshell.Wayland
import "../Widgets";
import "../Modules";
import "../Themes";
import "../Services";

PanelWindow {
  screen: modelData
  visible: root.openPowerMenu && root.openPowerMenu.indexOf(typeof modelData !== 'undefined' ? modelData : 0) !== -1
  WlrLayershell.layer: WlrLayer.Background

  anchors {
    top: true
    left: true
    bottom: true
  }

  color: "transparent"

  implicitWidth: root.powerWidth - Theme.gapIn
}