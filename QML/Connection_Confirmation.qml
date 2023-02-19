import QtQuick
import QtQuick.Controls
import "Components/"

Item {
    id: root
    signal back

    property string device_Mac_Address: ""

    visible: false
    anchors.fill: parent

    Dialogs_Background {
        id: dialog_Background
    }

    Rectangle {
        id: confirm_Body
        width: 250
        height: 160
        color: "#ffffff"
        radius: 5
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Text {
            id: confirm_Label
            text: qsTr("Confirm connection")
            font.pixelSize: 14
            font.family: FontsManager.regular_Font.name
            anchors.top: parent.top
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
                text: qsTr("Are you sure you want to connect to this device?")
                font.pixelSize: 14
                font.family: FontsManager.regular_Font.name
                wrapMode: Text.WordWrap
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 0
            }

            Column {
                id: column
                width: 200
                spacing: 5
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: confirm_Text.bottom
                anchors.topMargin: 10
                anchors.rightMargin: 0
                anchors.leftMargin: 0

                Row {
                    id: device_Name_Row
                    spacing: 5

                    Text {
                        id: name_Label
                        text: "Name:"
                        font.pixelSize: 14
                        font.family: FontsManager.regular_Font.name
                    }

                    Text {
                        id: device_Name
                        height: name_Label.height
                        text: "-----"
                        font.pixelSize: 14
                        font.family: FontsManager.regular_Font.name
                        elide: Text.ElideRight
                    }
                }

                Row {
                    id: device_Mac_Row
                    spacing: 5

                    Text {
                        id: mac_Label
                        text: "MAC:"
                        font.pixelSize: 14
                        font.family: FontsManager.regular_Font.name
                    }

                    Text {
                        id: device_Mac
                        height: mac_Label.height
                        text: "--:--:--:--:--:--"
                        font.pixelSize: 14
                        font.family: FontsManager.regular_Font.name
                        elide: Text.ElideRight
                    }
                }
            }
        }

        Regular_Button {
            id: no_Connect
            width: 90
            height: 30
            button_Text: qsTr("No")
            font_Size: 14
            font_Name: FontsManager.regular_Font.name
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 8
            anchors.leftMargin: 15

            onButton_Pressed: {
                hide_Dialog();
            }
        }

        Regular_Button {
            id: yes_Connect
            width: 90
            height: 30
            button_Text: qsTr("Yes, Connect")
            font_Size: 14
            font_Name: FontsManager.regular_Font.name
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 8
            anchors.rightMargin: 15

            onButton_Pressed: {
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
    D{i:0;autoSize:true;formeditorZoom:1.1;height:480;width:640}
}
##^##*/
