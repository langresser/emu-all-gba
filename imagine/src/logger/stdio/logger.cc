/*  This file is part of Imagine.

	Imagine is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	Imagine is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with Imagine.  If not, see <http://www.gnu.org/licenses/> */

#define thisModuleName "logger:stdio"
#include <engine-globals.h>
#include <base/Base.hh>
#include <logger/interface.h>

#include <stdarg.h>
#include <stdio.h>

#ifdef CONFIG_BASE_ANDROID
	#include <android/log.h>
#endif

static const bool bufferLogLineOutput = Config::envIsAndroid || Config::envIsIOS;
static char logLineBuffer[512] {0};
uint loggerVerbosity = loggerMaxVerbosity;

static const bool useExternalLogFile = 0;
static FILE *logExternalFile = nullptr;

static const char *externalLogPath()
{
	#ifdef CONFIG_BASE_IOS
		const char *prefix = "/var/mobile";
	#elif defined(CONFIG_BASE_ANDROID)
		const char *prefix = Base::documentsPath();
	#elif defined(CONFIG_ENV_WEBOS)
		const char *prefix = "/media/internal";
	#else
		const char *prefix = ".";
	#endif

	static char path[128] = "";
	if(!strlen(path))
	{
		sprintf(path, "%s/imagine.log", prefix);
	}
	return path;
}

CallResult logger_init()
{
	if(useExternalLogFile)
	{
		logMsg("external log file: %s", externalLogPath());
		logExternalFile = fopen(externalLogPath(), "wb");
		if(!logExternalFile)
		{
			return IO_ERROR;
		}
	}

	return OK;
}

static void printToLogLineBuffer(const char* msg, va_list args)
{
	vsnprintf(logLineBuffer + strlen(logLineBuffer), sizeof(logLineBuffer) - strlen(logLineBuffer), msg, args);
}

void logger_vprintf(LoggerSeverity severity, const char* msg, va_list args)
{
	if(severity > loggerVerbosity) return;

	if(logExternalFile)
	{
		va_list args2;
		va_copy(args2, args);
		vfprintf(logExternalFile, msg, args2);
		va_end(args2);
		fflush(logExternalFile);
	}

	if(bufferLogLineOutput && !strchr(msg, '\n'))
	{
		printToLogLineBuffer(msg, args);
		return;
	}

	#ifdef CONFIG_BASE_ANDROID
		if(strlen(logLineBuffer))
		{
			printToLogLineBuffer(msg, args);
			__android_log_write(ANDROID_LOG_INFO, "imagine", logLineBuffer);
			logLineBuffer[0] = 0;
		}
		else
			__android_log_vprint(ANDROID_LOG_INFO, "imagine", msg, args);
	#elif defined(CONFIG_BASE_IOS)
		if(strlen(logLineBuffer))
		{
			printToLogLineBuffer(msg, args);
			printf("%s\n", logLineBuffer);
			logLineBuffer[0] = 0;
		}
		else {
			vfprintf(stderr, msg, args);
        }
	#else
		vfprintf(stderr, msg, args);
	#endif
}

void logger_printf(LoggerSeverity severity, const char* msg, ...)
{
	va_list args;
	va_start(args, msg);
	logger_vprintf(severity, msg, args);
	va_end(args);
}
