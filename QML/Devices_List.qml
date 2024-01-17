import QtQuick
import QtQuick.Controls
import "Components/"

Item {
    id: root

    signal back
    property bool search_Completed: false

    visible: false
    anchors.fill: parent

    Dialogs_Background {
        id: dialog_Background

        MouseArea {
            anchors.fill: dialog_Background
        }
    }

    Rectangle {
        id: list_Body
        width: 250
        height: 340
        color: "#ffffff"
        radius: 5
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle {
            id: list_Background
            color: "#ededed"
            radius: 5
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: discovering_Status.bottom
            anchors.bottom: search_Button.top
            anchors.leftMargin: 8
            anchors.rightMargin: 8
            anchors.bottomMargin: 8
            anchors.topMargin: 8

            ScrollView {
                id: scrollView
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                anchors.fill: parent

                ListView {
                    id: listView
                    spacing: 5
                    clip: true
                    bottomMargin: 5
                    topMargin: 5
                    anchors.fill: parent
                    model: ListModel {
                        id: devices_List_Model
                    }
                    delegate: Item {
                        x: 5
                        y: 5
                        width: 224
                        height: 50

                        Button {
                            width: parent.width
                            height: parent.height
                            background: Rectangle {
                                id: device_Container
                                color: "#ffffff"
                                radius: 5
                                anchors.fill: parent

                                Image {
                                    id: device_Icon
                                    width: 30
                                    source: deviceInfo_Icon
                                    fillMode: Image.PreserveAspectFit
                                    mipmap: true
                                    anchors.left: parent.left
                                    anchors.top: parent.top
                                    anchors.bottom: parent.bottom
                                    anchors.leftMargin: 10
                                    anchors.bottomMargin: 10
                                    anchors.topMargin: 10
                                }

                                Text {
                                    id: name_Label
                                    text: qsTr("Name:")
                                    font.pixelSize: 14
                                    font.family: FontsManager.regular_Font.name
                                    anchors.left: device_Icon.right
                                    anchors.top: parent.top
                                    anchors.leftMargin: 10
                                    anchors.topMargin: 8
                                }

                                Text {
                                    id: mac_Label
                                    text: qsTr("MAC:")
                                    font.pixelSize: 14
                                    font.family: FontsManager.regular_Font.name
                                    anchors.left: device_Icon.right
                                    anchors.bottom: parent.bottom
                                    anchors.leftMargin: 10
                                    anchors.bottomMargin: 8
                                }

                                Text {
                                    id: device_Name
                                    text: deviceInfo_Name
                                    font.pixelSize: 14
                                    font.family: FontsManager.regular_Font.name
                                    elide: Text.ElideMiddle
                                    color: "gray"
                                    anchors.left: name_Label.right
                                    anchors.right: parent.right
                                    anchors.top: parent.top
                                    anchors.rightMargin: 10
                                    anchors.leftMargin: 3
                                    anchors.topMargin: 8
                                }

                                Text {
                                    id: device_Mac
                                    text: deviceInfo_Mac
                                    font.pixelSize: 14
                                    font.family: FontsManager.regular_Font.name
                                    elide: Text.ElideMiddle
                                    color: "gray"
                                    anchors.left: mac_Label.right
                                    anchors.right: parent.right
                                    anchors.bottom: parent.bottom
                                    anchors.rightMargin: 10
                                    anchors.leftMargin: 3
                                    anchors.bottomMargin: 8
                                }
                            }

                            onClicked: {
                                BLE_BRIDGE.stop_Scan();
                                connection_Confirmation.show_Dialog(device_Name.text, device_Mac.text);
                            }
                        }
                    }
                }
            }
        }

        Regular_Button {
            id: search_Button
            width: 100
            height: 20
            button_Text: qsTr("Stop Search")
            font_Size: 14
            font_Name: FontsManager.regular_Font.name
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.rightMargin: 8
            anchors.bottomMargin: 8

            onButton_Pressed: {
                if (search_Completed) {
                    BLE_BRIDGE.scan_Devices();
                }
                else {
                    BLE_BRIDGE.stop_Scan();
                }
            }
        }

        Regular_Button {
            id: close_Button
            width: 100
            height: 20
            button_Text: qsTr("Exit")
            font_Size: 14
            font_Name: FontsManager.regular_Font.name
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.leftMargin: 8
            anchors.bottomMargin: 8

            onButton_Pressed: {
                BLE_BRIDGE.stop_Scan();
                hide_Dialog();
            }
        }

        Text {
            id: discovering_Status
            text: qsTr("Device List")
            font.pixelSize: 14
            font.family: FontsManager.regular_Font.name
            elide: Text.ElideRight
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.leftMargin: 8
            anchors.rightMargin: 8
            anchors.topMargin: 8
        }
    }

    Connections {
        target: BLE_BRIDGE
        function onClear_Devices_List() {
            devices_List_Model.clear();
        }

        function onNew_Device_Found(device_Name, device_Mac) {
            var icon_Path = "qrc:/icons/bluetooth.svg";

            if (device_Name === "LYWSD02") {
                icon_Path = "qrc:/icons/clock.svg";
            }
            else {
                icon_Path = "qrc:/icons/bluetooth.svg";
            }

            devices_List_Model.append({"deviceInfo_Name":device_Name, "deviceInfo_Mac":device_Mac, "deviceInfo_Icon":icon_Path});
        }

        function onSearch_Status_Changed(search_Status) {
            discovering_Status.text = search_Status;
        }

        function onSearch_Completed() {
            search_Completed = true;
            search_Button.button_Text = "Scan Again";
        }

        function onSearch_Started() {
            search_Completed = false;
            search_Button.button_Text = "Stop Search";
        }
    }

    Connection_Confirmation {
        id: connection_Confirmation
    }

    function show_Dialog() {
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
    D{i:0;autoSize:true;formeditorZoom:1.25;height:480;width:640}
}
##^##*/
