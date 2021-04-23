import QtQuick 2.12

Item {
    width: 360
    height: 200
    Rectangle {
        id: clock_Case
        width: 360
        height: 200
        color: "#ffffff"
        radius: 25

        Rectangle {
            id: display_Border
            width: 340
            height: 180
            color: "#f0f0f0"
            radius: 25
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            Rectangle {
                id: display
                width: 280
                height: 120
                color: "#dfdfdf"
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                Text {
                    id: time_View
                    width: 280
                    height: 83
                    text: qsTr("--:--")
                    anchors.top: parent.top
                    font.pixelSize: 100
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.topMargin: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    fontSizeMode: Text.FixedSize
                    font.weight: Font.Normal
                    font.family: "Digital-7"
                    renderType: Text.NativeRendering
                }

                Item {
                    id: secondary_Info
                    width: 280
                    height: 24
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottomMargin: 5

                    Item {
                        id: battery_Info
                        width: 63
                        height: 24
                        anchors.left: parent.left
                        anchors.leftMargin: 10

                        Image {
                            id: battery_Icon
                            width: 18
                            height: 18
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            source: "icons/battery.svg"
                            anchors.leftMargin: 0
                            fillMode: Image.PreserveAspectFit
                        }

                        Text {
                            id: battery_Level
                            height: 24
                            text: qsTr("--")
                            anchors.left: battery_Icon.right
                            font.pixelSize: 22
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            anchors.leftMargin: 2
                            font.family: "Digital-7"
                        }

                        Text {
                            id: battery_Sign
                            height: 24
                            text: qsTr("%")
                            anchors.left: battery_Level.right
                            font.pixelSize: 12
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            anchors.leftMargin: 2
                            font.strikeout: false
                            font.family: "Arial"
                        }
                    }

                    Item {
                        id: humidity_Info
                        width: 53
                        height: 24
                        anchors.horizontalCenter: parent.horizontalCenter

                        Image {
                            id: humidity_Icon
                            width: 18
                            height: 18
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            source: "icons/humidity.svg"
                            anchors.leftMargin: 0
                            fillMode: Image.PreserveAspectFit
                        }

                        Text {
                            id: humidity_Level
                            height: 24
                            text: "--"
                            anchors.left: humidity_Icon.right
                            font.pixelSize: 22
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignBottom
                            anchors.leftMargin: 2
                            font.family: "Digital-7"
                            font.strikeout: false
                        }

                        Text {
                            id: humidity_Sign
                            height: 24
                            text: qsTr("%")
                            anchors.left: humidity_Level.right
                            font.pixelSize: 12
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            anchors.leftMargin: 2
                            font.family: "Arial"
                            font.strikeout: false
                        }
                    }

                    Item {
                        id: temperature_Info
                        width: 75
                        height: 24
                        anchors.right: parent.right
                        anchors.rightMargin: 10

                        Image {
                            id: temp_Icon
                            width: 18
                            height: 18
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            source: "icons/thermometer.svg"
                            anchors.leftMargin: 0
                            fillMode: Image.PreserveAspectFit
                        }

                        Text {
                            id: temp_Level
                            height: 22
                            text: "--.-"
                            anchors.left: temp_Icon.right
                            font.pixelSize: 22
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignBottom
                            anchors.leftMargin: 2
                            font.strikeout: false
                            font.family: "Digital-7"
                        }

                        Text {
                            id: temp_Sign
                            height: 22
                            text: qsTr("°C")
                            anchors.left: temp_Level.right
                            font.pixelSize: 12
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            anchors.leftMargin: 2
                            font.family: "Arial"
                            font.strikeout: false
                        }
                    }
                }
            }
        }
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
