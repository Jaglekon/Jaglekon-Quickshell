import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
pragma Singleton
pragma ComponentBehavior: Bound

/**
 * A nice wrapper for default Pipewire audio sink and source.
 */
Singleton {
  id: root

  property bool ready: Pipewire.defaultAudioSink?.ready ?? false
  property PwNode sink: Pipewire.defaultAudioSink
  property PwNode source: Pipewire.defaultAudioSource
  property bool shouldShowOsd: false
  property int volume: Math.round((Audio.sink?.audio?.volume ?? 0) * maxVolume)
  property int maxVolume: 10

  signal sinkProtectionTriggered(string reason);

  PwObjectTracker {
      objects: [sink, source]
  }

	Connections {
		target: sink?.audio 

    function onMutedChanged() {
		  root.shouldShowOsd = true;
		  hideTimer.restart();
	  }

		function onVolumeChanged() {
			root.shouldShowOsd = true;
			hideTimer.restart();
		}
	}

	Timer {
		id: hideTimer
		interval: 1000
		onTriggered: root.shouldShowOsd = false
	}
  
  function volumeIcon() {
    if (sink?.audio?.muted) return "   ";
    if (volume === 0) return "   ";
    else if (volume < maxVolume / 2) return "   ";
    else return "   ";
  }

}
