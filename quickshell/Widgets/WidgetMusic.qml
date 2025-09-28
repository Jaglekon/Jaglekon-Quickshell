import QtQuick
import Quickshell.Io
import Quickshell.Services.Mpris
import "../Modules"
import "../Tray"
import "../Themes"
import "../Services"

ModuleWidget {
  id: moduleRoot
  property int maxTitleLength: 60
  property list<real> visualizerPoints: []
  property bool clicked: false
  property real gifSpeed: 0
  spacing: 8

  Process {
    id: cavaProc
    running: true
    command: ["cava"]
    stdout: SplitParser {
      onRead: data => {
        let points = data.split(";").map(p => parseFloat(p.trim())).filter(p => !isNaN(p));
        moduleRoot.visualizerPoints = points;
        let avg = points.reduce((a, b) => a + b, 0) / points.length;
        let speed = (avg - 0) * (2.5 - 0) / (15 - 0) + 0;
        moduleRoot.gifSpeed = Math.max(0, Math.min(2.5, speed));
      }
    }
  }

  Mpris {anchors.verticalCenter: parent.verticalCenter}

  Item {
    id: cava
    implicitWidth: moduleRoot.clicked ? cavaRow.width : cavaRow.width + spin.width + 4
    implicitHeight: root.widgetHeight
    anchors.verticalCenter: parent.verticalCenter
    AnimatedImage {
      id: spin
      visible: !moduleRoot.clicked
      anchors.right: cavaRow.left
      anchors.rightMargin: 4
      source: Qt.resolvedUrl("../Assets/spin.gif")
      width: root.widgetHeight * 0.95
      height: root.widgetHeight * 0.95
      anchors.bottom: parent.bottom
      fillMode: Image.PreserveAspectFit
      speed: moduleRoot.gifSpeed
    }

    Row {
      anchors.verticalCenter: parent.verticalCenter
      id: cavaRow
      anchors.right: parent.right
      spacing: 2
      Repeater {
        model: visualizerPoints.length > 0 ? visualizerPoints.length : 16
        Rectangle {
          anchors.verticalCenter: parent.verticalCenter
          width: Theme.borderSize
          height: visualizerPoints[index] !== undefined ? Math.max(Math.round((visualizerPoints[index] / 16) * Theme.fontPixelSize * 1.5), Theme.borderSize) : Theme.borderSize
          radius: Theme.rounding
          color: hovered ? Theme.background_var : Theme.blue
          Behavior on height { NumberAnimation { duration: 120 } }
        }
      }
    }
    Click {
      anchors.fill: parent
      onMiddleClicked: {
        moduleRoot.clicked = !moduleRoot.clicked;
      }
    }
  }
}