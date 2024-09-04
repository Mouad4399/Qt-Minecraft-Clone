

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQuick3D/qquick3d.h>
#include <QQmlContext>
#include"window.h"

// class Window : public QObject{
//     Q_OBJECT

//     public:
//         void setCursorPos(QPoint p){
//             QCursor::setPos(p);
//         }
// };

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);




    // QSurfaceFormat::setDefaultFormat(QQuick3D::idealSurfaceFormat());
    // qputenv("QT_QUICK_CONTROLS_STYLE", "Basic");


    QQmlApplicationEngine engine;

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("firstProjectNewQt", "Main");

    Window window;
    engine.rootContext()->setContextProperty("window1",&window);


    return app.exec();
}
