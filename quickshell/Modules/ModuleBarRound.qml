import QtQuick
import QtQuick.Effects
import "../Themes"

Item {
  id: root
  property alias radius: maskRect.radius
  default property alias content: moduleBar.content
  
  anchors.verticalCenter: parent.verticalCenter

  width: moduleBar.width
  height: moduleBar.height
  
  ModuleBar {
    id: moduleBar
    layer.enabled: true
    layer.effect: MultiEffect {
      maskEnabled: true
      maskSource: maskItem
    }
  }

  Item {
    id: maskItem
    width: moduleBar.width
    height: moduleBar.height
    layer.enabled: true
    visible: false
    
    Rectangle {
      id: maskRect
      height: moduleBar.height
      width: moduleBar.width
      antialiasing: true
      radius: Theme.rounding
    }
  }
}