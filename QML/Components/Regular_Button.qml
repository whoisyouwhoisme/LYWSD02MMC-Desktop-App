import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

Item {
    property string button_Text
    property bool button_Checkable
    property bool button_Enabled: true
    property int button_Radius: 5
    property var font_Name
    property int font_Size
    signal button_Pressed

    Button {
        id: button
        width: parent.width
        height: parent.height
        text: button_Text
        checkable: button_Checkable
        enabled: button_Enabled
        font.pixelSize: font_Size
        font.family: font_Name
        onClicked: button_Pressed()

        contentItem: Text {
            text: parent.text
            font: parent.font
            color: parent.down || parent.checked ? "white" : "#656565"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        background: Item {
            Rectangle {
                visible: !button.down || !button.checked
                color: button_Enabled ? "white" : "lightgray"
                radius: button_Radius
                anchors.fill: parent
            }
            Rectangle {
                visible: button.down || button.checked
                gradient: Gradient {
                    GradientStop {
                        position: 0
                        color: "#1e90ff"
                    }

                    GradientStop {
                        position: 1
                        color: "#1872cb"
                    }
                    orientation: Gradient.Vertical
                }
                radius: button_Radius
                anchors.fill: parent
            }
        }
    }

    DropShadow {
        anchors.fill: button
        horizontalOffset: 3
        verticalOffset: 3
        radius: 6.0
        samples: 14
        color: "#20000000"
        source: button
    }
}
