import QtQuick
import Quickshell.Io
import "../Modules"
import "../Themes"
import "../Services"

Column {
  id: wlanWidget
  spacing: 4
  property int wlanItemWidth: 150
  property var networks: []
  property bool loading: false

  function scanNetworks() {
    loading = true;
    scanProc.running = true;
  }

  Timer {
    interval: 10000
    running: true
    repeat: true
    onTriggered: wlanWidget.scanNetworks()
  }

  Process {
    id: scanProc
    command: ["sh", "-c", "nmcli -t -f SSID,SIGNAL dev wifi list | grep -v '^--' | sort -u"]
    running: false
    property string buffer: ""
    stdout: SplitParser {
      onRead: data => {
        scanProc.buffer += data + "\n";
      }
    }
    onExited: {
      var lines = scanProc.buffer.trim().split('\n');
      var result = [];
      lines.forEach(function(line) {
        var parts = line.split(":");
        if (parts.length >= 2 && parts[0].length > 0) {
          result.push({ ssid: parts[0], signal: parseInt(parts[1]) });
        }
      });
      wlanWidget.networks = result;
      loading = false;
      scanProc.buffer = "";
    }
  }

  Component.onCompleted: scanNetworks()

  
  Repeater {
    model: networks
    ModuleWidget {
      id: moduleRoot
      hoverColor: modelData.ssid === Network.networkName ? Theme.purple : Theme.blue
      ModuleText {
        width: wlanWidget.wlanItemWidth
        elide: Text.ElideRight
        label: modelData.ssid + "  (" + modelData.signal + "% )"
        horizontalAlignment: Text.AlignLeft
        hovered: moduleRoot.hovered
        color: hovered ? Theme.background : (modelData.ssid === Network.networkName ? Theme.purple : Theme.blue)
      }
    }
  }
  Loader {
    active: loading
    sourceComponent: loaderIndicator
    width: wlanWidget.wlanItemWidth
  }
  ModuleWidget {
    visible: !loading && networks.length === 0
    width: wlanWidget.wlanItemWidth
    ModuleText {
      width: wlanWidget.wlanItemWidth - 16
      elide: Text.ElideRight
      label: "No networks found"
      color: Theme.red
      horizontalAlignment: Text.AlignLeft
    }
  }
}
