import QtQuick 2.12
import QtQuick.Controls 2.5

import QtQuick.Dialogs 1.3
import Qt.labs.folderlistmodel 2.12
import QtQuick.Layouts 1.12

import MyStuff 1.0

ApplicationWindow {
    visibility: "Maximized"
    visible: true
    title: qsTr("Image Selector")
    background: Rectangle { color: "black" }

    ListView {
        id: inputLocationSelect
        anchors.top: parent.top
        anchors.bottom: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right

        headerPositioning: ListView.OverlayHeader
        header: Label {
            width: parent.width
            z: 2
            text: qsTr("Source Location: ") + inputLocation.folder
            color: "black"
            background: Rectangle { color: "magenta"}
        }

        highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
        clip: true

        model: FolderListModel {
            id: inputLocation
            showDotAndDotDot: true
            showDirsFirst: true
            folder: "file:///home/torgee/testimages/in/"
            nameFilters: ["*.jpg", "*.JPG"]
        }

        delegate: ToolButton {
            id: control
            width: parent.width
            text: fileName
            contentItem: Label {
                text: control.text
                font: control.font
                color: "white"
                background: Rectangle { color: fileIsDir ? "teal" : "orange" }
            }
            onClicked: {

                if (fileIsDir) {
                    inputLocation.folder = fileURL
                } else {
                    imageDisplay.currentIndex = inputImageSources.indexOf(fileURL)
                }
            }
        }
    }

    SwipeView {
        id: imageDisplay
        anchors.top: inputLocationSelect.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        Repeater {
            id: repeater
            model: inputImageSources
            Loader {
                active: SwipeView.isCurrentItem || SwipeView.isNextItem || SwipeView.isPreviousItem
                sourceComponent: Image {
                    id: image
                    fillMode: Image.PreserveAspectFit
                    autoTransform: true
                    asynchronous: true
                    smooth: true
                    source: fileURL
                    property string fileName: model.fileName

                    Label {
                        anchors.bottom: parent.bottom
                        anchors.right: parent.right
                        text: source
                        color: "white"
                        background: Rectangle { color: "black" }
                    }

                    property bool selected: outputLocation.count, (outputLocation.indexOf(source) >= 0)
                }
            }
        }
    }

    FolderListModel {
        id: inputImageSources
        folder: inputLocation.folder
        showDirs: false
        nameFilters: inputLocation.nameFilters
    }

    FolderListModel {
        id: outputLocation
        folder: "file:///home/torgee/testimages/out/"
        showDirs: false
        nameFilters: inputImageSources.nameFilters
    }

    function save(image) {
        var dest = outputLocation.folder + image.fileName
        FileActions.copy(image.source, dest)
    }
    function remove(image) {
        var dest = outputLocation.folder + image.fileName
        FileActions.del(dest)
    }

    footer: TabBar {
        TabButton {
            text: qsTr("Previous")
            onPressed: imageDisplay.decrementCurrentIndex()
        }
        TabButton {
            text: qsTr("Remove")
            onPressed: remove(imageDisplay.currentItem.item)
            background: Rectangle { color: "red" }
        }
        TabButton {
            text: imageDisplay.currentItem ? (imageDisplay.currentItem.item.selected ? qsTr("X") : qsTr("O")) : qsTr("?")
            width: height
            background: Rectangle { color: "grey" }
        }
        TabButton {
            text: qsTr("Select")
            background: Rectangle { color: "green" }
            onPressed: save(imageDisplay.currentItem.item)
        }
        TabButton {
            text: qsTr("Next")
            onPressed: imageDisplay.incrementCurrentIndex()
        }
    }
}
