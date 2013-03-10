#pragma once
#include <input/Input.hh>
#include <input/common/common.h>
#include <input/DragPointer.hh>

namespace Input
{

static struct TouchState
{
	constexpr TouchState() { }
	UITouch *touch = nil;
	PointerState s;
	DragPointer dragState;
} m[maxCursors];
uint numCursors = maxCursors;

DragPointer *dragState(int p)
{
	return &m[p].dragState;
}

int cursorX(int p) { return m[p].s.x; }
int cursorY(int p) { return m[p].s.y; }
int cursorIsInView(int p) { return m[p].s.inWin; }

bool Device::anyTypeBitsPresent(uint typeBits)
{
#ifdef CONFIG_INPUT_ICADE
	if(typeBits & TYPE_BIT_GAMEPAD)
	{
		// A gamepad is present if iCade mode is in use on the iCade device (always first device)
		// or the device list size is not 1 due to BTstack connections from other controllers
		return devList.first()->iCadeMode_ || devList.size != 1;
	}
#endif
	// no other device types supported
	return 0;
}

void setKeyRepeat(bool on)
{
	// TODO
}

CallResult init()
{
	#if defined CONFIG_INPUT_ICADE
	addDevice(Device{0, Event::MAP_ICADE, Device::TYPE_BIT_KEY_MISC, "iCade Controller"});
	#endif
	return OK;
}

}
