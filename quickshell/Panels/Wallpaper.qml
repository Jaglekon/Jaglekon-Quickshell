import Quickshell;
import QtQuick;
import Quickshell.Wayland;
import QtQuick.Effects;
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

  Rectangle {
        id: wallpaper
        anchors.fill: parent
        anchors.topMargin: root.panelHeight
        anchors.leftMargin: Theme.gapIn
        anchors.rightMargin: Theme.gapIn
        anchors.bottomMargin: Theme.gapIn
        clip: true
        visible: false
        Image {
          anchors.fill: parent
          source: Qt.resolvedUrl(Theme.wallpaper)
          fillMode: Image.PreserveAspectCrop
        }
    }

    MultiEffect {
        source: wallpaper
        anchors.fill: wallpaper
        maskEnabled: true
        maskSource: wallpaperMask
    }

    Item {
        id: wallpaperMask
        anchors.fill: parent
        anchors.topMargin: root.panelHeight
        anchors.leftMargin: Theme.gapIn
        anchors.rightMargin: Theme.gapIn
        anchors.bottomMargin: Theme.gapIn
        layer.enabled: true
        visible: false
        Rectangle {
            id: rect
            anchors.fill: parent
            antialiasing: false
            radius: Theme.rounding * 1.5
        }
    }
    


    Rectangle {
        id: barWithBackground
        width: 120; height: 80; x: 100; y: 50;
        clip: true
        visible: false
        color: "black"
        Rectangle {
            id: bar
            color: "orange"
            width: 60; height: 80; radius: 80
            NumberAnimation on x {
                running: true
                from: -(bar.width * 1.2 )
                to: barWithBackground.width * 1.2
                loops: Animation.Infinite
                duration: 1000
            }
        }
    }

}
