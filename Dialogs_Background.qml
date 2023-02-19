import QtQuick

Rectangle {
    id: root

    color: "#333"
    anchors.fill: parent
    opacity: 0
    state: "hideBack"
    visible: false

    states: [
        State {
            name: "hideBack"

            PropertyChanges {
                target: root;
                opacity: 0;
            }
        },
        State {
            name: "showBack"

            PropertyChanges {
                target: root;
                opacity: 0.8;
            }
        }
    ]

    transitions: [
        Transition {
                from: "hideBack"
                to: "showBack"

                NumberAnimation {
                    properties: "opacity";
                    duration: 250;
                }
        }
    ]

    function show() {
        root.visible = true
        root.state = "showBack"
    }

    function hide() {
        root.state = "hideBack"
        root.visible = false
    }
}
