pragma Singleton

import Quickshell
import QtQuick

Singleton {
  
  property SystemClock clock: clock

  SystemClock {
    id: clock 
    precision: SystemClock.Seconds
  }

}

