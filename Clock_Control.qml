import QtQuick 2.0
import QtQuick.Controls 2.15

Item {
    width: 360
    height: 70

    property bool device_Connected: false

    Rectangle {
        id: rectangle
        x: 0
        y: 0
        width: 360
        height: 70
        color: "white"
        radius: 5

        Button {
            id: sync_Clock
            width: 80
            height: 40
            visible: false
            enabled: false
            text: qsTr("Sync Clock")
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: set_Clock.right
            anchors.leftMargin: 10
            font.pointSize: 10
            font.family: "Bahnschrift"

            onClicked: {
                var date_Object = new Date();
                var unix_TimeStamp = Math.round(date_Object.getTime() / 1000);
                var timeZone = date_Object.getTimezoneOffset() / -60;

                console.log(timeZone)

                var hex_Timezone = 0x00;

                if (timeZone >= 0) {
                    hex_Timezone = timeZone.toString(16);
                }
                else {
                    hex_Timezone = 265 + timeZone;
                }

                console.log(hex_Timezone)

                BLE_BRIDGE.set_New_Time(unix_TimeStamp, hex_Timezone);
            }
        }

        Button {
            id: set_Clock
            width: 80
            height: 40
            enabled: device_Connected
            text: qsTr("Set Clock")
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10
            font.pointSize: 10
            font.family: "Bahnschrift"

            onClicked: {
                time_Picker.show_Dialog();
            }
        }

        Switch {
            id: temperature_Switch
            width: 130
            height: 40
            enabled: device_Connected
            text: qsTr("°C / °F")
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            font.pointSize: 14
            font.family: "Bahnschrift"
            anchors.rightMargin: 10

            onToggled: {
                if (temperature_Switch.checked) {
                    BLE_BRIDGE.change_Temperature_Unit("fahrenheit")
                } else {
                    BLE_BRIDGE.change_Temperature_Unit("celsius")
                }
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
