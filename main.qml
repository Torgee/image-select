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

    SwipeView {
        id: imageDisplay
        anchors.fill: parent

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
        id: inputImageSources
        folder: "file:///home/torgee/testimages/in/"
        showDirs: false
        nameFilters: ["*.jpg", "*.JPG"]
    }

    FolderListModel {
        id: outputLocation
        folder: "file:///home/torgee/testimages/out/"
        showDirs: inputImageSources.showDirs
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
