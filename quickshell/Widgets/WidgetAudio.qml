import QtQuick
import Quickshell.Io
import "../Modules"
import "../Services"
import "../Themes"


ModuleWidget {
  id: moduleRoot
  spacing: 2

  property int maxVolume: 10
  property int volume: Math.round((Audio.sink?.audio?.volume ?? 0) * maxVolume)
  property bool clicked: false

  function volumeIcon() {
    if (Audio.sink?.audio?.muted) return "   ";
    if (volume === 0) return " ";
    else if (volume < maxVolume / 2) return "  ";
    else return "   ";
  }

  Item {
    implicitWidth: icon.implicitWidth
    implicitHeight: icon.implicitHeight
    anchors.verticalCenter: parent.verticalCenter

    ModuleText {
      id: icon
      label: clicked ? moduleRoot.volumeIcon() : moduleRoot.volumeIcon() + Math.round(Audio.sink.audio.volume * 100) + "%"
      hovered: moduleRoot.hovered
      color: Audio.sink?.audio?.muted ? Theme.red: (moduleRoot.hovered ? Theme.background_var : Theme.blue)
    }

    Process {
      id: pavucontrolProc
      command: ["pavucontrol"]
      running: false
    }

    Process {
      id: muteProc
      command: ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]
      running: false
    }
    Process {
      id: unmuteProc
      command: ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]
      running: false
    }

    Click {
      anchors.fill: parent
      onMiddleClicked: {
        moduleRoot.clicked = !moduleRoot.clicked;
      }
      onLeftClicked: {
        pavucontrolProc.running = true; 
      }
      onRightClicked: {
        muteProc.running = true;
      }
    }

  }

  Item {
    id: sliderArea
    visible: moduleRoot.clicked
    implicitWidth: volumeSlider.implicitWidth
    implicitHeight: volumeSlider.implicitHeight
    anchors.verticalCenter: parent.verticalCenter
    Behavior on width {
        NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
    }
    Row {
      id: volumeSlider
      spacing: Theme.fontPixelSize * 0.15
      Repeater {
        model: maxVolume
        Rectangle {
          width: Theme.fontPixelSize * 0.6
          height: Theme.fontPixelSize * 0.8
          radius: Theme.rounding * 0.5
          x: (width + moduleRoot.spacing) * index
          color: Audio.sink?.audio?.muted
          ? (index < moduleRoot.volume ? Theme.red : Theme.selection_background_var)
          : (moduleRoot.hovered
          ? (index < moduleRoot.volume ? Theme.background_var : Theme.selection_background_var)
          : (index < moduleRoot.volume ? Theme.blue : Theme.selection_background_var))
        }
      }
    }

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
      onReleased: {
        if (mouse.button === Qt.RightButton) {
          muteProc.running = true;
        }
      }
      onClicked: {
        if (mouse.button === Qt.MiddleButton) {
          moduleRoot.clicked = !moduleRoot.clicked;
        } else if (mouse.button === Qt.LeftButton) {
          setVolume(mouse.x);
        }
      }

      onPositionChanged: {
        if (mouse.buttons & Qt.LeftButton) {
          setVolume(mouse.x)
        }
      }

      function setVolume(mouseX) {
        var barWidth = 8 + moduleRoot.spacing;
        var idx = Math.floor(mouseX / barWidth);
        idx = Math.max(0, Math.min(idx, maxVolume));
        if (Audio.sink && Audio.sink.audio) {
          Audio.sink.audio.volume = (idx) / maxVolume;
        }
      }
    }
  }
}
