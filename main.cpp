#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "fileactions.h"


int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    qmlRegisterSingletonType<FileActions>(
                "MyStuff", 1, 0, "FileActions", [](auto *, auto *) -> QObject* {return new FileActions{nullptr};}
    );
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;


    return app.exec();
}
