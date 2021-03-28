import QtQuick 2.0
import QtQuick.Controls 2.15

Item {
    id: overlay
    anchors.fill: parent
    visible: false

    Rectangle {
        id: rectangle
        color: "#cc000000"
        anchors.fill: parent

        MouseArea {
            anchors.fill: rectangle
        }

        Item {
            id: connecting_Body
            width: 200
            height: 200
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            BusyIndicator {
                id: busyIndicator
                anchors.top: parent.top
                anchors.topMargin: 0
                anchors.horizontalCenter: parent.horizontalCenter

                palette.dark: "white"
            }

            Text {
                id: status_Text
                width: 400
                color: "#ffffff"
                text: qsTr("Connecting to device...")
                elide: Text.ElideRight
                anchors.top: busyIndicator.bottom
                font.pixelSize: 20
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.family: "Bahnschrift"
                anchors.topMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    Timer {
        id: overlay_Timer
        interval: 3000
        onTriggered: overlay.visible = false
    }

    Connections {
        target: BLE_BRIDGE
        function onConnecting_Status_Changed(status) {
            if (!busyIndicator.visible) {
                busyIndicator.visible = true;
            }

            if (status_Text.color != "white") {
                status_Text.color = "white";
            }
            status_Text.text = status;
        }

        function onConnection_Completed() {
            status_Text.color = "lime";
            status_Text.text = "Connection completed!";
            busyIndicator.visible = false;
            overlay_Timer.restart();
        }

        function onConnection_Error(reason) {
            if (!overlay.visible) {
                overlay.visible = true;
            }

            status_Text.color = "red";
            status_Text.text = reason;
            busyIndicator.visible = false;
            overlay_Timer.restart();
        }
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:1.25;height:480;width:640}
}
##^##*/
