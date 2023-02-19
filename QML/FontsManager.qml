pragma Singleton
import QtQuick

Item {
    //REGULAR FONT
    readonly property var regular_Font: FontLoader {
        source: "qrc:/fonts/Roboto-Regular.ttf"
    }

    //CLOCK FONT
    readonly property var clock_Font: FontLoader {
        source: "qrc:/fonts/Digital-7.ttf"
    }
}
