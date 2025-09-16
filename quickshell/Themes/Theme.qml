pragma Singleton

        import QtQuick 2.0

        QtObject {
          property color background: "#10131c"
          property color background_var: "#181b25"
          property color selection_background: "#c4c6d3"
          property color blue: "#b0c6ff"
          property color border: "#00429b"
          property color red: "#ffb4ab"
          property color purple: "#cebef7"
          property color purple_border: "#cebef7"

          property string wallpaper: "/home/jag/Pictures/wallpapers/wp1.png"
          property string logo: "/home/jag/.config/quickshell/test/Assets/logo.svg"
          
          property string fontFamily: "Source Sans Pro"
          property int fontPixelSize: 13
          property int fontWeight: Font.DemiBold

          property int gapOut: 15
          property int gapIn: 5
          property int rounding: 8
          property int borderSize: 2
        }