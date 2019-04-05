#include "fileactions.h"
#include <QFile>
#include <QUrl>

#include <iostream>

FileActions::FileActions(QObject *parent) : QObject(parent)
{

}

void FileActions::copy(QUrl from, QUrl to)
{
    QFile::copy(from.path(), to.path());
}

void FileActions::del(QUrl where)
{
    QFile file{where.path()};
    file.remove();
}

QString FileActions::urlToPath(QUrl url)
{
    return url.path();
}
