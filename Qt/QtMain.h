#ifndef QTMAIN_H
#define QTMAIN_H

#include <QTouchEvent>
#include <QMouseEvent>
#include <QInputDialog>
#include "Common/GPU/OpenGL/GLSLProgram.h"
#include <QGLWidget>

#ifndef SDL
#include <QAudioOutput>
#include <QAudioFormat>
#endif
#if defined(MOBILE_DEVICE)
#include <QAccelerometer>
#if QT_VERSION < QT_VERSION_CHECK(5, 0, 0)
QTM_USE_NAMESPACE
#endif
#endif

#include <cassert>
#include <atomic>
#include <thread>

#include "Common/System/Display.h"
#include "Common/TimeUtil.h"
#include "Common/File/VFS/VFS.h"
#include "Common/File/VFS/AssetReader.h"
#include "Common/GPU/OpenGL/GLCommon.h"
#include "Common/GPU/OpenGL/GLFeatures.h"
#include "Common/Input/InputState.h"
#include "Common/Input/KeyCodes.h"
#include "Common/GPU/thin3d.h"
#include "Common/Net/Resolve.h"
#include "NKCodeFromQt.h"

#include "Common/GraphicsContext.h"
#include "Core/Core.h"
#include "Core/Config.h"
#include "Core/ConfigValues.h"
#include "Core/System.h"
#include "Common/GPU/thin3d_create.h"
#include "Common/GPU/OpenGL/GLRenderManager.h"

// Input
void SimulateGamepad();

class QtGLGraphicsContext : public GraphicsContext {
public:
	QtGLGraphicsContext();
	~QtGLGraphicsContext();

	void Shutdown() override;
	void SwapInterval(int interval) override;
	void SwapBuffers() override;
	void Resize() override;
	Draw::DrawContext *GetDrawContext() override;
	void ThreadStart() override;
	bool ThreadFrame() override;
	void ThreadEnd() override;
	void StopThread() override;
private:
	Draw::DrawContext *draw_ = nullptr;
	GLRenderManager *renderManager_ = nullptr;
};

enum class EmuThreadState {
	DISABLED,
	START_REQUESTED,
	RUNNING,
	QUIT_REQUESTED,
	STOPPED,
};


// GUI, thread manager
class MainUI : public QGLWidget
{
	Q_OBJECT
public:
	explicit MainUI(QWidget *parent = 0);
	~MainUI();

	void resizeGL(int w, int h);

public slots:
	QString InputBoxGetQString(QString title, QString defaultValue);

signals:
	void doubleClick();
	void newFrame();

protected:
	void timerEvent(QTimerEvent *);
	void changeEvent(QEvent *e);
	bool event(QEvent *e);

	void initializeGL();
	void paintGL();

	void updateAccelerometer();

	void EmuThreadFunc();
	void EmuThreadStart();
	void EmuThreadStop();
	void EmuThreadJoin();

private:
	QtGLGraphicsContext *graphicsContext;

	float xscale, yscale;
#if defined(MOBILE_DEVICE)
	QAccelerometer* acc;
#endif

	std::thread emuThread;
	std::atomic<int> emuThreadState;
};

#ifdef USING_QT_MULTIMEDIA
class QTCamera : public QObject {
	Q_OBJECT
public:
	QTCamera() {}
	~QTCamera() {};

signals:
	void onStartCamera(int width, int height);
	void onStopCamera();

public slots:
	void startCamera(int width, int height);
	void stopCamera();
};
#endif

extern MainUI* emugl;

#ifndef SDL

// Audio
class MainAudio : public QObject {
	Q_OBJECT
public:
	MainAudio() {}
	~MainAudio();
public slots:
	void run();
protected:
	void timerEvent(QTimerEvent *);
private:
	QIODevice* feed;
	QAudioOutput* output;
	int mixlen;
	char* mixbuf;
	int timer;
};

#endif //SDL

#endif

