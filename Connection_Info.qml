<<<<<<< Updated upstream:Connection_Info.qml
import QtQuick 2.0
import QtQuick.Controls 2.15
=======
import QtQuick
import QtQuick.Controls
import "Components/"
>>>>>>> Stashed changes:QML/Connection_Info.qml

Item {
    id: item1
    width: 300
    height: 60
    property alias connection_Button: connection_Button
    property bool device_Connected: false

    Text {
        id: connection_Status
        height: 18
<<<<<<< Updated upstream:Connection_Info.qml
        text: qsTr("Not Connected")
=======
        text: "Not Connected"
        font.pixelSize: 18
        font.family: FontsManager.regular_Font.name
>>>>>>> Stashed changes:QML/Connection_Info.qml
        elide: Text.ElideRight
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        font.pixelSize: 18
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        font.family: "Bahnschrift"
        anchors.topMargin: 0
    }

    Button {
        id: connection_Button
        height: 25
<<<<<<< Updated upstream:Connection_Info.qml
        text: qsTr("Connect")
=======
        button_Text: "Connect"
        font_Size: 14
        font_Name: FontsManager.regular_Font.name
>>>>>>> Stashed changes:QML/Connection_Info.qml
        anchors.top: connection_Status.bottom
        font.pointSize: 10
        font.family: "Bahnschrift"
        anchors.topMargin: 16
        anchors.horizontalCenter: parent.horizontalCenter

        onClicked: {
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
