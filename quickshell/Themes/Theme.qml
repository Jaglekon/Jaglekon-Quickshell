pragma Singleton

        import QtQuick 2.0

        QtObject {
          property color background: "#11131c"
          property color background_var: "#282934"
          property color selection_background: "#c6c5d3"
          property color blue: "#bac3ff"
          property color border: "#0030c7"
          property color red: "#ffb4ab"
          property color purple: "#d7bcf3"
          property color purple_border: "#d7bcf3"

          property string wallpaper: "/home/jag/Pictures/wallpapers/wp5.jpg"
          property string logo: "/home/jag/.config/quickshell/test/quickshell/Assets/logo.svg"
          property string logo_back: "/home/jag/.config/quickshell/test/quickshell/Assets/logo_back.svg"


          property string fontFamily: "Source Sans Pro"
          property int fontPixelSize: 13
          property int fontWeight: Font.DemiBold

          property int gapOut: 15
          property int gapIn: 5
          property int rounding: 8
          property int borderSize: 2
        }