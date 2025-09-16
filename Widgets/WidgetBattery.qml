import QtQuick
import "../Modules"
import "../Services"
import "../Themes"
import Quickshell.Services.UPower

ModuleWidget {
    id: moduleRoot
    visible: available !== false
    property bool available: UPower.displayDevice.isLaptopBattery
    property var chargeState: UPower.displayDevice.state
    property bool isCharging: chargeState == UPowerDeviceState.Charging
    property bool isPluggedIn: isCharging || chargeState == UPowerDeviceState.PendingCharge
    property real percentage: UPower.displayDevice.percentage

  function batteryIcon() {
    if (isCharging === true) return "󰂄 ";
    if (percentage <= 0.05) return "󰂎 ";
    else if (percentage <= 0.15) return "󰁺 ";
    else if (percentage <= 0.25) return "󰁻 ";
    else if (percentage <= 0.35) return "󰁼 ";
    else if (percentage <= 0.45) return "󰁽 ";
    else if (percentage <= 0.55) return "󰁾 ";
    else if (percentage <= 0.65) return "󰁿 ";
    else if (percentage <= 0.75) return "󰂀 ";
    else if (percentage <= 0.85) return "󰂁 ";
    else if (percentage <= 0.95) return "󰂂 ";
    else return  "󰁹 ";
  }

  function batteryRed() {

  }



  ModuleText {
    label: batteryIcon() + (moduleRoot.percentage.toFixed(2) * 100) + "%"
    color: (percentage <= 0.1) ? Theme.red: (moduleRoot.hovered ? Theme.background : Theme.blue)
    hovered: moduleRoot.hovered
  }
}