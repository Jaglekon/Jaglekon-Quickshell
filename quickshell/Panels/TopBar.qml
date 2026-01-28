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
  WlrLayershell.layer: WlrLayer.Bottom
  WlrLayershell.exclusionMode: ExclusionMode.Ignore

  anchors {
    top: true
    right: true
    left: true
  }

  color: "transparent"

  implicitHeight: Math.max(moduleLeft1.height, moduleRight1.height, moduleMiddle1.height) + Theme.fontPixelSize
  onImplicitHeightChanged: {
    if (root) {
      root.widgetHeight = implicitHeight - Theme.fontPixelSize;
      root.panelHeight = implicitHeight;
    }
  }

  ModuleBar {
    id: moduleLeft1
    anchorSide: "left"
    anchors.left: parent.left
    anchors.leftMargin: Theme.fontPixelSize
    
    WidgetNix {}
  }

  ModuleBar {
    id: moduleLeft2
    anchorSide: "left"
    anchors.left: moduleLeft1.right
    anchors.leftMargin: Theme.fontPixelSize

    WidgetWorkspaces {}
  }

  ModuleBar {
    id: moduleMiddle1
    anchorSide: "left"
    anchors.horizontalCenter: parent.horizontalCenter

    WidgetMusic {}
  }

  ModuleBar {
    id: moduleRight1
    anchorSide: "right"
    anchors.right: parent.right
    anchors.rightMargin: Theme.fontPixelSize

    WidgetTray2 {}
    WidgetClock {}
    WidgetNetwork {}
    WidgetBluetooth {}
    WidgetAudio {}
    WidgetBattery {}

  }

}