import Quickshell;
import QtQuick;
import Quickshell.Hyprland;
import Quickshell.Wayland;
import QtQuick.Effects;
import "../Widgets";
import "../Modules";
import "../Themes";
import "../Services";

PanelWindow {
  id: powerMenu
  screen: modelData
  visible: root.openPowerMenu && root.openPowerMenu.indexOf(typeof modelData !== 'undefined' ? modelData : 0) !== -1
  WlrLayershell.layer: WlrLayer.Background
  WlrLayershell.exclusionMode: ExclusionMode.Ignore

  anchors {
    top: true
    left: true
    bottom: true
    right: true
  }

  color: "transparent"
  implicitWidth: visible ? (moduleLeft1.width + Theme.fontPixelSize * 2) : 0
  implicitHeight: visible ? (moduleLeft1.height + Theme.fontPixelSize * 1.5) : 0
  onImplicitHeightChanged: {
    if (root) {
        root.powerHeight = implicitHeight;
    }
  }
  onImplicitWidthChanged: {
    if (root) {
        root.powerWidth = implicitWidth;
    }
  }

  Rectangle {
    anchors.top: parent.top
    anchors.left: parent.left
    width: root.powerWidth * 0.5
    height: root.powerHeight + root.panelHeight
    color: Theme.background
    Behavior on width {
      NumberAnimation { 
        duration: 150
        easing.type: Easing.InOutQuad
      }
    }
  }

  Rectangle {
    id: mainBackground
    anchors.top: parent.top
    anchors.left: parent.left
    width: root.powerWidth
    height: root.powerHeight + root.panelHeight
    color: Theme.background
    radius: Theme.rounding * 1.5
    Behavior on width {
      NumberAnimation { 
        duration: 150
        easing.type: Easing.InOutQuad
      }
    }
    
    
    ModuleBar {
      id: moduleLeft1
      anchorSide: "top"
      autoCenter: false
      anchors.top: parent.top
      anchors.topMargin: root.panelHeight + Theme.gapIn
      anchors.left: parent.left
      anchors.leftMargin: Theme.fontPixelSize

      WidgetPowerOff {}
      WidgetReboot {}
      WidgetLogOut {}
      WidgetLock {}
    }
  }

  Rectangle {
    id: topRounding
    width: root.powerWidth
    height: root.powerWidth
    anchors.top: parent.top
    anchors.topMargin: root.panelHeight
    anchors.left: mainBackground.right
    clip: true
    visible: false
    color: Theme.background
    Behavior on width {
      NumberAnimation { 
        duration: 150
        easing.type: Easing.InOutQuad
      }
    }
  }

  Rectangle {
    id: bottomRounding
    width: root.powerWidth
    height: root.powerWidth
    anchors.top: mainBackground.bottom
    anchors.leftMargin: Theme.gapIn
    anchors.left: parent.left
    clip: true
    visible: false
    color: Theme.background
    Behavior on width {
      NumberAnimation { 
        duration: 150
        easing.type: Easing.InOutQuad
      }
    }
  }

  MultiEffect {
    source: topRounding
    anchors.fill: topRounding
    maskEnabled: true
    maskSource: topLeftRoundingMask
    maskInverted: true
  }
  
  MultiEffect {
    source: bottomRounding
    anchors.fill: bottomRounding
    maskEnabled: true
    maskSource: topLeftRoundingMask
    maskInverted: true
  }

  Item {
    id: topLeftRoundingMask
    width: root.powerWidth
    height: root.powerWidth
    layer.enabled: true
    visible: false
    Rectangle {
      color: "black"
      anchors.fill: parent
      radius: Theme.rounding * 1.5
      antialiasing: false
    }
    Rectangle {
      color: "black"
      anchors.right: parent.right
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      width: parent.width / 2
      antialiasing: false
    }
    Rectangle {
      color: "black"
      anchors.left: parent.left
      anchors.bottom: parent.bottom
      anchors.right: parent.right
      height: parent.height / 2
      antialiasing: false
    }
      
  }


  GlobalShortcut {
    name: "powerMenuToggle"
    onPressed: {
      var monitor = Hyprland.monitorFor(screen);
      var isFocused = Hyprland.focusedMonitor && monitor && (Hyprland.focusedMonitor.name === monitor.name);
      if (!isFocused) return;
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