#include "window.h"
#include<QCursor>
#include<QDebug>
#include<QPoint>
Window::Window(QObject *parent)
    : QObject{parent}
{}

void Window::setCursorPos(QPoint p)
{
    // qInfo()<< "helo";
    QCursor::setPos(p);

}
