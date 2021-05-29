#pragma once

#include <queue>
#include <mutex>

#include <QtCore>
#include <QMenuBar>
#include <QMainWindow>
#include <QActionGroup>

#include "Common/System/System.h"
#include "Common/System/NativeApp.h"
#include "../Common/ConsoleListener.h"
#include "Core/Core.h"
#include "Core/Config.h"
#include "Core/System.h"
#include "Qt/QtMain.h"

extern bool g_TakeScreenshot;

enum {
	FB_NON_BUFFERED_MODE = 0,
	FB_BUFFERED_MODE = 1,
	TEXSCALING_AUTO = 0,
};

// hacky, should probably use qt signals or something, but whatever..
enum class MainWindowMsg {
	BOOT_DONE,
	WINDOW_TITLE_CHANGED,
};

class MenuAction : public QAction
{
	Q_OBJECT

public:
	// Add to QMenu
	MenuAction(QWidget* parent, const char *callback, const char *text, QKeySequence key = 0);// : QAction(parent), _text(text), _eventCheck(0), _eventUncheck(0), _stateEnable(-1), _stateDisable(-1), _enableStepping(false);

	// Add to QActionGroup
	MenuAction(QWidget* parent, QActionGroup* group, QVariant data, QString text, QKeySequence key = 0);// : QAction(parent), _eventCheck(0), _eventUncheck(0), _stateEnable(-1), _stateDisable(-1), _enableStepping(false);
	// Event which causes it to be checked
	void addEventChecked(bool* event);
	// TODO: Possibly handle compares
	void addEventChecked(int* event);
	// Event which causes it to be unchecked
	void addEventUnchecked(bool* event);
	// UI State which causes it to be enabled
	void addEnableState(int state);
	void addDisableState(int state);
	MenuAction* addEnableStepping();
public slots:
	void retranslate();
	void update();
private:
	const char *_text;
	bool *_eventCheck;
	bool *_eventUncheck;
	int _stateEnable, _stateDisable;
	bool _enableStepping;
};

class MenuActionGroup : public QActionGroup
{
	Q_OBJECT
public:
	MenuActionGroup(QWidget* parent, QMenu* menu, const char* callback, QStringList nameList,
		QList<int> valueList, QList<int> keyList = QList<int>()); // : QActionGroup(parent);
};

class MenuTree : public QMenu
{
	Q_OBJECT
public:
	MenuTree(QWidget* parent, QMenuBar* menu, const char *text);// : QMenu(parent), _text(text);
	MenuTree(QWidget* parent, QMenu* menu, const char *text);// : QMenu(parent), _text(text);
	MenuAction* add(MenuAction* action);
public slots:
	void retranslate();
private:
	const char *_text;
};

class MainWindow : public QMainWindow
{
	Q_OBJECT

public:
	explicit MainWindow(QWidget *parent = nullptr, bool fullscreen = false);
	~MainWindow();
	CoreState GetNextState();
 void updateMenuGroupInt(QActionGroup *group, int value);
	void updateMenus();
	void Notify(MainWindowMsg msg);
	void SetWindowTitleAsync(std::string title);

protected:
	void changeEvent(QEvent *e);
	void closeEvent(QCloseEvent *);

signals:
	void retranslate();
	void updateMenu();

public slots:
	void newFrame();

private slots:
	// File
	void loadAct();
	void closeAct();
	void openmsAct();
	void saveStateGroup_triggered(QAction *action);
	void qlstateAct();
	void qsstateAct();
	void lstateAct();
	void sstateAct();
	void recordDisplayAct();
	void useLosslessVideoCodecAct();
	void useOutputBufferAct();
	void recordAudioAct();
	void exitAct();

	// Emulation
	void runAct();
	void pauseAct();
	void stopAct();
	void resetAct();
	void switchUMDAct();
	void displayRotationGroup_triggered(QAction *action);

	// Debug
	void breakonloadAct();
	void ignoreIllegalAct();
	void lmapAct();
	void smapAct();
	void lsymAct();
	void ssymAct();
	void resetTableAct();
	void dumpNextAct();
	void takeScreen();
	void consoleAct();

	// Game settings
	void languageAct();
	void controlMappingAct();
	void displayLayoutEditorAct();
	void moreSettingsAct();
 void bufferRenderAct();
	void linearAct();
	void renderingResolutionGroup_triggered(QAction *action);
	void windowGroup_triggered(QAction *action);
	void displayLayoutGroup_triggered(QAction *action);
	void renderingModeGroup_triggered(QAction *action);
	void autoframeskipAct();
	void frameSkippingGroup_triggered(QAction *action);
	void frameSkippingTypeGroup_triggered(QAction *action);
	void textureFilteringGroup_triggered(QAction *action);
	void screenScalingFilterGroup_triggered(QAction *action);
	void textureScalingLevelGroup_triggered(QAction *action);
	void textureScalingTypeGroup_triggered(QAction *action);
	void deposterizeAct();
	void transformAct();
	void vertexCacheAct();
	void frameskipAct();
	void frameskipTypeAct();

	// Sound
	void audioAct();
	// Cheats
	void cheatsAct();
	// Chat
	void chatAct();
	void fullscrAct();
	void raiseTopMost();
	void statsAct();
	void showFPSAct();
	// Help
	void websiteAct();
	void forumAct();
	void goldAct();
	void gitAct();
#ifdef USE_DISCORD
	void discordAct();
#endif
	void aboutAct();
	// Others
	void langChanged(QAction *action);

private:
	void bootDone();
	void SetWindowScale(int zoom);
	void SetGameTitle(QString text);
	void SetFullScreen(bool fullscreen);
	void loadLanguage(const QString &language, bool retranslate);
	void createMenus();

	QTranslator translator;
	QString currentLanguage;

	CoreState nextState;
	GlobalUIState lastUIState;

	QActionGroup *windowGroup,
	             *textureScalingLevelGroup, *textureScalingTypeGroup,
	             *screenScalingFilterGroup, *textureFilteringGroup,
	             *frameSkippingTypeGroup, *frameSkippingGroup,
	             *renderingModeGroup, *renderingResolutionGroup,
	             *displayRotationGroup, *saveStateGroup;

	std::queue<MainWindowMsg> msgQueue_;
	std::mutex msgMutex_;

	std::string newWindowTitle_;
	std::mutex titleMutex_;
};
