import QtQuick
import QtQuick.Controls

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

        Text {
            id: status_Text
            width: 400
            color: "#ffffff"
            text: qsTr("Writing Service...")
            font.pixelSize: 20
            font.family: FontsManager.regular_Font.name
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    Timer {
        id: overlay_Timer
        interval: 3000
        onTriggered: overlay.visible = false
    }

    Connections {
        target: BLE_BRIDGE
        function onWriting_Service() {
            status_Text.color = "white";
            status_Text.text = "Writing Service...";
            overlay.visible = true;
        }

        function onWriting_Service_Completed() {
            status_Text.color = "lime";
            status_Text.text = "Writing completed!";
            overlay_Timer.restart();
        }
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:1.25;height:480;width:640}
}
##^##*/
