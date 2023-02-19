import QtQuick
import QtQuick.Controls
import "QML/"

ApplicationWindow {
    id: window
    width: 410
    height: 400
    visible: true
    title: "LYWSD02MMC"
    onClosing: {
        BLE_BRIDGE.disconnect_Device();
    }

    Rectangle {
        id: background
        color: "#ffffff"
        anchors.fill: parent
        focus: true
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
    }

    LYWSD02MMC {
        id: lYWSD02MMC
        width: 360
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Clock_Control {
        id: clock_Control
        anchors.top: lYWSD02MMC.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 20
    }

    Connection_Info {
        id: connection_Info
        anchors.top: clock_Control.bottom
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Devices_List {
        id: devices_List
    }

    Connecting_To_Device {
        id: connecting_To_Device
    }

    Writing_Service {
        id: writing_Service
    }

    Time_Picker {
        id: time_Picker
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:1.33}
}
##^##*/
