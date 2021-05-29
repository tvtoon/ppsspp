// Copyright (c) 2014- PPSSPP Project.

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, version 2.0 or later versions.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License 2.0 for more details.

// A copy of the GPL 2.0 should have been included with the program.
// If not, see http://www.gnu.org/licenses/

// Official git repository and contact information can be found at
// https://github.com/hrydgard/ppsspp and http://www.ppsspp.org/.

#include <string>
#include "Qt/QtHost.h"

QtHost::QtHost(MainWindow *mainWindow_) { mainWindow = mainWindow_; }
void QtHost::UpdateUI() { mainWindow->updateMenus(); }
void QtHost::UpdateMemView() {}
void QtHost::UpdateDisassembly() { mainWindow->updateMenus(); }
void QtHost::SetDebugMode(bool mode) {}
bool QtHost::InitGraphics(std::string *error_message, GraphicsContext **ctx) { return true; }
void QtHost::ShutdownGraphics() {}
//void QtHost::InitSound() {}
void QtHost::UpdateSound() {}
//void QtHost::ShutdownSound() {}
// this is sent from EMU thread! Make sure that Host handles it properly!
void QtHost::BootDone()
{
 g_symbolMap->SortSymbols();
 mainWindow->Notify(MainWindowMsg::BOOT_DONE);
}

bool QtHost::IsDebuggingEnabled()
{
#ifdef _DEBUG
 return true;
#else
 return false;
#endif
}

bool QtHost::AttemptLoadSymbolMap()
{
 auto fn = SymbolMapFilename(PSP_CoreParameter().fileToStart);
 return g_symbolMap->LoadSymbolMap(fn.c_str());
}

void QtHost::NotifySymbolMapUpdated() { g_symbolMap->SortSymbols(); }

void QtHost::PrepareShutdown()
{
 auto fn = SymbolMapFilename(PSP_CoreParameter().fileToStart);
 g_symbolMap->SaveSymbolMap(fn.c_str());
}

void QtHost::SetWindowTitle(const char *message)
{
 std::string title = std::string("PPSSPP ") + PPSSPP_GIT_VERSION;

 if (message) title += std::string(" - ") + message;
#ifdef _DEBUG
 title += " (debug)";
#endif
 mainWindow->SetWindowTitleAsync(title);
}

void QtHost::NotifyUserMessage(const std::string &message, float duration, u32 color, const char *id)
{
 osm.Show(message, duration, color, -1, true, id);
}

void QtHost::SendUIMessage(const std::string &message, const std::string &value)
{
 NativeMessageReceived(message.c_str(), value.c_str());
}

void QtHost::NotifySwitchUMDUpdated() {}

std::string QtHost::SymbolMapFilename(std::string currentFilename)
{
	size_t dot = currentFilename.rfind('.');
	if (dot == std::string::npos)
		currentFilename.append(".map");
	else
		currentFilename.replace(dot, -1, ".map");

	return currentFilename;
}
