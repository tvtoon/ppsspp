# en.UTF-8

This is a fork from PPSSPP ( https://github.com/hrydgard/ppsspp ), the PlayStation Portable emulator. The major changes are removing most useless features, to implement a proper debugger someday...

## ChangeLog cover...

First things first, this emulator needs a bunch of "assets" to display stuff properly, or even work (I don't know which ones are critical). The directory is not here for two reasons: there is a "source_assets" for most things, and I don't want to mess with the licensing of some stuff there, it does not seem proper. You have to get the directory from the original distribution, boring I know.

Fortunately, the changes were done easily, except for the Qt GUI that didn't work for the lack of some stuff, I don't know why, I really don't care because the "Native" GUI rocks and makes everything else useless. So, every single "dangerous" piece got some unique macro to enable the feature, the most offensive stuff was "armips", which sole purpose was to assemble opcode information for displaying on remote debugger, another one of those features. Other was discord, useless communication protocol kids love these days. Finally, the useless snappy had all its uselessness leveled: compress save and rewind (memory) states.

Useless stuff is now gone and most stuff seems to work without problems, I hope to do some core changes someday, but since the authoris still kicking that ass for so long, I don't know if it will be needed.

## Dependencies.

Some external dependencies are inside the tree, just to worry less about them. Only some stuff still bothers me, like 3 hash libraries for no good reason. For external ones, only libzip and zlib could get some optional macro, but since they are used for loading both UMD images and files inside them, we will see...

## Macros.

There are many useless definitions, and some conflicting ones, regarding the "USE_*" and "USING_*" ones. The emulator assumes too much stuff is Android-only trough them, misleading developers into some bad choices. It also forces a bunch of useless stuff, including system ones, for nothing! The only system macro used is "_FILE_OFFSET_BITS"(=64).

* "NDEBUG" or "_NDEBUG" are not used! The macro used is "_DEBUG"!
* "USE_FFMPEG" is the only "USE_*" relevant.
* "USING_GLES", not "USING_GLES2", was added to make GLES use optional, for testing other stuff.
* "GOLD", the paid version, only got a few switches different.
* "ASSETS_DIR" should always be set.
* "SHARED_LIBZIP" and "SHARED_ZLIB" to use the libraries.
* "USE_FFMPEG" is almost obligatory.
* Many "VK_USE_PLATFORM_*" switches got nothing to do with Vulkan, but how the OpenGL loading is done.
* Software GPU works flawless regardless macros used, because Vulkan is the last initializer before throwing some error.
* "SDL" is also used to set audio on Qt, otherwise it uses the Qt backend.
* New macros, for each feature: USE_WEBSERVER, USING_ARMIPS, USING_SNAPPY.
* "USE_DISCORD" got some general value now, but some inclusions still assume some platforms.
* Someday, "USING_FBDEV" will make sense...
