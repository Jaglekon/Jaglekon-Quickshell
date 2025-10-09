pragma Singleton

        import QtQuick 2.0

        QtObject {
          property color background: "#1d100a"
          property color background_var: "#36261f"
          property color selection_background: "#ffdbcb"
          property color blue: "#ffb692"
          property color border: "#793000"
          property color red: "#93000a"
          property color purple: "#efbe79"
          property color purple_border: "#efbe79"

          property string wallpaper: "/home/jag/Pictures/wallpapers/wp15.png"
          property string logo: "/home/jag/.config/quickshell/main/Assets/logo.svg"
          property string logo_back: "/home/jag/.config/quickshell/main/Assets/logo_back.svg"


          property string fontFamily: "Source Sans Pro"
          property int fontPixelSize: 13
          property int fontWeight: Font.DemiBold

          property int gapOut: 15
          property int gapIn: 5
          property int rounding: 8
          property int borderSize: 2
          property real opacity: 0.8
        }