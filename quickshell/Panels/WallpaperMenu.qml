import Quickshell;
import Quickshell.Widgets
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
  id: rightPanel
  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.exclusionMode: ExclusionMode.Ignore

  property bool visbileMenu: false

  property string path: "file:///home/" + Theme.user + "/Pictures/wallpapers"

  color: "transparent"

  anchors.top: true
  margins.top: root.panelHeight + Theme.gapIn * 2
  
  implicitHeight: 9 * 90
  implicitWidth: 16 * 90


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
      reuseItems: true

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

    
        ClippingRectangle {
          id: picRect
          anchors.centerIn: parent
          height: pic.height
          width: pic.width
          radius: Theme.rounding

          Image {
            id: pic
            source: fileUrl
            anchors.centerIn: parent
            height: grid.cellHeight * rect.grid
            fillMode: Image.PreserveAspectFit
            cache: true
            asynchronous: true
          }
        } 
             
       
        Process {
          id: matugen
          command: ["matugen","image","/home/" + Theme.user + "/Pictures/wallpapers/" + fileName]
          
          running: false
        }

        MouseArea {
          anchors.fill: picRect
          acceptedButtons: Qt.LeftButton
          preventStealing: false
          onClicked: {
            matugen.running = true;
          }
          cursorShape: Qt.PointingHandCursor
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

  
}