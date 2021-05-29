PROJECT = ppsspp
MAJVER = 1.11
MINVER = 2
LIBS = ${PROJECT}
PROGS = PPSSPPSDL
#PROGS = PPSSPPQt

include make/conf
include make/cpplib
include make/libpng.mk
include make/sdl2.mk
include make/zlib.mk

ELIBFLAGS += `pkg-config --libs --static libavcodec libavformat libavutil libswscale libswresample`
#ELIBFLAGS += `pkg-config --libs --static Qt5Core Qt5Gui Qt5OpenGL Qt5Widgets`
ELIBFLAGS += -lGL -lGLU -lGLEW -lglslang -lOGLCompiler -lOSDependent -lSPIRV -lSPVRemapper -lspirv-cross-glsl -lspirv-cross-core -lzip
ELIBFLAGS += -lminiupnpc
# -larmips -lsnappy
# USING_GLES is now needed to initialize the GPU!
CFLAGS = -DASSETS_DIR=\"/usr/local/share/ppsspp/assets/\" -DSHARED_LIBZIP -DSHARED_ZLIB -DUSE_FFMPEG=1 -DUSING_GLES=1 -DVK_USE_PLATFORM_XLIB_KHR
# Qt also needs SDL because we are not using QtMultimedia!
CFLAGS += -DSDL
#CFLAGS += `pkg-config --cflags Qt5Core Qt5Gui Qt5OpenGL Qt5Widgets` -DUSING_QT_UI=1 -fPIC
CFLAGS += -D_VERSION_=\"${VERSION}\" -I. -O2 -Wall -Wextra -Werror-implicit-function-declaration -std=c++11 -o
# -DUSE_WEBSERVER -DUSING_ARMIPS -DUSING_SNAPPY -DUSE_DISCORD
# -DUSING_QT_UI=1
# Android (better only use on it)
# -DUSING_GLES2 -DMOBILE_DEVICE
# -DUSING_FBDEV
# -DUSING_WIN_UI
# -pedantic-errors

DATA =
DOCS =
INFOS =
INCLUDES =

# EXTERNALS

SRC = ext/cityhash/city.cpp ext/gason/gason.cpp
SRC += ext/libkirk/AES.c ext/libkirk/amctrl.c ext/libkirk/SHA1.c ext/libkirk/bn.c ext/libkirk/ec.c ext/libkirk/kirk_engine.c
SRC += ext/sfmt19937/SFMT.c ext/xbrz/xbrz.cpp ext/xxhash.c
SRC += ext/udis86/decode.c ext/udis86/itab.c ext/udis86/syn.c ext/udis86/syn-att.c ext/udis86/syn-intel.c ext/udis86/udis86.c

# Also part of native UI definition!
SRC += ext/jpge/jpgd.cpp ext/jpge/jpge.cpp
SRC += Common/Render/Text/draw_text_qt.cpp

SRC += Common/ABI.cpp Common/Thunk.cpp Common/x64Analyzer.cpp Common/x64Emitter.cpp
SRC += Common/CPUDetect.cpp
#SRC += Common/ArmCPUDetect.cpp
#SRC += Common/ArmEmitter.cpp Common/ColorConvNEON.cpp
#SRC += Common/Arm64Emitter.cpp Core/Util/DisArm64.cpp
#SRC += Common/MipsCPUDetect.cpp Common/MipsEmitter.cpp

SRC += Common/Serialize/Serializer.cpp Common/Crypto/md5.cpp Common/Crypto/sha1.cpp Common/Crypto/sha256.cpp Common/Data/Color/RGBAUtil.cpp Common/Data/Convert/SmallDataConvert.cpp Common/Data/Encoding/Base64.cpp Common/Data/Encoding/Compression.cpp Common/Data/Encoding/Utf8.cpp Common/Data/Format/RIFF.cpp Common/Data/Format/IniFile.cpp Common/Data/Format/JSONReader.cpp Common/Data/Format/JSONWriter.cpp Common/Data/Format/PNGLoad.cpp Common/Data/Format/ZIMLoad.cpp Common/Data/Format/ZIMSave.cpp Common/Data/Hash/Hash.cpp Common/Data/Text/I18n.cpp Common/Data/Text/Parsers.cpp Common/Data/Text/WrapText.cpp Common/File/VFS/VFS.cpp Common/File/VFS/AssetReader.cpp Common/File/DiskFree.cpp Common/File/PathBrowser.cpp Common/File/FileUtil.cpp Common/File/DirListing.cpp Common/File/FileDescriptor.cpp Common/GPU/thin3d.cpp Common/GPU/Shader.cpp Common/GPU/ShaderWriter.cpp Common/GPU/ShaderTranslation.cpp Common/GPU/OpenGL/GLDebugLog.cpp Common/GPU/OpenGL/GLSLProgram.cpp Common/GPU/OpenGL/GLFeatures.cpp Common/GPU/OpenGL/thin3d_gl.cpp Common/GPU/OpenGL/GLRenderManager.cpp Common/GPU/OpenGL/GLQueueRunner.cpp Common/GPU/OpenGL/DataFormatGL.cpp Common/GPU/Vulkan/VulkanDebug.cpp Common/GPU/Vulkan/VulkanContext.cpp Common/GPU/Vulkan/VulkanImage.cpp Common/GPU/Vulkan/VulkanLoader.cpp Common/GPU/Vulkan/VulkanMemory.cpp Common/GPU/Vulkan/thin3d_vulkan.cpp Common/GPU/Vulkan/VulkanRenderManager.cpp Common/GPU/Vulkan/VulkanQueueRunner.cpp Common/Input/GestureDetector.cpp Common/Input/InputState.cpp Common/Math/fast/fast_math.c Common/Math/fast/fast_matrix.c Common/Math/fast/fast_matrix_sse.c Common/Math/curves.cpp Common/Math/expression_parser.cpp Common/Math/lin/matrix4x4.cpp Common/Math/lin/vec3.cpp Common/Math/math_util.cpp Common/Net/HTTPClient.cpp Common/Net/HTTPHeaders.cpp Common/Net/HTTPServer.cpp Common/Net/Resolve.cpp Common/Net/Sinks.cpp Common/Net/URL.cpp Common/Net/WebsocketServer.cpp Common/Profiler/Profiler.cpp Common/Render/TextureAtlas.cpp Common/Render/DrawBuffer.cpp Common/Render/Text/draw_text.cpp Common/Render/Text/draw_text_android.cpp Common/Render/Text/draw_text_win.cpp Common/Render/Text/draw_text_uwp.cpp Common/System/Display.cpp Common/Thread/Executor.cpp Common/Thread/PrioritizedWorkQueue.cpp Common/Thread/ThreadUtil.cpp Common/Thread/ThreadPool.cpp Common/UI/Root.cpp Common/UI/Screen.cpp Common/UI/UI.cpp Common/UI/Context.cpp Common/UI/UIScreen.cpp Common/UI/Tween.cpp Common/UI/View.cpp Common/UI/ViewGroup.cpp Common/Buffer.cpp Common/ColorConv.cpp Common/ConsoleListener.cpp Common/ExceptionHandlerSetup.cpp Common/Log.cpp Common/LogManager.cpp Common/MemArenaAndroid.cpp Common/MemArenaDarwin.cpp Common/MemArenaPosix.cpp Common/MemArenaWin32.cpp Common/MemoryUtil.cpp Common/OSVersion.cpp Common/StringUtils.cpp Common/SysError.cpp Common/TimeUtil.cpp
# Android only.
#SRC += Common/GPU/OpenGL/gl3stub.c

# ARM64 only.
# ASRC += Common/Math/fast/fast_matrix_neon.S

# Core extra.
SRC += Core/MIPS/IR/IRCompALU.cpp Core/MIPS/IR/IRCompBranch.cpp Core/MIPS/IR/IRCompFPU.cpp Core/MIPS/IR/IRCompLoadStore.cpp Core/MIPS/IR/IRCompVFPU.cpp Core/MIPS/IR/IRFrontend.cpp Core/MIPS/IR/IRInst.cpp Core/MIPS/IR/IRInterpreter.cpp Core/MIPS/IR/IRJit.cpp Core/MIPS/IR/IRPassSimplify.cpp Core/MIPS/IR/IRRegCache.cpp
## ARM?
#SRC += Core/MIPS/ARM/ArmAsm.cpp Core/MIPS/ARM/ArmCompALU.cpp Core/MIPS/ARM/ArmCompBranch.cpp Core/MIPS/ARM/ArmCompFPU.cpp Core/MIPS/ARM/ArmCompLoadStore.cpp Core/MIPS/ARM/ArmCompVFPU.cpp Core/MIPS/ARM/ArmCompVFPUNEON.cpp Core/MIPS/ARM/ArmCompVFPUNEONUtil.cpp Core/MIPS/ARM/ArmCompReplace.cpp Core/MIPS/ARM/ArmJit.cpp Core/MIPS/ARM/ArmRegCache.cpp Core/MIPS/ARM/ArmRegCacheFPU.cpp GPU/Common/VertexDecoderArm.cpp
## ARM64?
#SRC += Core/MIPS/ARM64/Arm64Asm.cpp Core/MIPS/ARM64/Arm64CompALU.cpp Core/MIPS/ARM64/Arm64CompBranch.cpp Core/MIPS/ARM64/Arm64CompFPU.cpp Core/MIPS/ARM64/Arm64CompLoadStore.cpp Core/MIPS/ARM64/Arm64CompVFPU.cpp Core/MIPS/ARM64/Arm64CompReplace.cpp Core/MIPS/ARM64/Arm64Jit.cpp Core/MIPS/ARM64/Arm64RegCache.cpp Core/MIPS/ARM64/Arm64RegCacheFPU.cpp GPU/Common/VertexDecoderArm64.cpp Core/Util/DisArm64.cpp
## X86?
SRC += Core/MIPS/x86/Asm.cpp Core/MIPS/x86/CompALU.cpp Core/MIPS/x86/CompBranch.cpp Core/MIPS/x86/CompFPU.cpp Core/MIPS/x86/CompLoadStore.cpp Core/MIPS/x86/CompVFPU.cpp Core/MIPS/x86/CompReplace.cpp Core/MIPS/x86/Jit.cpp Core/MIPS/x86/JitSafeMem.cpp Core/MIPS/x86/RegCache.cpp Core/MIPS/x86/RegCacheFPU.cpp GPU/Common/VertexDecoderX86.cpp GPU/Software/SamplerX86.cpp
## MIPS?
#SRC += Core/MIPS/MIPS/MipsJit.cpp GPU/Common/VertexDecoderFake.cpp
## Not mobile.
SRC += Core/AVIDump.cpp Core/WaveFile.cpp

SRC += Core/Config.cpp Core/Core.cpp Core/Compatibility.cpp Core/CoreTiming.cpp Core/CwCheat.cpp Core/HDRemaster.cpp Core/Instance.cpp Core/KeyMap.cpp Core/Debugger/Breakpoints.cpp Core/Debugger/SymbolMap.cpp Core/Debugger/DisassemblyManager.cpp Core/Dialog/PSPDialog.cpp Core/Dialog/PSPGamedataInstallDialog.cpp Core/Dialog/PSPMsgDialog.cpp Core/Dialog/PSPNetconfDialog.cpp Core/Dialog/PSPOskDialog.cpp Core/Dialog/PSPPlaceholderDialog.cpp Core/Dialog/PSPSaveDialog.cpp Core/Dialog/PSPScreenshotDialog.cpp Core/Dialog/SavedataParam.cpp Core/ELF/ElfReader.cpp Core/ELF/PBPReader.cpp Core/ELF/PrxDecrypter.cpp Core/ELF/ParamSFO.cpp Core/FileSystems/tlzrc.cpp Core/FileSystems/BlobFileSystem.cpp Core/FileSystems/BlockDevices.cpp Core/FileSystems/DirectoryFileSystem.cpp Core/FileSystems/FileSystem.cpp Core/FileSystems/ISOFileSystem.cpp Core/FileSystems/MetaFileSystem.cpp Core/FileSystems/VirtualDiscFileSystem.cpp Core/Font/PGF.cpp Core/HLE/HLE.cpp Core/HLE/ReplaceTables.cpp Core/HLE/HLEHelperThread.cpp Core/HLE/HLETables.cpp Core/HLE/KUBridge.cpp Core/HLE/Plugins.cpp Core/HLE/__sceAudio.cpp Core/HLE/sceAdler.cpp Core/HLE/sceAtrac.cpp Core/HLE/sceAudio.cpp Core/HLE/sceAudiocodec.cpp Core/HLE/sceAudioRouting.cpp Core/HLE/sceCcc.cpp Core/HLE/sceChnnlsv.cpp Core/HLE/sceCtrl.cpp Core/HLE/sceDeflt.cpp Core/HLE/sceDisplay.cpp Core/HLE/sceDmac.cpp Core/HLE/sceG729.cpp Core/HLE/sceGameUpdate.cpp Core/HLE/sceGe.cpp Core/HLE/sceFont.cpp Core/HLE/sceHeap.cpp Core/HLE/sceHprm.cpp Core/HLE/sceHttp.cpp Core/HLE/sceImpose.cpp Core/HLE/sceIo.cpp Core/HLE/sceJpeg.cpp Core/HLE/sceKernel.cpp Core/HLE/sceKernelAlarm.cpp Core/HLE/sceKernelEventFlag.cpp Core/HLE/sceKernelHeap.cpp Core/HLE/sceKernelInterrupt.cpp Core/HLE/sceKernelMbx.cpp Core/HLE/sceKernelMemory.cpp Core/HLE/sceKernelModule.cpp Core/HLE/sceKernelMsgPipe.cpp Core/HLE/sceKernelMutex.cpp Core/HLE/sceKernelSemaphore.cpp Core/HLE/sceKernelThread.cpp Core/HLE/sceKernelTime.cpp Core/HLE/sceKernelVTimer.cpp Core/HLE/sceMpeg.cpp Core/HLE/sceNet.cpp Core/HLE/sceNetAdhoc.cpp Core/HLE/proAdhoc.cpp Core/HLE/proAdhocServer.cpp Core/HLE/sceOpenPSID.cpp Core/HLE/sceP3da.cpp Core/HLE/sceMt19937.cpp Core/HLE/sceMd5.cpp Core/HLE/sceMp4.cpp Core/HLE/sceMp3.cpp Core/HLE/sceParseHttp.cpp Core/HLE/sceParseUri.cpp Core/HLE/scePower.cpp Core/HLE/scePsmf.cpp Core/HLE/sceRtc.cpp Core/HLE/sceSas.cpp Core/HLE/sceSfmt19937.cpp Core/HLE/sceSha256.cpp Core/HLE/sceSsl.cpp Core/HLE/sceUmd.cpp Core/HLE/sceUsb.cpp Core/HLE/sceUsbAcc.cpp Core/HLE/sceUsbCam.cpp Core/HLE/sceUsbGps.cpp Core/HLE/sceUsbMic.cpp Core/HLE/sceUtility.cpp Core/HLE/sceVaudio.cpp Core/HLE/scePspNpDrm_user.cpp Core/HLE/sceNp.cpp Core/HLE/scePauth.cpp Core/HW/SimpleAudioDec.cpp Core/HW/AsyncIOManager.cpp Core/HW/BufferQueue.cpp Core/HW/Camera.cpp Core/HW/MediaEngine.cpp Core/HW/MpegDemux.cpp Core/HW/MemoryStick.cpp Core/HW/SasAudio.cpp Core/HW/SasReverb.cpp Core/HW/StereoResampler.cpp Core/Host.cpp Core/Loaders.cpp Core/FileLoaders/CachingFileLoader.cpp Core/FileLoaders/DiskCachingFileLoader.cpp Core/FileLoaders/HTTPFileLoader.cpp Core/FileLoaders/LocalFileLoader.cpp Core/FileLoaders/RamCachingFileLoader.cpp Core/FileLoaders/RetryingFileLoader.cpp Core/MIPS/JitCommon/JitCommon.cpp Core/MIPS/JitCommon/JitBlockCache.cpp Core/MIPS/JitCommon/JitState.cpp Core/MIPS/MIPS.cpp Core/MIPS/MIPSAnalyst.cpp Core/MIPS/MIPSCodeUtils.cpp Core/MIPS/MIPSDebugInterface.cpp Core/MIPS/MIPSDis.cpp Core/MIPS/MIPSDisVFPU.cpp Core/MIPS/MIPSInt.cpp Core/MIPS/MIPSIntVFPU.cpp Core/MIPS/MIPSStackWalk.cpp Core/MIPS/MIPSTables.cpp Core/MIPS/MIPSVFPUUtils.cpp Core/MIPS/MIPSAsm.cpp Core/MemFault.cpp Core/MemMap.cpp Core/MemMapFunctions.cpp Core/PSPLoaders.cpp Core/Reporting.cpp Core/Replay.cpp Core/SaveState.cpp Core/Screenshot.cpp Core/System.cpp Core/TextureReplacer.cpp Core/ThreadPools.cpp Core/Util/AudioFormat.cpp Core/Util/AudioFormatNEON.cpp Core/Util/GameManager.cpp Core/Util/PortManager.cpp Core/Util/BlockAllocator.cpp Core/Util/PPGeDraw.cpp

#SRC += Core/Debugger/WebSocket.cpp Core/Debugger/WebSocket/BreakpointSubscriber.cpp Core/Debugger/WebSocket/CPUCoreSubscriber.cpp Core/Debugger/WebSocket/DisasmSubscriber.cpp Core/Debugger/WebSocket/GameBroadcaster.cpp Core/Debugger/WebSocket/GameSubscriber.cpp Core/Debugger/WebSocket/GPUBufferSubscriber.cpp Core/Debugger/WebSocket/GPURecordSubscriber.cpp Core/Debugger/WebSocket/HLESubscriber.cpp Core/Debugger/WebSocket/InputBroadcaster.cpp Core/Debugger/WebSocket/InputSubscriber.cpp Core/Debugger/WebSocket/LogBroadcaster.cpp Core/Debugger/WebSocket/MemorySubscriber.cpp Core/Debugger/WebSocket/SteppingBroadcaster.cpp Core/Debugger/WebSocket/SteppingSubscriber.cpp Core/Debugger/WebSocket/WebSocketUtils.cpp
#SRC += Core/WebServer.cpp

# GPU
## GLES
SRC += GPU/GLES/DepalettizeShaderGLES.cpp GPU/GLES/DepthBufferGLES.cpp GPU/GLES/GPU_GLES.cpp GPU/GLES/FragmentTestCacheGLES.cpp GPU/GLES/FramebufferManagerGLES.cpp GPU/GLES/ShaderManagerGLES.cpp GPU/GLES/StateMappingGLES.cpp GPU/GLES/StencilBufferGLES.cpp GPU/GLES/TextureCacheGLES.cpp GPU/GLES/TextureScalerGLES.cpp GPU/GLES/DrawEngineGLES.cpp
## Vulkan
SRC += GPU/Vulkan/DepalettizeShaderVulkan.cpp GPU/Vulkan/DebugVisVulkan.cpp GPU/Vulkan/DrawEngineVulkan.cpp GPU/Vulkan/FramebufferManagerVulkan.cpp GPU/Vulkan/GPU_Vulkan.cpp GPU/Vulkan/PipelineManagerVulkan.cpp GPU/Vulkan/ShaderManagerVulkan.cpp GPU/Vulkan/StateMappingVulkan.cpp GPU/Vulkan/StencilBufferVulkan.cpp GPU/Vulkan/TextureCacheVulkan.cpp GPU/Vulkan/TextureScalerVulkan.cpp GPU/Vulkan/VulkanUtil.cpp
## Common
SRC += GPU/Common/DepalettizeShaderCommon.cpp GPU/Common/FragmentShaderGenerator.cpp GPU/Common/VertexShaderGenerator.cpp GPU/Common/FramebufferManagerCommon.cpp GPU/Common/GPUDebugInterface.cpp GPU/Common/GPUStateUtils.cpp GPU/Common/DrawEngineCommon.cpp GPU/Common/PresentationCommon.cpp GPU/Common/ReinterpretFramebuffer.cpp GPU/Common/ShaderId.cpp GPU/Common/ShaderUniforms.cpp GPU/Common/ShaderCommon.cpp GPU/Common/SplineCommon.cpp GPU/Common/StencilCommon.cpp GPU/Common/SoftwareTransformCommon.cpp GPU/Common/VertexDecoderCommon.cpp GPU/Common/TransformCommon.cpp GPU/Common/IndexGenerator.cpp GPU/Common/TextureDecoder.cpp GPU/Common/TextureCacheCommon.cpp GPU/Common/TextureScalerCommon.cpp GPU/Common/PostShader.cpp GPU/Debugger/Breakpoints.cpp GPU/Debugger/Debugger.cpp GPU/Debugger/Playback.cpp GPU/Debugger/Record.cpp GPU/Debugger/Stepping.cpp GPU/GeConstants.cpp GPU/GeDisasm.cpp GPU/GPU.cpp GPU/GPUCommon.cpp GPU/GPUState.cpp GPU/Math3D.cpp GPU/Software/Clipper.cpp GPU/Software/Lighting.cpp GPU/Software/Rasterizer.cpp GPU/Software/RasterizerRectangle.cpp GPU/Software/Sampler.cpp GPU/Software/SoftGpu.cpp GPU/Software/TransformUnit.cpp

# End of core...
#SRC += ext/disarm.cpp git-version.cpp

# UI
# if(ARM) set(NativeAppSource ${NativeAppSource} android/jni/ArmEmitterTest.cpp)
# elseif(ARM64)	set(NativeAppSource ${NativeAppSource} android/jni/Arm64EmitterTest.cpp)
#SRC +=

LIBSRC = ${SRC}

#android/jni/TestRunner.cpp UI/DiscordIntegration.cpp
PROGSRC = UI/NativeApp.cpp UI/BackgroundAudio.cpp UI/ChatScreen.cpp UI/DevScreens.cpp UI/DisplayLayoutEditor.cpp UI/DisplayLayoutScreen.cpp UI/EmuScreen.cpp UI/GameInfoCache.cpp UI/MainScreen.cpp UI/MiscScreens.cpp UI/PauseScreen.cpp UI/GameScreen.cpp UI/GameSettingsScreen.cpp UI/GPUDriverTestScreen.cpp UI/TiltAnalogSettingsScreen.cpp UI/TiltEventProcessor.cpp UI/TouchControlLayoutScreen.cpp UI/TouchControlVisibilityScreen.cpp UI/GamepadEmu.cpp UI/OnScreenDisplay.cpp UI/ControlMappingScreen.cpp UI/RemoteISOScreen.cpp UI/ReportScreen.cpp UI/SavedataScreen.cpp UI/Store.cpp UI/CwCheatScreen.cpp UI/InstallZipScreen.cpp UI/ProfilerDraw.cpp UI/TextureUtil.cpp UI/ComboKeyMappingScreen.cpp
# SDL only
PROGSRC += SDL/SDLJoystick.cpp SDL/SDLGLGraphicsContext.cpp SDL/SDLVulkanGraphicsContext.cpp SDL/SDLMain.cpp
# Qt
#PROGSRC += Qt/QtMain.cpp Qt/QtHost.cpp Qt/mainwindow.cpp SDL/SDLJoystick.cpp
# Also uses SDL/SDLJoystick.cpp, when SDL is enabled...
# if(USING_GLES2) add_definitions(-DQT_OPENGL_ES -DQT_OPENGL_ES_2)

include make/exconf.noasm
include make/build

dist-clean: clean

clean-ext:
	rm -f ext/*.o ext/*/*.o
#clean-test:
#	rm -f audio/*.o audio/*/*.o common/*.o common/*/*.o core/*.o core/*/*.o core/*/*/*.o input/*.o network/*.o video/*.o video/*/*.o
#WEBSERVER
clean-web:
	rm -f Core/Debugger/WebSocket.o Core/Debugger/WebSocket/BreakpointSubscriber.o Core/Debugger/WebSocket/CPUCoreSubscriber.o Core/Debugger/WebSocket/DisasmSubscriber.o Core/Debugger/WebSocket/GameBroadcaster.o Core/Debugger/WebSocket/GameSubscriber.o Core/Debugger/WebSocket/GPUBufferSubscriber.o Core/Debugger/WebSocket/GPURecordSubscriber.o Core/Debugger/WebSocket/HLESubscriber.o Core/Debugger/WebSocket/InputBroadcaster.o Core/Debugger/WebSocket/InputSubscriber.o Core/Debugger/WebSocket/LogBroadcaster.o Core/Debugger/WebSocket/MemorySubscriber.o Core/Debugger/WebSocket/SteppingBroadcaster.o Core/Debugger/WebSocket/SteppingSubscriber.o Core/Debugger/WebSocket/WebSocketUtils.o Core/WebServer.o

#${PROGS}: ${PROGSRC:.cpp=.o}
#android/jni/TestRunner.o UI/DiscordIntegration.o
${PROGS}: UI/NativeApp.o UI/BackgroundAudio.o UI/ChatScreen.o UI/DevScreens.o UI/DisplayLayoutEditor.o UI/DisplayLayoutScreen.o UI/EmuScreen.o UI/GameInfoCache.o UI/MainScreen.o UI/MiscScreens.o UI/PauseScreen.o UI/GameScreen.o UI/GameSettingsScreen.o UI/GPUDriverTestScreen.o UI/TiltAnalogSettingsScreen.o UI/TiltEventProcessor.o UI/TouchControlLayoutScreen.o UI/TouchControlVisibilityScreen.o UI/GamepadEmu.o UI/OnScreenDisplay.o UI/ControlMappingScreen.o UI/RemoteISOScreen.o UI/ReportScreen.o UI/SavedataScreen.o UI/Store.o UI/CwCheatScreen.o UI/InstallZipScreen.o UI/ProfilerDraw.o UI/TextureUtil.o UI/ComboKeyMappingScreen.o SDL/SDLJoystick.o SDL/SDLGLGraphicsContext.o SDL/SDLVulkanGraphicsContext.o SDL/SDLMain.o
#Qt/QtMain.o Qt/QtHost.o Qt/mainwindow.o SDL/SDLJoystick.o

include make/pack
include make/rules
#include make/thedep
