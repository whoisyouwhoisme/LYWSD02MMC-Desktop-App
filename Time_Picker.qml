<<<<<<< Updated upstream:Time_Picker.qml
import QtQuick 2.0
import QtQuick.Controls 2.15
=======
import QtQuick
import QtQuick.Controls
import "Components/"
>>>>>>> Stashed changes:QML/Time_Picker.qml

Item {
    id: root

    signal back

    visible: false
    anchors.fill: parent

    Dialogs_Background {
        id: dialog_Background
    }

    Rectangle {
        id: dialog_Body
        width: 210
        height: 205
        color: "#f5f5f5"
        radius: 5
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Text {
            id: set_Label
            height: 15
            color: "#000000"
            text: "Set Custom Time"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            font.pixelSize: 14
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.family: "Bahnschrift"
            anchors.rightMargin: 15
            anchors.leftMargin: 15
            anchors.topMargin: 5
        }

        Rectangle {
            id: tumblers_Background
            height: 150
            color: "#ffffff"
            radius: 5
            border.width: 0
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: set_Label.bottom
            anchors.topMargin: 5
            anchors.rightMargin: 15
            anchors.leftMargin: 15

            Text {
                id: hours_Label
                width: 80
                height: 15
                color: "#000000"
                text: qsTr("Hours")
                anchors.left: parent.left
                anchors.top: parent.top
                font.pixelSize: 14
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.family: "Bahnschrift"
                anchors.leftMargin: 8
                anchors.topMargin: 5
                minimumPixelSize: 12
            }

            Text {
                id: minutes_Label
                width: 80
                height: 15
                color: "#000000"
                text: qsTr("Minutes")
                anchors.right: parent.right
                anchors.top: parent.top
                font.pixelSize: 14
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.family: "Bahnschrift"
                anchors.rightMargin: 8
                anchors.topMargin: 5
                minimumPixelSize: 12
            }

            Component {
                id: tumblers_Delegate

                Label {
                    text: format_Number(modelData)
                    opacity: 1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Tumbler {
                id: hours_Tumbler
                width: 80
                anchors.left: parent.left
                anchors.top: hours_Label.bottom
                anchors.bottom: parent.bottom
                font.pointSize: 10
                font.family: "Bahnschrift"
                anchors.bottomMargin: 5
                anchors.leftMargin: 8
                anchors.topMargin: 5
                model: 24
                delegate: tumblers_Delegate
            }

            Tumbler {
                id: minutes_Tumbler
                width: 80
                anchors.right: parent.right
                anchors.top: minutes_Label.bottom
                anchors.bottom: parent.bottom
                anchors.rightMargin: 8
                font.pointSize: 10
                font.family: "Bahnschrift"
                anchors.bottomMargin: 5
                anchors.topMargin: 5
                model: 60
                delegate: tumblers_Delegate
            }
        }

        Button {
            id: set_Time_Button
            width: 80
            text: qsTr("Set Time")
            anchors.right: parent.right
            anchors.top: tumblers_Background.bottom
            anchors.bottom: parent.bottom
            font.pointSize: 10
            font.family: "Bahnschrift"
            anchors.bottomMargin: 5
            anchors.topMargin: 5
            anchors.rightMargin: 15

            onClicked: {
                let year_Timestamp = (new Date().getFullYear() - 1970) * 31536000;
                let hours_Seconds = hours_Tumbler.currentIndex * 3600;
                let minutes_Seconds = (minutes_Tumbler.currentIndex * 60) + 1;
                let current_Timestamp = year_Timestamp + hours_Seconds + minutes_Seconds;

                hide_Dialog();
                BLE_BRIDGE.set_New_Time(current_Timestamp, 0);
            }
        }

        Button {
            id: close_Button
            width: 80
            text: qsTr("Cancel")
            anchors.left: parent.left
            anchors.top: tumblers_Background.bottom
            anchors.bottom: parent.bottom
            font.pointSize: 10
            font.family: "Bahnschrift"
            anchors.leftMargin: 15
            anchors.bottomMargin: 5
            anchors.topMargin: 5

            onClicked: {
                hide_Dialog();
            }
        }
    }

    Connections {
        target: CLOCK_INFO

        function onTime_Changed() {
            if (!root.visible) {
                update_Tumblers()
            }
        }
    }

    function update_Tumblers() {
        let time = CLOCK_INFO.get_Time
        let time_Split = time.split(":")

        hours_Tumbler.currentIndex = time_Split[0]
        minutes_Tumbler.currentIndex = time_Split[1]
    }

    function format_Number(number) {
        return number < 10 ? "0" + number : number.toString()
    }

    function show_Dialog() {
        dialog_Background.show()
        root.visible = true
        update_Tumblers()
    }

    function hide_Dialog() {
        dialog_Background.hide()
        root.visible = false
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:1.75;height:480;width:640}D{i:10}
}
##^##*/
