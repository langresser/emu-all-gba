#define thisModuleName "main"
#include <resource2/image/png/ResourceImagePng.h>
#include <logger/interface.h>
#include <util/area2.h>
#include <gfx/GfxSprite.hh>
#include <audio/Audio.hh>
#include <fs/sys.hh>
#include <io/sys.hh>
#include <gui/View.hh>
#include <util/strings.h>
#include <util/time/sys.hh>
#include <EmuSystem.hh>
#include <CommonFrameworkIncludes.hh>

#include <snes9x.h>
#ifndef SNES9X_VERSION_1_4
	#include <apu/apu.h>
	#include <controls.h>
#else
	#include <apu.h>
	#include <soundux.h>
#endif
#include <memmap.h>
#include <snapshot.h>

#ifndef SNES9X_VERSION_1_4

static const int SNES_AUTO_INPUT = 255;
static const int SNES_JOYPAD = CTL_JOYPAD;
static const int SNES_MOUSE_SWAPPED = CTL_MOUSE;
static const int SNES_SUPERSCOPE = CTL_SUPERSCOPE;
static int snesInputPort = SNES_AUTO_INPUT;
static int snesActiveInputPort = SNES_JOYPAD;

#else

static int snesInputPort = SNES_JOYPAD;
static const int &snesActiveInputPort = snesInputPort;

#endif

// controls

enum
{
	s9xKeyIdxUp = EmuControls::systemKeyMapStart,
	s9xKeyIdxRight,
	s9xKeyIdxDown,
	s9xKeyIdxLeft,
	s9xKeyIdxLeftUp,
	s9xKeyIdxRightUp,
	s9xKeyIdxRightDown,
	s9xKeyIdxLeftDown,
	s9xKeyIdxSelect,
	s9xKeyIdxStart,
	s9xKeyIdxA,
	s9xKeyIdxB,
	s9xKeyIdxX,
	s9xKeyIdxY,
	s9xKeyIdxL,
	s9xKeyIdxR,
	s9xKeyIdxATurbo,
	s9xKeyIdxBTurbo,
	s9xKeyIdxXTurbo,
	s9xKeyIdxYTurbo
};

enum {
	CFGKEY_MULTITAP = 276, CFGKEY_BLOCK_INVALID_VRAM_ACCESS = 277
};

static Byte1Option optionMultitap(CFGKEY_MULTITAP, 0);
#ifndef SNES9X_VERSION_1_4
static Byte1Option optionBlockInvalidVRAMAccess(CFGKEY_BLOCK_INVALID_VRAM_ACCESS, 1);
#endif

const uint EmuSystem::maxPlayers = 5;
uint EmuSystem::aspectRatioX = 4, EmuSystem::aspectRatioY = 3;
#include <CommonGui.hh>

void EmuSystem::initOptions()
{
	#ifndef CONFIG_BASE_ANDROID
	optionFrameSkip.initDefault(optionFrameSkipAuto); // auto-frameskip default due to highly variable CPU usage
	#endif
	#ifdef CONFIG_BASE_IOS
		if(Base::runningDeviceType() != Base::DEV_TYPE_IPAD)
	#endif
	{
			if(!Config::envIsWebOS3)
				optionTouchCtrlSize.initDefault(700);
	}
	optionTouchCtrlBtnSpace.initDefault(100);
	optionTouchCtrlBtnStagger.initDefault(5); // original SNES layout
}

bool EmuSystem::readConfig(Io *io, uint key, uint readSize)
{
	switch(key)
	{
		default: return 0;
		bcase CFGKEY_MULTITAP: optionMultitap.readFromIO(io, readSize);
		#ifndef SNES9X_VERSION_1_4
		bcase CFGKEY_BLOCK_INVALID_VRAM_ACCESS: optionBlockInvalidVRAMAccess.readFromIO(io, readSize);
		#endif
	}
	return 1;
}

void EmuSystem::writeConfig(Io *io)
{
	optionMultitap.writeWithKeyIfNotDefault(io);
	#ifndef SNES9X_VERSION_1_4
	optionBlockInvalidVRAMAccess.writeWithKeyIfNotDefault(io);
	#endif
}

static bool isROMExtension(const char *name)
{
	return string_hasDotExtension(name, "smc") ||
			string_hasDotExtension(name, "sfc") ||
			string_hasDotExtension(name, "fig") ||
			string_hasDotExtension(name, "1");
}

static bool isSNESExtension(const char *name)
{
	return isROMExtension(name) || string_hasDotExtension(name, "zip");
}

static int snesFsFilter(const char *name, int type)
{
	return type == Fs::TYPE_DIR || isSNESExtension(name);
}

FsDirFilterFunc EmuFilePicker::defaultFsFilter = snesFsFilter;
FsDirFilterFunc EmuFilePicker::defaultBenchmarkFsFilter = snesFsFilter;

static const PixelFormatDesc *pixFmt = &PixelFormatRGB565;

static int snesPointerX = 0, snesPointerY = 0, snesPointerBtns = 0, snesMouseClick = 0;

CLINK bool8 S9xReadMousePosition(int which, int &x, int &y, uint32 &buttons)
{
    if (which == 1)
    	return 0;

    //logMsg("reading mouse %d: %d %d %d, prev %d %d", which1_0_to_1, snesPointerX, snesPointerY, snesPointerBtns, IPPU.PrevMouseX[which1_0_to_1], IPPU.PrevMouseY[which1_0_to_1]);
    x = IG::scalePointRange((float)snesPointerX, (float)emuView.gameView.iXSize, (float)256.);
    y = IG::scalePointRange((float)snesPointerY, (float)emuView.gameView.iYSize, (float)224.);
    buttons = snesPointerBtns;

    if(snesMouseClick)
    	snesMouseClick--;
    if(snesMouseClick == 1)
    {
    	//logDMsg("ending click");
    	snesPointerBtns = 0;
    }

    return 1;
}

CLINK bool8 S9xReadSuperScopePosition(int &x, int &y, uint32 &buttons)
{
	//logMsg("reading super scope: %d %d %d", snesPointerX, snesPointerY, snesPointerBtns);
	x = snesPointerX;
	y = snesPointerY;
	buttons = snesPointerBtns;
	return 1;
}

#ifndef SNES9X_VERSION_1_4
uint16 *S9xGetJoypadBits(uint idx);
uint8 *S9xGetMouseBits(uint idx);
uint8 *S9xGetMouseDeltaBits(uint idx);
int16 *S9xGetMousePosBits(uint idx);
int16 *S9xGetSuperscopePosBits();
uint8 *S9xGetSuperscopeBits();
#else
static uint16 joypadData[5];
static uint16 *S9xGetJoypadBits(uint idx)
{
	return &joypadData[idx];
}

CLINK uint32 S9xReadJoypad(int which)
{
	assert(which < 5);
	//logMsg("reading joypad %d", which);
	return 0x80000000 | joypadData[which];
}

bool JustifierOffscreen()
{
	return false;
}

void JustifierButtons(uint32& justifiers) { }

static bool usingMouse() { return IPPU.Controller == SNES_MOUSE_SWAPPED; }
static bool usingGun() { return IPPU.Controller == SNES_SUPERSCOPE; }

#endif

static uint doubleClickFrames, rightClickFrames;
static ContentDrag mouseScroll;

void updateVControllerMapping(uint player, SysVController::Map &map)
{
	uint playerMask = player << 29;
	map[SysVController::F_ELEM] = SNES_A_MASK | playerMask;
	map[SysVController::F_ELEM+1] = SNES_B_MASK | playerMask;
	map[SysVController::F_ELEM+2] = SNES_X_MASK | playerMask;
	map[SysVController::F_ELEM+3] = SNES_Y_MASK | playerMask;
	map[SysVController::F_ELEM+4] = SNES_TL_MASK | playerMask;
	map[SysVController::F_ELEM+5] = SNES_TR_MASK | playerMask;

	map[SysVController::C_ELEM] = SNES_SELECT_MASK | playerMask;
	map[SysVController::C_ELEM+1] = SNES_START_MASK | playerMask;

	map[SysVController::D_ELEM] = SNES_UP_MASK | SNES_LEFT_MASK | playerMask;
	map[SysVController::D_ELEM+1] = SNES_UP_MASK | playerMask;
	map[SysVController::D_ELEM+2] = SNES_UP_MASK | SNES_RIGHT_MASK | playerMask;
	map[SysVController::D_ELEM+3] = SNES_LEFT_MASK | playerMask;
	map[SysVController::D_ELEM+5] = SNES_RIGHT_MASK | playerMask;
	map[SysVController::D_ELEM+6] = SNES_DOWN_MASK | SNES_LEFT_MASK | playerMask;
	map[SysVController::D_ELEM+7] = SNES_DOWN_MASK | playerMask;
	map[SysVController::D_ELEM+8] = SNES_DOWN_MASK | SNES_RIGHT_MASK | playerMask;
}

uint EmuSystem::translateInputAction(uint input, bool &turbo)
{
	turbo = 0;
	assert(input >= s9xKeyIdxUp);
	uint player = (input - s9xKeyIdxUp) / EmuControls::gamepadKeys;
	uint playerMask = player << 29;
	input -= EmuControls::gamepadKeys * player;
	switch(input)
	{
		case s9xKeyIdxUp: return SNES_UP_MASK | playerMask;
		case s9xKeyIdxRight: return SNES_RIGHT_MASK | playerMask;
		case s9xKeyIdxDown: return SNES_DOWN_MASK | playerMask;
		case s9xKeyIdxLeft: return SNES_LEFT_MASK | playerMask;
		case s9xKeyIdxLeftUp: return SNES_LEFT_MASK | SNES_UP_MASK | playerMask;
		case s9xKeyIdxRightUp: return SNES_RIGHT_MASK | SNES_UP_MASK | playerMask;
		case s9xKeyIdxRightDown: return SNES_RIGHT_MASK | SNES_DOWN_MASK | playerMask;
		case s9xKeyIdxLeftDown: return SNES_LEFT_MASK | SNES_DOWN_MASK | playerMask;
		case s9xKeyIdxSelect: return SNES_SELECT_MASK | playerMask;
		case s9xKeyIdxStart: return SNES_START_MASK | playerMask;
		case s9xKeyIdxXTurbo: turbo = 1;
		case s9xKeyIdxX: return SNES_X_MASK | playerMask;
		case s9xKeyIdxYTurbo: turbo = 1;
		case s9xKeyIdxY: return SNES_Y_MASK | playerMask;
		case s9xKeyIdxATurbo: turbo = 1;
		case s9xKeyIdxA: return SNES_A_MASK | playerMask;
		case s9xKeyIdxBTurbo: turbo = 1;
		case s9xKeyIdxB: return SNES_B_MASK | playerMask;
		case s9xKeyIdxL: return SNES_TL_MASK | playerMask;
		case s9xKeyIdxR: return SNES_TR_MASK | playerMask;
		default: bug_branch("%d", input);
	}
	return 0;
}

void EmuSystem::handleInputAction(uint state, uint emuKey)
{
	uint player = emuKey >> 29; // player is encoded in upper 3 bits of input code
	assert(player < maxPlayers);
	auto padData = S9xGetJoypadBits(player);
	if(state == Input::PUSHED)
		setBits(*padData, emuKey & 0xFFFF);
	else
		unsetBits(*padData, emuKey & 0xFFFF);
}

static int snesResX = 256, snesResY = 224;

static bool renderToScreen = 0;

#ifndef SNES9X_VERSION_1_4
bool8 S9xDeinitUpdate (int width, int height)
#else
bool8 S9xDeinitUpdate(int width, int height, bool8)
#endif
{
	if(likely(renderToScreen))
	{
		if(unlikely(snesResX != width || snesResY != height))
		{
			if(snesResX == width && snesResY < 240 && height < 240)
			{
				//logMsg("ignoring vertical screen res change for now");
			}
			else
			{
				logMsg("resolution changed to %d,%d", width, height);
				snesResX = width;
				snesResY = height;
				emuView.resizeImage(snesResX, snesResY);
			}
		}

		emuView.updateAndDrawContent();
		renderToScreen = 0;
	}
	else
	{
		//logMsg("skipping render");
	}

	return 1;
}

void EmuSystem::resetGame()
{
	assert(gameIsRunning());
	S9xSoftReset();
}

static char saveSlotChar(int slot)
{
	switch(slot)
	{
		case -1: return 'A';
		case 0 ... 9: return 48 + slot;
		default: bug_branch("%d", slot); return 0;
	}
}

#ifndef SNES9X_VERSION_1_4
	#define FREEZE_EXT "frz"
#else
	#define FREEZE_EXT "s96"
#endif

void EmuSystem::sprintStateFilename(char *str, size_t size, int slot, const char *statePath, const char *gameName)
{
	snprintf(str, size, "%s/%s.0%c." FREEZE_EXT, statePath, gameName, saveSlotChar(slot));
}

#undef FREEZE_EXT

template <size_t S>
static void sprintSRAMFilename(char (&str)[S])
{
	snprintf(str, S, "%s/%s.srm", EmuSystem::savePath(), EmuSystem::gameName);
}

int EmuSystem::saveState()
{
	FsSys::cPath saveStr;
	sprintStateFilename(saveStr, saveStateSlot);
	#ifdef CONFIG_BASE_IOS_SETUID
		fixFilePermissions(saveStr);
	#endif
	if(!S9xFreezeGame(saveStr))
		return STATE_RESULT_IO_ERROR;
	else
		return STATE_RESULT_OK;
}

int EmuSystem::loadState(int saveStateSlot)
{
	FsSys::cPath saveStr;
	sprintStateFilename(saveStr, saveStateSlot);
	if(FsSys::fileExists(saveStr))
	{
		logMsg("loading state %s", saveStr);
		if(S9xUnfreezeGame(saveStr))
		{
			IPPU.RenderThisFrame = TRUE;
			return STATE_RESULT_OK;
		}
		else
			return STATE_RESULT_IO_ERROR;
	}
	return STATE_RESULT_NO_FILE;
}

void EmuSystem::saveBackupMem() // for manually saving when not closing game
{
	if(gameIsRunning() && CPU.SRAMModified)
	{
		logMsg("saving backup memory");
		FsSys::cPath saveStr;
		sprintSRAMFilename(saveStr);
		#ifdef CONFIG_BASE_IOS_SETUID
			fixFilePermissions(saveStr);
		#endif
		Memory.SaveSRAM(saveStr);
	}
}

void EmuSystem::saveAutoState()
{
	if(gameIsRunning() && optionAutoSaveState)
	{
		FsSys::cPath saveStr;
		sprintStateFilename(saveStr, -1);
		#ifdef CONFIG_BASE_IOS_SETUID
			fixFilePermissions(saveStr);
		#endif
		if(!S9xFreezeGame(saveStr))
			logMsg("error saving state %s", saveStr);
	}
}

void S9xAutoSaveSRAM (void)
{
	EmuSystem::saveBackupMem();
}

void EmuSystem::closeSystem()
{
	saveBackupMem();
}

bool EmuSystem::vidSysIsPAL() { return 0; }
bool touchControlsApplicable() { return snesActiveInputPort == SNES_JOYPAD; }

static void setupSNESInput()
{
	#ifndef SNES9X_VERSION_1_4
	int inputSetup = snesInputPort;
	if(inputSetup == SNES_AUTO_INPUT)
	{
		inputSetup = SNES_JOYPAD;
		if(EmuSystem::gameIsRunning() && !strncmp((const char *) Memory.NSRTHeader + 24, "NSRT", 4))
		{
			switch (Memory.NSRTHeader[29])
			{
				case 0x00:	// Everything goes
				break;

				case 0x10:	// Mouse in Port 0
				inputSetup = SNES_MOUSE_SWAPPED;
				break;

				case 0x01:	// Mouse in Port 1
				inputSetup = SNES_MOUSE_SWAPPED;
				break;

				case 0x03:	// Super Scope in Port 1
				inputSetup = SNES_SUPERSCOPE;
				break;

				case 0x06:	// Multitap in Port 1
				//S9xSetController(1, CTL_MP5,        1, 2, 3, 4);
				break;

				case 0x66:	// Multitap in Ports 0 and 1
				//S9xSetController(0, CTL_MP5,        0, 1, 2, 3);
				//S9xSetController(1, CTL_MP5,        4, 5, 6, 7);
				break;

				case 0x08:	// Multitap in Port 1, Mouse in new Port 1
				inputSetup = SNES_MOUSE_SWAPPED;
				break;

				case 0x04:	// Pad or Super Scope in Port 1
				inputSetup = SNES_SUPERSCOPE;
				break;

				case 0x05:	// Justifier - Must ask user...
				//S9xSetController(1, CTL_JUSTIFIER,  1, 0, 0, 0);
				break;

				case 0x20:	// Pad or Mouse in Port 0
				inputSetup = SNES_MOUSE_SWAPPED;
				break;

				case 0x22:	// Pad or Mouse in Port 0 & 1
				inputSetup = SNES_MOUSE_SWAPPED;
				break;

				case 0x24:	// Pad or Mouse in Port 0, Pad or Super Scope in Port 1
				// There should be a toggles here for what to put in, I'm leaving it at gamepad for now
				break;

				case 0x27:	// Pad or Mouse in Port 0, Pad or Mouse or Super Scope in Port 1
				// There should be a toggles here for what to put in, I'm leaving it at gamepad for now
				break;

				// Not Supported yet
				case 0x99:	// Lasabirdie
				break;

				case 0x0A:	// Barcode Battler
				break;
			}
		}
		if(inputSetup != SNES_JOYPAD)
			logMsg("using automatic input %d", inputSetup);
	}

	if(inputSetup == SNES_MOUSE_SWAPPED)
	{
		S9xSetController(0, CTL_MOUSE, 0, 0, 0, 0);
		S9xSetController(1, CTL_JOYPAD, 1, 0, 0, 0);
		logMsg("setting mouse input");
	}
	else if(inputSetup == SNES_SUPERSCOPE)
	{
		S9xSetController(0, CTL_JOYPAD, 0, 0, 0, 0);
		S9xSetController(1, CTL_SUPERSCOPE, 0, 0, 0, 0);
		logMsg("setting superscope input");
	}
	else // Joypad
	{
		if(optionMultitap)
		{
			S9xSetController(0, CTL_JOYPAD, 0, 0, 0, 0);
			S9xSetController(1, CTL_MP5, 1, 2, 3, 4);
			logMsg("setting 5-player joypad input");
		}
		else
		{
			S9xSetController(0, CTL_JOYPAD, 0, 0, 0, 0);
			S9xSetController(1, CTL_JOYPAD, 1, 0, 0, 0);
		}
	}
	snesActiveInputPort = inputSetup;
	#else
	Settings.MultiPlayer5Master = Settings.MultiPlayer5 = 0;
	Settings.MouseMaster = Settings.Mouse = 0;
	Settings.SuperScopeMaster = Settings.SuperScope = 0;
	Settings.Justifier = Settings.SecondJustifier = 0;
	if(snesInputPort == SNES_JOYPAD && optionMultitap)
	{
		logMsg("connected multitap");
		Settings.MultiPlayer5Master = Settings.MultiPlayer5 = 1;
		Settings.ControllerOption = IPPU.Controller = SNES_MULTIPLAYER5;
	}
	else
	{
		if(snesInputPort == SNES_MOUSE_SWAPPED)
		{
			logMsg("connected mouse");
			Settings.MouseMaster = Settings.Mouse = 1;
			Settings.ControllerOption = IPPU.Controller = SNES_MOUSE_SWAPPED;
		}
		else if(snesInputPort == SNES_SUPERSCOPE)
		{
			logMsg("connected superscope");
			Settings.SuperScopeMaster = Settings.SuperScope = 1;
			Settings.ControllerOption = IPPU.Controller = SNES_SUPERSCOPE;
		}
		else
		{
			logMsg("connected joypads");
			IPPU.Controller = SNES_JOYPAD;
		}
	}
	#endif
}

int EmuSystem::loadGame(const char *path)
{
	closeGame();
	emuView.initImage(0, snesResX, snesResY);
	setupGamePaths(path);

	if(!Memory.LoadROM(fullGamePath))
	{
		logMsg("failed to load game");
		popup.postError("Error loading game");
		return 0;
	}
	setupSNESInput();

	FsSys::cPath saveStr;
	sprintSRAMFilename(saveStr);
	Memory.LoadSRAM(saveStr);

	IPPU.RenderThisFrame = TRUE;
	EmuSystem::configAudioRate();
	logMsg("finished loading game");
	return 1;
}

void EmuSystem::clearInputBuffers()
{
	iterateTimes((uint)maxPlayers, p)
	{
		*S9xGetJoypadBits(p) = 0;
	}
	snesPointerBtns = 0;
	doubleClickFrames = 0;
	mouseScroll.init(ContentDrag::XY_AXIS);
	mouseScroll.dragStartY = IG::max(1, Gfx::yMMSizeToPixel(1.));
	mouseScroll.dragStartX = IG::max(1, Gfx::xMMSizeToPixel(1.));
}

void EmuSystem::configAudioRate()
{
	pcmFormat.rate = optionSoundRate;
	Settings.SoundPlaybackRate = optionSoundRate;
	#if defined(CONFIG_ENV_WEBOS)
	if(optionFrameSkip != optionFrameSkipAuto)
		Settings.SoundPlaybackRate = (float)optionSoundRate * (42660./44100.); // better sync with Pre's refresh rate
	#endif
	#ifndef SNES9X_VERSION_1_4
	S9xUpdatePlaybackRate();
	#else
	S9xSetPlaybackRate(Settings.SoundPlaybackRate);
	#endif
	logMsg("emu sound rate %d", Settings.SoundPlaybackRate);
}

static void doS9xAudio(bool renderAudio)
{
	#ifndef SNES9X_VERSION_1_4
		const uint samples = S9xGetSampleCount();
	#else
		const uint samples = Settings.SoundPlaybackRate*2 / 60;
	#endif
	uint frames = samples/2;

	int16 audioMemBuff[samples];
	int16 *audioBuff = nullptr;
	#ifdef USE_NEW_AUDIO
		Audio::BufferContext *aBuff = nullptr;
		if(renderAudio)
		{
			if(!(aBuff = Audio::getPlayBuffer(frames)))
			{
				return;
			}
			audioBuff = (int16*)aBuff->data;
			assert(aBuff->frames >= frames);
		}
		else
		{
			audioBuff = audioMemBuff;
		}
	#else
		audioBuff = audioMemBuff;
	#endif


	#ifndef SNES9X_VERSION_1_4
		if(!S9xMixSamples((uint8_t*)audioBuff, samples))
		{
			logMsg("not enough samples ready from SNES");
		}
		else
	#else
		S9xMixSamples((uint8_t*)audioBuff, samples);
	#endif

	#ifdef USE_NEW_AUDIO
		if(renderAudio)
			Audio::commitPlayBuffer(aBuff, frames);
	#else
		if(renderAudio)
			Audio::writePcm((uchar*)audioBuff, frames);
	#endif
}

void EmuSystem::runFrame(bool renderGfx, bool processGfx, bool renderAudio)
{
	if(unlikely(snesActiveInputPort != SNES_JOYPAD))
	{
		if(doubleClickFrames)
			doubleClickFrames--;
		if(rightClickFrames)
			rightClickFrames--;

		#ifndef SNES9X_VERSION_1_4
		switch(snesActiveInputPort)
		{
			bcase SNES_MOUSE_SWAPPED:
			{
				int x,y;
				uint32 buttons;
				S9xReadMousePosition(0, x, y, buttons);
				*S9xGetMouseBits(0) &= ~(0x40 | 0x80);
				if(buttons == 1)
					*S9xGetMouseBits(0) |= 0x40;
				else if(buttons == 2)
					*S9xGetMouseBits(0) |= 0x80;
				S9xGetMousePosBits(0)[0] = x;
				S9xGetMousePosBits(0)[1] = y;
			}
		}
		#endif
	}

	IPPU.RenderThisFrame = processGfx ? TRUE : FALSE;
	if(renderGfx)
		renderToScreen = 1;
	S9xMainLoop();
	// video rendered in S9xDeinitUpdate
	doS9xAudio(renderAudio);
}

void EmuSystem::savePathChanged() { }

namespace Input
{
void onInputEvent(const Input::Event &e)
{
	if(unlikely(EmuSystem::isActive() && e.isPointer()))
	{
		switch(snesActiveInputPort)
		{
			bcase SNES_SUPERSCOPE:
			{
				if(e.state == RELEASED)
				{
					snesPointerBtns = 0;
					#ifndef SNES9X_VERSION_1_4
					*S9xGetSuperscopeBits() = 0;
					#endif
				}
				if(emuView.gameView.overlaps(e.x, e.y))
				{
					int xRel = e.x - emuView.gameView.xIPos(LT2DO), yRel = e.y - emuView.gameView.yIPos(LT2DO);
					snesPointerX = IG::scalePointRange((float)xRel, (float)emuView.gameView.iXSize, (float)256.);
					snesPointerY = IG::scalePointRange((float)yRel, (float)emuView.gameView.iYSize, (float)224.);
					//logMsg("mouse moved to @ %d,%d, on SNES %d,%d", e.x, e.y, snesPointerX, snesPointerY);
					if(e.state == PUSHED)
					{
						snesPointerBtns = 1;
						#ifndef SNES9X_VERSION_1_4
						*S9xGetSuperscopeBits() = 0x80;
						#endif
					}
				}
				else if(e.state == PUSHED)
				{
					snesPointerBtns = 2;
					#ifndef SNES9X_VERSION_1_4
					*S9xGetSuperscopeBits() = 0x40;
					#endif
				}

				#ifndef SNES9X_VERSION_1_4
				S9xGetSuperscopePosBits()[0] = snesPointerX;
				S9xGetSuperscopePosBits()[1] = snesPointerY;
				#endif
			}

			bcase SNES_MOUSE_SWAPPED:
			{
				auto dragState = Input::dragState(e.devId);
				static bool dragWithButton = 0; // true to start next mouse drag with a button held
				switch(mouseScroll.inputEvent(Gfx::viewportRect(), e))
				{
					bcase ContentDrag::PUSHED:
					{
						rightClickFrames = 15;
						if(doubleClickFrames) // check if in double-click time window
						{
							dragWithButton = 1;
						}
						else
						{
							dragWithButton = 0;
							doubleClickFrames = 15;
						}
					}

					bcase ContentDrag::ENTERED_ACTIVE:
					{
						if(dragWithButton)
						{
							snesMouseClick = 0;
							if(!rightClickFrames)
							{
								// in right-click time window
								snesPointerBtns = 2;
								logMsg("started drag with right-button");
							}
							else
							{
								snesPointerBtns = 1;
								logMsg("started drag with left-button");
							}
						}
						else
						{
							logMsg("started drag");
						}
					}

					bcase ContentDrag::LEFT_ACTIVE:
					{
						logMsg("stopped drag");
						snesPointerBtns = 0;
					}

					bcase ContentDrag::ACTIVE:
					{
						snesPointerX += dragState->relX();
						snesPointerY += dragState->relY();
					}

					bcase ContentDrag::RELEASED:
					{
						if(!rightClickFrames)
						{
							logMsg("right clicking mouse");
							snesPointerBtns = 2;
							doubleClickFrames = 15; // allow extra time for a right-click & drag
						}
						else
						{
							logMsg("left clicking mouse");
							snesPointerBtns = 1;
						}
						snesMouseClick = 3;
					}

					bdefault: break;
				}
			}
		}
	}
	handleInputEvent(e);
}
}

namespace Base
{

void onAppMessage(int type, int shortArg, int intArg, int intArg2) { }

CallResult onInit(int argc, char** argv)
{
	Audio::setHintPcmFramesPerWrite(950); // for PAL when supported
	static uint16 screenBuff[512*478] __attribute__ ((aligned (8)));
	#ifndef SNES9X_VERSION_1_4
		GFX.Screen = screenBuff;
	#else
		GFX.Screen = (uint8*)screenBuff;
	#endif

	Memory.Init();
	S9xGraphicsInit();
	S9xInitAPU();
	assert(Settings.Stereo == TRUE);
	#ifndef SNES9X_VERSION_1_4
		S9xInitSound(20, 0);
		S9xUnmapAllControls();
		Settings.BlockInvalidVRAMAccessMaster = optionBlockInvalidVRAMAccess;
	#else
		S9xInitSound(Settings.SoundPlaybackRate, Settings.Stereo, 0);
		assert(Settings.FrameTime == Settings.FrameTimeNTSC);
		assert(Settings.H_Max == SNES_CYCLES_PER_SCANLINE);
		assert(Settings.HBlankStart == (256 * Settings.H_Max) / SNES_HCOUNTER_MAX);
	#endif

	mainInitCommon();
	emuView.initPixmap((uchar*)GFX.Screen, pixFmt, snesResX, snesResY);
	return OK;
}

CallResult onWindowInit()
{
	static const Gfx::LGradientStopDesc navViewGrad[] =
	{
		{ .0, VertexColorPixelFormat.build(.5, .5, .5, 1.) },
		{ .03, VertexColorPixelFormat.build((139./255.) * .4, (149./255.) * .4, (230./255.) * .4, 1.) },
		{ .3, VertexColorPixelFormat.build((139./255.) * .4, (149./255.) * .4, (230./255.) * .4, 1.) },
		{ .97, VertexColorPixelFormat.build((46./255.) * .4, (50./255.) * .4, (77./255.) * .4, 1.) },
		{ 1., VertexColorPixelFormat.build(.5, .5, .5, 1.) },
	};

	mainInitWindowCommon(navViewGrad);
	return OK;
}

}
