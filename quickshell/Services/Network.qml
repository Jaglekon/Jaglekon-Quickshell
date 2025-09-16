pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import QtQuick

/**
 * Simple polled network state service.
 */
Singleton {
  id: root

  property bool wifi: false
  property bool ethernet: false
  property int updateInterval: 1000
  property string networkName: ""
  property int networkStrength
  property int rx_a: 0
  property int rx_b: 0
  property real rxDelta: 0
  property int tx_a: 0
  property int tx_b: 0
  property real txDelta: 0
  function update() {
      updateConnectionType.startCheck();
      updateNetworkName.running = true;
      updateNetworkStrength.running = true;
  }

  Timer {
      interval: 10
      running: true
      repeat: true
      onTriggered: {
          root.update();
          interval = root.updateInterval;
      }
  }

  Process {
      id: updateConnectionType
      property string buffer
      command: ["sh", "-c", "nmcli -t -f NAME,TYPE,DEVICE c show --active"]
      running: true
      function startCheck() {
          buffer = "";
          updateConnectionType.running = true;
      }
      stdout: SplitParser {
          onRead: data => {
              updateConnectionType.buffer += data + "\n";
          }
      }
      onExited: (exitCode, exitStatus) => {
          const lines = updateConnectionType.buffer.trim().split('\n');
          let hasEthernet = false;
          let hasWifi = false;
          lines.forEach(line => {
              if (line.includes("ethernet"))
                  hasEthernet = true;
              else if (line.includes("wireless"))
                  hasWifi = true;
          });
          root.ethernet = hasEthernet;
          root.wifi = hasWifi;
      }
  }

  Process {
      id: updateNetworkName
      command: ["sh", "-c", "nmcli -t -f NAME c show --active | head -1"]
      running: true
      stdout: SplitParser {
          onRead: data => {
              root.networkName = data;
          }
      }
  }

  Process {
      id: updateNetworkStrength
      running: true
      command: ["sh", "-c", "nmcli -f IN-USE,SIGNAL,SSID device wifi | awk '/^\*/{if (NR!=1) {print $2}}'"]
      stdout: SplitParser {
          onRead: data => {
              root.networkStrength = parseInt(data);
          }
      }
  }

  Timer {
      interval: 1000
      running: true
      repeat: true
      onTriggered: {
          updateNetworkBandwidth.running = true;
      }
  }

  Process {
    id: updateNetworkBandwidth
    command: ["sh", "-c", "for d in /sys/class/net/*; do dev=$(basename $d); [ \"$dev\" = \"lo\" ] && continue; rx=$(cat $d/statistics/rx_bytes 2>/dev/null); tx=$(cat $d/statistics/tx_bytes 2>/dev/null); [ -n \"$rx\" ] && [ -n \"$tx\" ] && echo $rx $tx; done | awk '{rx+=$1;tx+=$2} END{print rx,tx}'"]
    running: false
    stdout: SplitParser {
      onRead: data => {
        var parts = data.trim().split(/\s+/);
        if (parts.length >= 2) {
          root.rx_b = root.rx_a;
          root.rx_a = parseInt(parts[0]);
          root.rxDelta = (root.rx_a - root.rx_b) / 1024.0;
          root.tx_b = root.tx_a;
          root.tx_a = parseInt(parts[1]);
          root.txDelta = (root.tx_a - root.tx_b) / 1024.0;
        }
      }
    }
  }
}
