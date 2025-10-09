import Quickshell.Widgets
import Quickshell;
import QtQuick;
import Quickshell.Wayland;
import QtQuick.Effects;
import QtQuick.Layouts
import "../Themes";

PanelWindow {
  id: powerMenu
  screen: modelData
  WlrLayershell.layer: WlrLayer.Background
  WlrLayershell.exclusionMode: ExclusionMode.Ignore
  
  anchors {
    top: true
    left: true
    right: true
    bottom: true
  }

  Rectangle {
    anchors.fill: parent
    color: Theme.background
  }

  

  ClippingWrapperRectangle {
    id: wallpaper2
    anchors.fill: parent
    anchors.topMargin: root.panelHeight
    anchors.leftMargin: Theme.gapIn
    anchors.rightMargin: Theme.gapIn
    anchors.bottomMargin: Theme.gapIn
    radius: Theme.rounding * 1.5
    Image {
      anchors.fill: parent
      source: Qt.resolvedUrl(Theme.wallpaper)
      fillMode: Image.PreserveAspectCrop
    }
  }
}
