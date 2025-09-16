import Quickshell;
import QtQuick;
import Quickshell.Hyprland;
import Quickshell.Wayland;
import QtMultimedia
import "../Widgets";
import "../Modules";
import "../Themes";
import "../Services";

PanelWindow {
  screen: modelData
  id: rightPanel
  visible: root.openRightPanel && root.openRightPanel.indexOf(typeof modelData !== 'undefined' ? modelData : 0) !== -1
  WlrLayershell.layer: WlrLayer.Top
  WlrLayershell.exclusionMode: ExclusionMode.Ignore

  anchors {
    top: true
    right: true
  }

  margins {
    left: Theme.gapIn
    right: Theme.gapOut
    top: root.panelHeight
    bottom: Theme.gapOut
  }


  color: "transparent"

  implicitWidth: moduleLeft1.width
  implicitHeight: moduleLeft1.height

  ModuleColumn {
    id: moduleLeft1
    anchors.top: parent.top
    
    WidgetAnime {}
  }
  
  GlobalShortcut {
    name: "sidebarRightToggle"
    onPressed: {
      var monitor = Hyprland.monitorFor(screen);
      var isFocused = Hyprland.focusedMonitor && monitor && (Hyprland.focusedMonitor.name === monitor.name);
      if (!isFocused) return;
      var idx = typeof modelData !== 'undefined' ? modelData : 0;
      var arr = root.openRightPanel ? root.openRightPanel.slice() : [];
      var i = arr.indexOf(idx);
      if (i === -1) {
        arr.push(idx);
      } else {
        arr.splice(i, 1);
      }
      root.openRightPanel = arr;
    }
  }
}