#ifndef FILEACTIONS_H
#define FILEACTIONS_H

#include <QObject>
#include <QUrl>

class FileActions : public QObject
{
    Q_OBJECT
public:
    explicit FileActions(QObject *parent = nullptr);

    Q_INVOKABLE static void copy(QUrl from, QUrl to);
    Q_INVOKABLE static void del(QUrl where);

signals:

public slots:
};

#endif // FILEACTIONS_H
