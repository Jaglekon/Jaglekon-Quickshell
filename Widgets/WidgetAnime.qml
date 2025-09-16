import QtQuick
import Quickshell.Io
import QtMultimedia
import Quickshell.Services.Mpris
import "../Modules"
import "../Tray"
import "../Themes"
import "../Services"

ModuleWidget {
  id: moduleRoot
  spacing: 8
  heightImplicit: 1080 / 5

  Video {
    id: videoPlayer
    source: Qt.resolvedUrl("../Assets/HaibaneRenmei.mp4")
    autoPlay: false
    loops: MediaPlayer.Infinite
    fillMode: VideoOutput.PreserveAspectFit
    width: 1920 / 5

    function updatePlayback() {
      if (root.openRightPanel && root.openRightPanel.length > 0) {
        videoPlayer.play();
      } else {
        videoPlayer.pause();
      }
    }

    Component.onCompleted: updatePlayback()
    onVisibleChanged: updatePlayback()

    Connections {
      target: root
      onOpenRightPanelChanged: videoPlayer.updatePlayback()
    }
  }
}