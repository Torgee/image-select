import QtQuick 2.12
import QtQuick.Controls 2.5

import QtQuick.Dialogs 1.3
import Qt.labs.folderlistmodel 2.12
import QtQuick.Layouts 1.12

import MyStuff 1.0

ApplicationWindow {
    visibility: "Maximized"
    title: qsTr("Image Selector")
    background: Rectangle { color: "black" }

    SwipeView {
        id: swipeView
        anchors.fill: parent

        Repeater {
            id: repeater
            model: inputLocation
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

                    Text {
                        anchors.bottom: parent.bottom
                        anchors.right: parent.right
                        text: source
                    }

                    property bool selected: outputLocation.count, (outputLocation.indexOf(source) >= 0)
                }
            }
        }
    }

    FolderListModel {
        id: inputLocation
        folder: "file:///home/torgee/testimages/in/"
        showDirs: false
        nameFilters: ["*.jpg", "*.JPG"]
    }
    FolderListModel {
        id: outputLocation
        folder: "file:///home/torgee/testimages/out/"
        showDirs: inputLocation.showDirs
        nameFilters: inputLocation.nameFilters
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
            onPressed: swipeView.decrementCurrentIndex()
        }
        TabButton {
            text: qsTr("Remove")
            onPressed: remove(swipeView.currentItem.item)
            background: Rectangle { color: "red" }
        }
        TabButton {
            text: swipeView.currentItem.item.selected ? qsTr("X") : qsTr("O")
            width: height
            background: Rectangle { color: "grey" }
        }
        TabButton {
            text: qsTr("Select")
            background: Rectangle { color: "green" }
            onPressed: save(swipeView.currentItem.item)
        }
        TabButton {
            text: qsTr("Next")
            onPressed: swipeView.incrementCurrentIndex()
        }
    }
}
