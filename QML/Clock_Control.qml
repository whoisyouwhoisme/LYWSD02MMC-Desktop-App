import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import "Components/"

Item {
    width: 360
    height: 60

    property bool device_Connected: false

    Rectangle {
        id: control_Background
        width: 360
        height: 60
        color: "white"
        radius: 5
        visible: false
    }

    DropShadow {
        anchors.fill: control_Background
        horizontalOffset: 3
        verticalOffset: 3
        radius: 6.0
        samples: 14
        color: "#20000000"
        source: control_Background
    }

    Regular_Button {
        id: set_Clock
        width: 80
        height: 40
        button_Text: "Set Clock"
        button_Enabled: device_Connected
        font_Size: 14
        font_Name: FontsManager.regular_Font.name
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10

        onButton_Pressed: {
            time_Picker.show_Dialog();
        }
    }

    Regular_Button {
        id: sync_Clock
        width: 80
        height: 40
        button_Text: "Sync Clock"
        button_Enabled: device_Connected
        font_Size: 14
        font_Name: FontsManager.regular_Font.name
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: set_Clock.right
        anchors.leftMargin: 10

        onButton_Pressed: {
            let date_Object = new Date();
            let timeStamp = Math.round(date_Object.getTime() / 1000);
            let timeZone = date_Object.getTimezoneOffset() * -60;
            let shifted_TimeStamp = timeStamp + timeZone

            BLE_BRIDGE.set_New_Time(shifted_TimeStamp, 0);
        }
    }


    Switch {
        id: temperature_Switch
        width: 130
        height: 40
        enabled: device_Connected
        text: qsTr("°C / °F")
        font.pixelSize: 14
        font.family: FontsManager.regular_Font.name
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 10

        onToggled: {
            if (temperature_Switch.checked) {
                BLE_BRIDGE.change_Temperature_Unit("fahrenheit")
            } else {
                BLE_BRIDGE.change_Temperature_Unit("celsius")
            }
        }
    }

    Connections {
        target: BLE_BRIDGE

        function onConnection_Completed() {
            device_Connected = true;
        }

        function onDevice_Disconnected() {
            device_Connected = false;
            temperature_Switch.checked = false;
        }
    }

    Connections {
        target: CLOCK_INFO

        function onTemperature_Unit_Changed(unit) {
            if (unit === "celsius") {
                temperature_Switch.checked = false;
            }
            else if (unit === "fahrenheit") {
                temperature_Switch.checked = true;
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:1.75}
}
##^##*/
