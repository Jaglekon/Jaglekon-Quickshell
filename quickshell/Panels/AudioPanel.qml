import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import QtQuick.Effects;
import "../Services"
import "../Modules"
import "../Themes"

LazyLoader {
  active: Audio.shouldShowOsd

  PanelWindow {
    id: panel

    anchors.bottom: true
    anchors.left: true
    margins.left: Theme.gapOut
    margins.bottom: (screen.height / 2) - (height / 2)
    exclusiveZone: 0

    implicitWidth: background.width
    implicitHeight: background.height
    color: "transparent"

    mask: Region {}


    Rectangle {
      id: background
      anchors.fill: parent
      opacity: Theme.opacity
      height: content.height + Theme.fontPixelSize
      width: content.width + Theme.fontPixelSize
      radius: Theme.rounding * 1.5
      color: Theme.background

      Column {
        id: content
        anchors {
          centerIn: parent
        }


        spacing: Theme.fontPixelSize * 0.5

        Rectangle {
          anchors.horizontalCenter: parent.horizontalCenter
          height: text.height + Theme.fontPixelSize * 0.5
          width: Math.max(volumeSlider.width, text.width) + Theme.fontPixelSize * 0.5
          color: Theme.background_var
          radius: Theme.rounding

          ModuleText {
            id:text
            anchors.centerIn: parent
            label: Audio.volumeIcon()
            color: Audio.sink?.audio?.muted ? Theme.red : Theme.blue
          }
        }

        Rectangle {
          height: volumeSlider.height + Theme.fontPixelSize 
          width: Math.max(volumeSlider.width, text.width) + Theme.fontPixelSize * 0.5
          color: Theme.background_var
          radius: Theme.rounding
          anchors.horizontalCenter: parent.horizontalCenter
        
          Column {
            id: volumeSlider
            spacing: Theme.fontPixelSize * 0.15
            anchors.centerIn: parent
            Repeater {
              model: Audio.maxVolume
              Rectangle {
                width: Theme.fontPixelSize * 1
                height: Theme.fontPixelSize * 0.8
                radius: Theme.rounding * 0.5
                color: Audio.sink?.audio?.muted
                ? (Audio.maxVolume - (index + 1) < Audio.volume ? Theme.red : Theme.background)
                : (Audio.maxVolume - (index + 1) < Audio.volume ? Theme.blue : Theme.background)
              }
            }
          }
        }
      }
    }
  }
}
