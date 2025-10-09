import Quickshell;
import QtQuick;
import Quickshell.Io;
import Quickshell.Hyprland;
import Quickshell.Wayland;
import QtMultimedia
import Qt.labs.folderlistmodel
import "../Widgets";
import "../Modules";
import "../Themes";
import "../Services";

PanelWindow {
  screen: modelData
  id: rightPanel
  visible: root.openRightPanel && root.openRightPanel.indexOf(typeof modelData !== 'undefined' ? modelData : 0) !== -1
  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.exclusionMode: ExclusionMode.Ignore

  property string name: "undefined"
  property string path: "file:///home/" + name + "/Pictures/wallpapers"

  color: "transparent"

  anchors.top: true
  margins.top: root.panelHeight + Theme.gapIn * 2
  
  implicitHeight: 9 * 90
  implicitWidth: 16 * 90

  Process {
        id: whoamiProc
        command: ["whoami"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                name = data.trim()
            }
        }
  }

  Rectangle {
    id: rect
    anchors.fill: parent
    color: Theme.background
    radius: Theme.rounding
    property real grid: 0.8

    GridView {
      id: grid
      anchors.verticalCenter: parent.verticalCenter
      anchors.horizontalCenter: parent.horizontalCenter
      cacheBuffer: 8

      width: parent.width - Theme.gapOut
      height: parent.height - Theme.gapOut
      cellWidth: (parent.width - Theme.gapOut) / 2
      cellHeight: (parent.height - Theme.gapOut) / 2

      FolderListModel {
        id: folderModel
        folder: path
        nameFilters: ["*.png", "*.jpg"]
      }

      delegate: Item {
        width: grid.cellWidth
        height: grid.cellHeight

        Rectangle {
          anchors.centerIn: parent
          height: pic.height * 1.1
          width: pic.width * 1.1
          color: Theme.background_var
          radius: Theme.rounding
        }

        Item {
          anchors.centerIn: parent
          height: grid.cellHeight * rect.grid
          width: grid.cellWidth * rect.grid
          Image {
            id: pic
            source: fileURL
            anchors.centerIn: parent
            height: parent.height
            width: parent.width
            fillMode: Image.PreserveAspectFit
            cache: true
            asynchronous: true
          }

          Process {
            id: matugen
            command: ["matugen","image","/home/" + rightPanel.name + "/Pictures/wallpapers/" + fileName]
            
            running: false
          }

          MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton
            preventStealing: false
            onClicked: {
              matugen.running = true;
            }
            cursorShape: Qt.PointingHandCursor
          }
        }


      }

      model: folderModel
    }
  }

  Rectangle {
    anchors.fill: parent
    color: "transparent"
    radius: Theme.rounding
    border.width: Theme.gapOut
    border.color: Theme.background
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