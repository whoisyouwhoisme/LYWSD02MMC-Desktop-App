import QtQuick
import QtQuick.Controls
import "Components/"

Item {
    id: item1
    width: 300
    height: 60
    property alias connection_Button: connection_Button
    property bool device_Connected: false

    Text {
        id: connection_Status
        height: 18
        text: "Not Connected"
        font.pixelSize: 18
        font.family: FontsManager.regular_Font.name
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.topMargin: 0
    }

    Regular_Button {
        id: connection_Button
        width: 80
        height: 25
        button_Text: "Connect"
        font_Size: 14
        font_Name: FontsManager.regular_Font.name
        anchors.top: connection_Status.bottom
        anchors.topMargin: 15
        anchors.horizontalCenter: parent.horizontalCenter

        onButton_Pressed: {
            if (device_Connected) {
                BLE_BRIDGE.disconnect_Device();
            }
            else {
                devices_List.show_Dialog();
                BLE_BRIDGE.scan_Devices();
            }
        }
    }

    Connections {
        target: BLE_BRIDGE
        function onConnected_To_Device(device_Name) {
            connection_Status.text = "Connected To: " + device_Name;
            connection_Button.button_Text = "Disconnect";
            device_Connected = true;
        }

        function onDevice_Disconnected() {
            connection_Status.text = "Not Connected";
            connection_Button.button_Text = "Connect";
            device_Connected = false;
        }
    }

}

/*##^##
Designer {
    D{i:0;formeditorZoom:3}D{i:1}
}
##^##*/
