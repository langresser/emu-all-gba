#define thisModuleName "main"

#include "MDFNWrapper.hh"

#include <base/Base.hh>
#include <logger/interface.h>

#include <util/thread/pthread.hh>
#ifndef CONFIG_BASE_PS3
	#include <signal.h>
#endif

#include <stdarg.h>
#include <util/time/sys.hh>
#include <mem/interface.h>
#include <fs/sys.hh>
#include <util/strings.h>
#include "Option.hh"

extern FsSys::cPath sysCardPath;
extern Byte1Option optionArcadeCard;
#include <EmuSystem.hh>

MDFNGI *MDFNGameInfo = &EmulatedPCE_Fast;

#ifndef NDEBUG
void MDFN_printf(const char *format, ...) throw()
{
	#ifdef USE_LOGGER
	va_list args;
	va_start( args, format );
	logger_vprintf(LOG_M, format, args);
	va_end( args );
	#endif
}

void MDFN_PrintError(const char *format, ...) throw()
{
	#ifdef USE_LOGGER
	va_list args;
	va_start( args, format );
	logger_vprintf(LOG_E, format, args);
	va_end( args );
	#endif
}

void MDFN_DispMessage(const char *format, ...) throw()
{
	#ifdef USE_LOGGER
	va_list args;
	va_start( args, format );
	logger_vprintf(LOG_M, format, args);
	va_end( args );
	#endif
}
#endif

int MDFN_SavePNGSnapshot(const char *fname, const MDFN_Surface *src, const MDFN_Rect *rect, const MDFN_Rect *LineWidths)
{
	return 1;
}

void MDFN_ResetMessages(void) { }

struct MDFN_Thread : public ThreadPThread { };

MDFN_Thread *MDFND_CreateThread(void* (*fn)(void *), void *data)
{
	MDFN_Thread *thread = new MDFN_Thread();

	if(!thread || !thread->create(0, fn, data))
		goto FAIL;

	return thread;

	FAIL:
	if(thread)
	{
		delete thread;
	}
	return 0;
}

void MDFND_WaitThread(MDFN_Thread *thread, int *status)
{
	thread->join();
	delete thread;
}

struct MDFN_Mutex : public MutexPThread { };

MDFN_Mutex *MDFND_CreateMutex(void)
{
	MDFN_Mutex *mutex = new MDFN_Mutex();
	if(!mutex || !mutex->create())
		goto FAIL;

	return mutex;

	FAIL:
	if(mutex)
	{
		mutex->destroy();
		delete mutex;
	}
	return 0;
}

void MDFND_DestroyMutex(MDFN_Mutex *mutex)
{
	mutex->destroy();
	delete mutex;
}

int MDFND_LockMutex(MDFN_Mutex *mutex)
{
	//logMsg("lock %p", mutex);
	if(!mutex->lock())
	{
		return -1;
	}
	return 0;
}

int MDFND_UnlockMutex(MDFN_Mutex *mutex)
{
	//logMsg("unlock %p", mutex);
	if(!mutex->unlock())
	{
		return -1;
	}
	return 0;
}

#ifdef CONFIG_BASE_IOS

// Mach semaphores
#include <mach/semaphore.h>
#include <mach/task.h>
#include <mach/mach.h>

struct MDFN_Semaphore
{
	semaphore_t s;
};

MDFN_Semaphore *MDFND_CreateSemaphore(void)
{
	MDFN_Semaphore *semaphore = new MDFN_Semaphore();
	if(!semaphore || semaphore_create(mach_task_self(), &semaphore->s, SYNC_POLICY_FIFO, 0) != KERN_SUCCESS)
	{
		delete semaphore;
		return 0;
	}
	return semaphore;
}

void MDFND_DestroySemaphore(MDFN_Semaphore *semaphore)
{
	semaphore_destroy(mach_task_self(), semaphore->s);
	delete semaphore;
}

int MDFND_SignalSemaphore(MDFN_Semaphore *semaphore)
{
	return semaphore_signal(semaphore->s) == KERN_SUCCESS ? 0 : -1;
}

int MDFND_WaitSemaphore(MDFN_Semaphore *semaphore)
{
	return semaphore_wait(semaphore->s) == KERN_SUCCESS ? 0 : -1;
}

#else

// Posix semaphores
#include <semaphore.h>

struct MDFN_Semaphore
{
	sem_t s;
};

MDFN_Semaphore *MDFND_CreateSemaphore(void)
{
	MDFN_Semaphore *semaphore = new MDFN_Semaphore();
	if(!semaphore || sem_init(&semaphore->s, 0, 0) == -1)
	{
		delete semaphore;
		return 0;
	}
	return semaphore;
}

void MDFND_DestroySemaphore(MDFN_Semaphore *semaphore)
{
	sem_destroy(&semaphore->s);
	delete semaphore;
}

int MDFND_SignalSemaphore(MDFN_Semaphore *semaphore)
{
	return sem_post(&semaphore->s);
}

int MDFND_WaitSemaphore(MDFN_Semaphore *semaphore)
{
	return sem_wait(&semaphore->s);
}

#endif

void MDFND_Sleep(uint32 ms)
{
	// TODO eliminate sleep from CD-ROM code so this won't be needed
	Base::sleepUs(10);
}

void GetFileBase(const char *f) { }

std::string MDFN_MakeFName(MakeFName_Type type, int id1, const char *cd1)
{
	switch(type)
	{
		case MDFNMKF_STATE:
		case MDFNMKF_SAV:
		{
			assert(cd1);
			std::string path(EmuSystem::savePath());
			path += PSS;
			path += EmuSystem::gameName;
			path += ".";
			path += md5_context::asciistr(MDFNGameInfo->MD5, 0);
			path += ".";
			path += cd1;
			if(type == MDFNMKF_SAV) logMsg("created save path %s", path.c_str());
			return path;
		}
		case MDFNMKF_FIRMWARE:
		{
			// pce-specific
			logMsg("getting firmware path %s", sysCardPath);
			return std::string(sysCardPath);
		}
		case MDFNMKF_AUX:
		{
			std::string path(FsSys::workDir());
			path += PSS;
			path += cd1;
			logMsg("created aux path %s", path.c_str());
			return path;
		}
		default:
			bug_branch("%d", type);
			return 0;
	}
}

#define PCE_MODULE "pce_fast"

uint64 MDFN_GetSettingUI(const char *name)
{
	if(string_equal(PCE_MODULE".ocmultiplier", name))
		return 1;
	if(string_equal(PCE_MODULE".cdspeed", name))
		return 2;
	if(string_equal(PCE_MODULE".cdpsgvolume", name))
		return 100;
	if(string_equal(PCE_MODULE".cddavolume", name))
		return 100;
	if(string_equal(PCE_MODULE".adpcmvolume", name))
		return 100;
	if(string_equal(PCE_MODULE".slstart", name))
		return 4;
	if(string_equal(PCE_MODULE".slend", name))
		return 235;
	logMsg("unhandled settingUI %s", name);
	assert(0);
	return 0;
}

int64 MDFN_GetSettingI(const char *name)
{
	logMsg("unhandled settingI %s", name);
	assert(0);
	return 0;
}

float MDFN_GetSettingF(const char *name)
{
	if(string_equal(PCE_MODULE".mouse_sensitivity", name))
		return 0.50;
	logMsg("unhandled settingF %s", name);
	assert(0);
	return 0;
}

bool MDFN_GetSettingB(const char *name)
{
	if(string_equal("cheats", name))
		return 0;
	if(string_equal("filesys.disablesavegz", name))
		return 0;
	if(string_equal(PCE_MODULE".arcadecard", name))
		return optionArcadeCard;
	if(string_equal(PCE_MODULE".forcesgx", name))
		return 0;
	if(string_equal(PCE_MODULE".nospritelimit", name))
		return 0;
	if(string_equal(PCE_MODULE".forcemono", name))
		return 0;
	if(string_equal(PCE_MODULE".disable_softreset", name))
		return 0;
	if(string_equal(PCE_MODULE".adpcmlp", name))
		return 0;
	if(string_equal(PCE_MODULE".correct_aspect", name))
		return 1;
	if(string_equal("cdrom.lec_eval", name))
		return 1;
	if(string_equal("filesys.untrusted_fip_check", name))
		return 0;
	logMsg("unhandled settingB %s", name);
	assert(0);
	return 0;
}

std::string MDFN_GetSettingS(const char *name)
{
	if(string_equal(PCE_MODULE".cdbios", name))
	{
		return std::string("");
	}
	logMsg("unhandled settingS %s", name);
	assert(0);
	return 0;
}

void MDFN_indent(int indent) { }
bool MDFND_ExitBlockingLoop(void) { return 0; }
int MDFN_RawInputStateAction(StateMem *sm, int load, int data_only) { return 1; }
void MDFND_SetMovieStatus(StateStatusStruct *status) { }
void MDFND_SetStateStatus(StateStatusStruct *status) { }
void NetplaySendState(void) { }
void MDFND_NetplayText(const uint8 *text, bool NetEcho) { }

uint32 MDFND_GetTime(void)
{
	TimeSys time;
	time.setTimeNow();
	return (uint32)(time.divByUSecs(1000));
}

int Player_Init(int tsongs, UTF8 *album, UTF8 *artist, UTF8 *copyright, UTF8 **snames) { return 1; }
void Player_Draw(const MDFN_Surface *surface, MDFN_Rect *dr, int CurrentSong, int16 *samples, int32 sampcount) { }

int MDFNnetplay=0;

void MDFN_DoSimpleCommand(int cmd)
{
	emuSys->DoSimpleCommand(cmd);
}

void *MDFN_calloc_real(uint32 nmemb, uint32 size, const char *purpose, const char *_file, const int _line)
{
	return mem_calloc(nmemb, size);
}

void *MDFN_malloc_real(uint32 size, const char *purpose, const char *_file, const int _line)
{
	return mem_alloc(size);
}

void *MDFN_realloc_real(void *ptr, uint32 size, const char *purpose, const char *_file, const int _line)
{
	return mem_realloc(ptr, size);
}

void MDFN_free(void *ptr) { mem_free(ptr); }

/*void ErrnoHolder::SetErrno(int the_errno)
{
	logMsg("set errno %d", the_errno);
}*/

/*CLINK char *trio_vaprintf (const char *format, va_list args)
{
	return 0; //TODO
}

CLINK int trio_snprintf (char *buffer, size_t max, const char *format, ...)
{
	va_list args;
	va_start( args, format );
	int ret = vsnprintf(buffer, max, format, args);
	va_end( args );
	return ret;
}

CLINK int trio_fprintf (FILE *file, const char *format, ...)
{
	va_list args;
	va_start( args, format );
	int ret = vfprintf(file, format, args);
	va_end( args );
	return ret;
}

CLINK int trio_sscanf (const char *buffer, const char *format, ...)
{
	va_list args;
	va_start( args, format );
	int ret = vsscanf(buffer, format, args);
	va_end( args );
	return ret;
}

CLINK int trio_fscanf (FILE * stream, const char *format, ...)
{
	va_list args;
	va_start( args, format );
	int ret = vfscanf(stream, format, args);
	va_end( args );
	return ret;
}*/

namespace PCE_Fast
{
// dummy HES functions
int PCE_HESLoad(const uint8 *buf, uint32 size) { return 0; };
void HES_Draw(MDFN_Surface *surface, MDFN_Rect *DisplayRect, int16 *SoundBuf, int32 SoundBufSize) { }
void HES_Close(void) { }
void HES_Reset(void) { }
uint8 ReadIBP(unsigned int A) { return 0; }
};

#undef thisModuleName
