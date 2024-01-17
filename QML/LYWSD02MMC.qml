import QtQuick 2.15
import Qt5Compat.GraphicalEffects

Item {
    width: 360
    height: 200

    Rectangle {
        id: clock_Case
        width: 360
        height: 200
        color: "#ffffff"
        radius: 29
        visible: false

        Rectangle {
            id: display_Border
            width: 350
            height: 190
            color: "#f0f0f0"
            radius: 25
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            Rectangle {
                id: display
                width: 290
                height: 130
                color: "#dfdfdf"
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                Text {
                    id: time_View
                    height: 85
                    text: qsTr("--:--")
                    font.pixelSize: 100
                    font.family: FontsManager.clock_Font.name
                    renderType: Text.NativeRendering
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Item {
                    id: secondary_Info
                    width: 280
                    height: 24
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottomMargin: 5

                    Row {
                        id: battery_Info_Row
                        spacing: 3
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 10

                        Image {
                            id: battery_Icon
                            width: 18
                            height: 18
                            source: "qrc:/icons/battery.svg"
                            fillMode: Image.PreserveAspectFit
                            mipmap: true
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            id: battery_Level
                            text: "--"
                            font.pixelSize: 22
                            font.family: FontsManager.clock_Font.name
                            renderType: Text.NativeRendering
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            id: battery_Sign
                            text: "%"
                            font.pixelSize: 18
                            font.family: FontsManager.regular_Font.name
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    Row {
                        id: humidity_Info_Row
                        spacing: 3
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter

                        Image {
                            id: humidity_Icon
                            width: 18
                            height: 18
                            source: "qrc:/icons/humidity.svg"
                            fillMode: Image.PreserveAspectFit
                            mipmap: true
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            id: humidity_Level
                            text: "--"
                            font.pixelSize: 22
                            font.family: FontsManager.clock_Font.name
                            renderType: Text.NativeRendering
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignBottom
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            id: humidity_Sign
                            text: "%"
                            font.pixelSize: 18
                            font.family: FontsManager.regular_Font.name
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    Row {
                        id: temperature_Info_Row
                        spacing: 3
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: 10

                        Image {
                            id: temp_Icon
                            width: 18
                            height: 18
                            source: "qrc:/icons/thermometer.svg"
                            fillMode: Image.PreserveAspectFit
                            mipmap: true
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            id: temp_Level
                            text: "--.-"
                            font.pixelSize: 22
                            font.family: FontsManager.clock_Font.name
                            renderType: Text.NativeRendering
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignBottom
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            id: temp_Sign
                            text: "°C"
                            font.pixelSize: 18
                            font.family: FontsManager.regular_Font.name
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }
            }
        }
    }

    DropShadow {
        anchors.fill: clock_Case
        horizontalOffset: 3
        verticalOffset: 3
        radius: 6.0
        samples: 14
        color: "#20000000"
        source: clock_Case
    }

    Connections {
        target: CLOCK_INFO
        function onClimate_Changed() {
            temp_Level.text = CLOCK_INFO.get_Temperature.toFixed(1);
            humidity_Level.text = CLOCK_INFO.get_Humidity;
        }

        function onBattery_Level_Changed() {
            battery_Level.text = CLOCK_INFO.get_Battery_Level;
        }

        function onTemperature_Unit_Changed(unit) {
            if (unit === "celsius") {
                temp_Sign.text = "°C";
            }
            else if (unit === "fahrenheit") {
                temp_Sign.text = "°F";
            }
        }

        function onTime_Changed() {
            time_View.text = CLOCK_INFO.get_Time;
        }
    }

    Connections {
        target: BLE_BRIDGE
        function onDevice_Disconnected() {
            time_View.text = "--:--";
            temp_Level.text = "--.-";
            humidity_Level.text = "--";
            battery_Level.text = "--";
            temp_Sign.text = "°C";
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:1.75}
}
##^##*/
