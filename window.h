#ifndef WINDOW_H
#define WINDOW_H

#include <QObject>
#include<QPoint>

class Window : public QObject
{
    Q_OBJECT
public:
    explicit Window(QObject *parent = nullptr);


public slots:
    void setCursorPos(QPoint p);
signals:
};

#endif // WINDOW_H
