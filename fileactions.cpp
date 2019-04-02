#include "fileactions.h"
#include <QFile>
#include <QUrl>

#include <iostream>

FileActions::FileActions(QObject *parent) : QObject(parent)
{

}

void FileActions::copy(QUrl from, QUrl to)
{
    auto const f = from.path();
    auto const t = to.path();
    std::cout << "copy - " << f.toStdString() << " -> " << t.toStdString()// << std::endl;
    //QFile::copy(from.toString(), to.toString());
    << (QFile::copy(from.path(), to.path()) ? " and it worked!" : " but it failed...") << std::endl;
}

void FileActions::del(QUrl where)
{
    QFile file{where.path()};

    auto const w = where.path();
    std::cout << "del: " << w.toStdString()//;

     << (file.remove() ? " and it worked!" : " but it failed...") << std::endl;
}
