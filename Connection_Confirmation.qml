import QtQuick 2.0
import QtQuick.Controls 2.15

Item {
    id: root
    signal back

    property var device_Mac_Address: ""

    visible: false
    anchors.fill: parent

    Dialogs_Background {
        id: dialog_Background
    }

    Rectangle {
        id: confirm_Body
        width: 250
        height: 150
        color: "#ffffff"
        radius: 5
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Text {
            id: confirm_Label
            text: qsTr("Confirm connection")
            anchors.top: parent.top
            font.pixelSize: 14
            font.family: "Bahnschrift"
            anchors.topMargin: 5
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Rectangle {
            id: confirm_Background
            color: "#dedede"
            radius: 5
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: confirm_Label.bottom
            anchors.rightMargin: 15
            anchors.leftMargin: 15
            anchors.topMargin: 5

            Text {
                id: confirm_Text
                height: 35
                text: qsTr("Are you sure you want to connect to this device?")
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                font.pixelSize: 14
                wrapMode: Text.WordWrap
                font.family: "Bahnschrift"
                anchors.rightMargin: 4
                anchors.leftMargin: 4
                anchors.topMargin: 4
            }

            Text {
                id: name_Label
                text: qsTr("Name:")
                anchors.left: parent.left
                anchors.top: confirm_Text.bottom
                font.pixelSize: 14
                font.family: "Bahnschrift"
                anchors.leftMargin: 4
                anchors.topMargin: 4
            }

            Text {
                id: mac_Label
                text: qsTr("MAC:")
                anchors.left: parent.left
                anchors.top: name_Label.bottom
                font.pixelSize: 14
                font.family: "Bahnschrift"
                anchors.leftMargin: 4
                anchors.topMargin: 4
            }

            Text {
                id: device_Name
                y: name_Label.y
                height: name_Label.height
                text: qsTr("Name Placeholder")
                elide: Text.ElideRight
                anchors.left: name_Label.right
                anchors.right: parent.right
                font.pixelSize: 14
                anchors.rightMargin: 4
                anchors.leftMargin: 3
                font.family: "Bahnschrift"
            }

            Text {
                id: device_Mac
                y: 62
                height: mac_Label.height
                text: qsTr("Mac Placeholder")
                elide: Text.ElideRight
                anchors.left: mac_Label.right
                anchors.right: parent.right
                font.pixelSize: 14
                font.family: "Bahnschrift"
                anchors.rightMargin: 4
                anchors.leftMargin: 3
            }
        }

        Button {
            id: no_Connect
            width: 90
            height: 30
            text: qsTr("No")
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 8
            anchors.leftMargin: 15
            font.pointSize: 10
            font.family: "Bahnschrift"

            onClicked: {
                hide_Dialog();
            }
        }

        Button {
            id: yes_Connect
            width: 90
            height: 30
            text: qsTr("Yes, Connect")
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 8
            anchors.rightMargin: 15
            font.pointSize: 10
            font.family: "Bahnschrift"

            onClicked: {
                hide_Dialog();
                devices_List.hide_Dialog();
                connecting_To_Device.visible = true;
                BLE_BRIDGE.connect_To_Device(device_Mac_Address);
            }
        }
    }

    function show_Dialog(name, mac) {
        device_Name.text = name;
        device_Mac.text = mac;
        device_Mac_Address = mac;

        dialog_Background.show();
        root.visible = true;
    }

    function hide_Dialog() {
        dialog_Background.hide();
        root.visible = false;
    }

}

/*##^##
Designer {
    D{i:0;formeditorZoom:2}D{i:2}D{i:4}D{i:5}D{i:6}D{i:7}D{i:8}D{i:3}D{i:9}
}
##^##*/
