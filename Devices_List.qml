import QtQuick 2.12
import QtQuick.Controls 2.15

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
        x: 0
        y: 0
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
                                    anchors.left: parent.left
                                    anchors.top: parent.top
                                    anchors.bottom: parent.bottom
                                    source: deviceInfo_Icon
                                    anchors.leftMargin: 10
                                    anchors.bottomMargin: 10
                                    anchors.topMargin: 10
                                    fillMode: Image.PreserveAspectFit
                                }

                                Text {
                                    id: name_Label
                                    text: qsTr("Name:")
                                    anchors.left: device_Icon.right
                                    anchors.top: parent.top
                                    font.pixelSize: 14
                                    font.family: "Bahnschrift"
                                    anchors.leftMargin: 10
                                    anchors.topMargin: 8
                                }

                                Text {
                                    id: mac_Label
                                    text: qsTr("MAC:")
                                    anchors.left: device_Icon.right
                                    anchors.bottom: parent.bottom
                                    font.pixelSize: 14
                                    font.family: "Bahnschrift"
                                    anchors.leftMargin: 10
                                    anchors.bottomMargin: 8
                                }

                                Text {
                                    id: device_Name
                                    text: deviceInfo_Name
                                    elide: Text.ElideRight
                                    anchors.left: name_Label.right
                                    anchors.right: parent.right
                                    anchors.top: parent.top
                                    font.pixelSize: 14
                                    anchors.rightMargin: 10
                                    font.family: "Bahnschrift"
                                    anchors.leftMargin: 3
                                    anchors.topMargin: 8
                                }

                                Text {
                                    id: device_Mac
                                    text: deviceInfo_Mac
                                    elide: Text.ElideRight
                                    anchors.left: mac_Label.right
                                    anchors.right: parent.right
                                    anchors.bottom: parent.bottom
                                    font.pixelSize: 12
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

        Button {
            id: search_Button
            width: 100
            height: 20
            text: qsTr("Stop Search")
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.rightMargin: 8
            font.pointSize: 10
            anchors.bottomMargin: 8
            font.family: "Bahnschrift"

            onClicked: {
                if (search_Completed) {
                    BLE_BRIDGE.scan_Devices();
                }
                else {
                    BLE_BRIDGE.stop_Scan();
                }
            }
        }

        Button {
            id: close_Button
            width: 100
            height: 20
            text: qsTr("Exit")
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            font.pointSize: 10
            font.family: "Bahnschrift"
            anchors.leftMargin: 8
            anchors.bottomMargin: 8

            onClicked: {
                BLE_BRIDGE.stop_Scan();
                hide_Dialog();
            }
        }

        Text {
            id: discovering_Status
            text: qsTr("Device List")
            elide: Text.ElideRight
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            font.pixelSize: 14
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.leftMargin: 8
            anchors.rightMargin: 8
            anchors.topMargin: 8
            font.family: "Bahnschrift"
        }
    }

    Connections {
        target: BLE_BRIDGE
        function onClear_Devices_List() {
            devices_List_Model.clear();
        }

        function onNew_Device_Found(device_Name, device_Mac) {
            var icon_Path = "/icons/bluetooth.svg";

            if (device_Name === "LYWSD02") {
                icon_Path = "/icons/clock.svg";
            }
            else {
                icon_Path = "/icons/bluetooth.svg";
            }

            devices_List_Model.append({"deviceInfo_Name":device_Name, "deviceInfo_Mac":device_Mac, "deviceInfo_Icon":icon_Path});
        }

        function onSearch_Status_Changed(search_Status) {
            discovering_Status.text = search_Status;
        }

        function onSearch_Completed() {
            search_Completed = true;
            search_Button.text = "Scan Again";
        }

        function onSearch_Started() {
            search_Completed = false;
            search_Button.text = "Stop Search";
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
