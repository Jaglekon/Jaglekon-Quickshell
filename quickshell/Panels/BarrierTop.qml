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
  WlrLayershell.layer: WlrLayer.Background

  anchors {
    top: true
    right: true
    left: true
  }

  color: "transparent"

  implicitHeight: root.panelHeight - Theme.gapIn
}