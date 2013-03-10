#define thisModuleName "base:iphone"

#import "MainApp.h"
#import "EAGLView.h"
#import <dlfcn.h>
#import <unistd.h>

#include <base/Base.hh>
#include <fs/sys.hh>
#include <util/time/sys.hh>
#include <base/common/funcs.h>

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>
#import <Foundation/NSPathUtilities.h>

#include "platform_util.h"

namespace Base
{
	static UIWindow *devWindow;
	static int pointScale = 1;
	static MainApp *mainApp;
}

static CGAffineTransform makeTransformForOrientation(uint orientation)
{
	using namespace Gfx;
	switch(orientation)
	{
		default: return CGAffineTransformIdentity;
		case VIEW_ROTATE_270: return CGAffineTransformMakeRotation(3*M_PI / 2.0);
		case VIEW_ROTATE_90: return CGAffineTransformMakeRotation(M_PI / 2.0);
		case VIEW_ROTATE_180: return CGAffineTransformMakeRotation(M_PI);
	}
}

#ifdef CONFIG_INPUT
	#include "input.h"
#endif

#ifdef CONFIG_INPUT_ICADE
	#include "ICadeHelper.hh"
#endif

namespace Base
{

struct ThreadMsg
{
	int16 type;
	int16 shortArg;
	int intArg;
	int intArg2;
};

const char *appPath = 0;
static UIWindow *externalWindow = 0;
static EAGLView *glView;
static EAGLContext *mainContext;
static CADisplayLink *displayLink = 0;
static BOOL displayLinkActive = NO;
static bool isIPad = 0;
#ifdef __ARM_ARCH_6K__
static bool usingiOS4 = 0;
#else
static const bool usingiOS4 = 1; // always on iOS 4.3+ when compiled for ARMv7
#endif
;
#ifdef CONFIG_INPUT_ICADE
static ICadeHelper iCade = { nil };
#endif

// used on iOS 4.0+
static UIViewController *viewCtrl;

static const int USE_DEPTH_BUFFER = 0;
static int openglViewIsInit = 0;

void cancelCallback(CallbackRef *ref)
{
	if(ref)
	{
		logMsg("cancelling callback with ref %p", ref);
		[NSObject cancelPreviousPerformRequestsWithTarget:mainApp selector:@selector(timerCallback:) object:(__bridge id)ref];
	}
}

CallbackRef *callbackAfterDelay(CallbackDelegate callback, int ms)
{
	logMsg("setting callback to run in %d ms", ms);
	CallbackDelegate del(callback);
	NSData *callbackArg = [[NSData alloc] initWithBytes:&del length:sizeof(del)];
	assert(callbackArg);
	[mainApp performSelector:@selector(timerCallback:) withObject:(id)callbackArg afterDelay:(float)ms/1000.];
	return (__bridge CallbackRef*)callbackArg;
}

void openGLUpdateScreen()
{
	[Base::mainContext presentRenderbuffer:GL_RENDERBUFFER_OES];
}

void startAnimation()
{
	if(!Base::displayLinkActive)
	{
		displayLink.paused = NO; 
		Base::displayLinkActive = YES;
	}
}

void stopAnimation()
{
	if(Base::displayLinkActive)
	{
		displayLink.paused = YES;
		Base::displayLinkActive = NO;
	}
}

uint appState = APP_RUNNING;

}

@interface ImagineUIViewController : UIViewController

@end

@implementation ImagineUIViewController

- (BOOL)shouldAutorotate
{
	return NO;
}

@end

// A class extension to declare private methods
@interface EAGLView ()

@property (nonatomic, retain) EAGLContext *context;

- (BOOL) createFramebuffer;
- (void) destroyFramebuffer;

@end

@implementation EAGLView

@synthesize context;

// Implement this to override the default layer class (which is [CALayer class]).
// We do this so that our view will be backed by a layer that is capable of OpenGL ES rendering.
+ (Class)layerClass
{
	return [CAEAGLLayer class];
}

-(id)initGLES
{
	CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;

	#if !defined(__ARM_ARCH_6K__)
	using namespace Base;
	if(usingiOS4)
	{
		logMsg("testing for Retina Display");
		if([UIScreen mainScreen].scale == 2.0)
		{
			logMsg("running on Retina Display");
			eaglLayer.contentsScale = 2.0;
			pointScale = 2;
			mainWin.rect.x2 *= 2;
			mainWin.rect.y2 *= 2;
			mainWin.w *= 2;
			mainWin.h *= 2;
			currWin = mainWin;
	    }
	}
	#endif

	self.multipleTouchEnabled = YES;
	eaglLayer.opaque = YES;
	context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
	assert(context);
	int ret = [EAGLContext setCurrentContext:context];
	assert(ret);
	/*if (!context || ![EAGLContext setCurrentContext:context])
	{
		[self release];
		return nil;
	}*/
	Base::mainContext = context;
	
	Base::displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawView)];
	//displayLink.paused = YES;
	Base::displayLinkActive = YES;
	[Base::displayLink setFrameInterval:1];
	[Base::displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	
	[EAGLContext setCurrentContext:context];
	//[self destroyFramebuffer];
	[self createFramebuffer];

	//[self drawView];

	return self;
}

#ifdef CONFIG_BASE_IPHONE_NIB
// Init from NIB
- (id)initWithCoder:(NSCoder*)coder
{
	if ((self = [super initWithCoder:coder]))
	{
		self = [self initGLES];
	}
	return self;
}
#endif

// Init from code
-(id)initWithFrame:(CGRect)frame
{
	logMsg("entered initWithFrame");
	if((self = [super initWithFrame:frame]))
	{
		self = [self initGLES];
	}
	logMsg("exiting initWithFrame");
	return self;
}

- (void)drawView
{
	if(unlikely(!Base::displayLinkActive))
		return;

	//logMsg("screen update");
	Base::runEngine();
	if(!Base::gfxUpdate)
	{
		Base::stopAnimation();
	}
}


- (void)layoutSubviews
{
	logMsg("in layoutSubviews");
	[self drawView];
}


- (BOOL)createFramebuffer
{
    glGenFramebuffersOES(1, &viewFramebuffer);
	glGenRenderbuffersOES(1, &viewRenderbuffer);

	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	[context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);

	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);

	if(Base::USE_DEPTH_BUFFER)
	{
		glGenRenderbuffersOES(1, &depthRenderbuffer);
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
		glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, backingWidth, backingHeight);
		glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);
	}

	if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
	{
		logMsg("failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
		return NO;
	}
	
	Base::openglViewIsInit = 1;
	return YES;
}


- (void)destroyFramebuffer
{
	glDeleteFramebuffersOES(1, &viewFramebuffer);
	viewFramebuffer = 0;
	glDeleteRenderbuffersOES(1, &viewRenderbuffer);
	viewRenderbuffer = 0;

	if(depthRenderbuffer)
	{
		glDeleteRenderbuffersOES(1, &depthRenderbuffer);
		depthRenderbuffer = 0;
	}
	
	Base::openglViewIsInit = 0;
}

- (void)dealloc
{
	if ([EAGLContext currentContext] == context)
	{
		[EAGLContext setCurrentContext:nil];
	}
}

#ifdef CONFIG_INPUT

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	using namespace Base;
	using namespace Input;
	for(UITouch* touch in touches)
	{
		iterateTimes((uint)Input::maxCursors, i) // find a free touch element
		{
			if(Input::m[i].touch == nil)
			{
				auto &p = Input::m[i];
				p.touch = touch;
				CGPoint startTouchPosition = [touch locationInView:self];
				pointerPos(startTouchPosition.x * pointScale, startTouchPosition.y * pointScale, &p.s.x, &p.s.y);
				p.s.inWin = 1;
				p.dragState.pointerEvent(Input::Pointer::LBUTTON, PUSHED, p.s.x, p.s.y);
				Input::onInputEvent(Input::Event(i, Event::MAP_POINTER, Input::Pointer::LBUTTON, PUSHED, p.s.x, p.s.y, nullptr));
				break;
			}
		}
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	using namespace Base;
	using namespace Input;
	for(UITouch* touch in touches)
	{
		iterateTimes((uint)Input::maxCursors, i) // find the touch element
		{
			if(Input::m[i].touch == touch)
			{
				auto &p = Input::m[i];
				CGPoint currentTouchPosition = [touch locationInView:self];
				pointerPos(currentTouchPosition.x * pointScale, currentTouchPosition.y * pointScale, &p.s.x, &p.s.y);
				p.dragState.pointerEvent(Input::Pointer::LBUTTON, MOVED, p.s.x, p.s.y);
				Input::onInputEvent(Input::Event(i, Event::MAP_POINTER, Input::Pointer::LBUTTON, MOVED, p.s.x, p.s.y, nullptr));
				break;
			}
		}
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	using namespace Base;
	using namespace Input;
	for(UITouch* touch in touches)
	{
		iterateTimes((uint)Input::maxCursors, i) // find the touch element
		{
			if(Input::m[i].touch == touch)
			{
				auto &p = Input::m[i];
				p.touch = nil;
				p.s.inWin = 0;
				CGPoint currentTouchPosition = [touch locationInView:self];
				pointerPos(currentTouchPosition.x * pointScale, currentTouchPosition.y * pointScale, &p.s.x, &p.s.y);
				p.dragState.pointerEvent(Input::Pointer::LBUTTON, RELEASED, p.s.x, p.s.y);
				Input::onInputEvent(Input::Event(i, Event::MAP_POINTER, Input::Pointer::LBUTTON, RELEASED, p.s.x, p.s.y, nullptr));
				break;
			}
		}
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self touchesEnded:touches withEvent:event];
}

#if defined(CONFIG_BASE_IOS_KEY_INPUT) || defined(CONFIG_INPUT_ICADE)
- (BOOL)canBecomeFirstResponder { return YES; }

- (BOOL)hasText { return NO; }

- (void)insertText:(NSString *)text
{
	#ifdef CONFIG_INPUT_ICADE
	if(Base::iCade.isActive())
		Base::iCade.insertText(text);
	#endif
}

- (void)deleteBackward { }

#ifdef CONFIG_INPUT_ICADE
- (UIView*)inputView
{
	return Base::iCade.dummyInputView;
}
#endif
#endif // defined(CONFIG_BASE_IOS_KEY_INPUT) || defined(CONFIG_INPUT_ICADE)

#endif

@end

@implementation MainApp

#if defined(CONFIG_INPUT) && defined(IPHONE_VKEYBOARD)
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	logMsg("pushed return");
	[textField resignFirstResponder];
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	using namespace Input;
	logMsg("editing ended");
	//inVKeyboard = 0;
	if(vKeyboardTextDelegate.hasCallback())
	{
		logMsg("running text entry callback");
		vKeyboardTextDelegate.invoke([textField.text UTF8String]);
	}
	vKeyboardTextDelegate.clear();
	//vkbdField.text = @"";
	[textField removeFromSuperview];
	vkbdField = nil;
}

#endif

- (void)keyboardWasShown:(NSNotification *)notification
{
}

- (void) keyboardWillHide:(NSNotification *)notification
{
}

static uint iOSOrientationToGfx(UIDeviceOrientation orientation)
{
	switch(orientation)
	{
		case UIDeviceOrientationPortrait: return Gfx::VIEW_ROTATE_0;
		case UIDeviceOrientationLandscapeLeft: return Gfx::VIEW_ROTATE_90;
		case UIDeviceOrientationLandscapeRight: return Gfx::VIEW_ROTATE_270;
		case UIDeviceOrientationPortraitUpsideDown: return Gfx::VIEW_ROTATE_180;
		default : return 255; // TODO: handle Face-up/down
	}
}

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	using namespace Base;
	mainApp = self;
	
	// TODO: get real DPI if possible
	// based on iPhone/iPod DPI of 163 (326 retina)
	uint unscaledDPI = 163;
	#if !defined(__ARM_ARCH_6K__) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 30200)
	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		// based on iPad DPI of 132 (264 retina) 
		unscaledDPI = 132;
		isIPad = 1;
		logMsg("running on iPad");
	}
	#endif

	CGRect rect = [[UIScreen mainScreen] bounds];
	mainWin.w = mainWin.rect.x2 = rect.size.width;
	mainWin.h = mainWin.rect.y2 = rect.size.height;
	Gfx::viewMMWidth_ = roundf((mainWin.w / (float)unscaledDPI) * 25.4);
	Gfx::viewMMHeight_ = roundf((mainWin.h / (float)unscaledDPI) * 25.4);
	logMsg("set screen MM size %dx%d", Gfx::viewMMWidth_, Gfx::viewMMHeight_);
	currWin = mainWin;
	// Create a full-screen window
	devWindow = [[UIWindow alloc] initWithFrame:rect];
	
	#ifdef GREYSTRIPE
	initGS(self);
	#endif
	
	NSNotificationCenter *nCenter = [NSNotificationCenter defaultCenter];
	[nCenter addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
	[nCenter addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
	[nCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	
	doOrExit(onInit(0, nullptr)); // TODO: args
	// Create the OpenGL ES view and add it to the Window
	glView = [[EAGLView alloc] initWithFrame:rect];
	#ifdef CONFIG_INPUT_ICADE
		iCade.init(glView);
	#endif
	Base::engineInit();
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);
	Base::setAutoOrientation(1);
	
	// view controller init
	if(usingiOS4)
	{
		viewCtrl = [[ImagineUIViewController alloc] init];
		viewCtrl.view = glView;
		devWindow.rootViewController = viewCtrl;
	}
	else
	{
		[devWindow addSubview:glView];
	}

	[devWindow makeKeyAndVisible];
	logMsg("exiting applicationDidFinishLaunching");
    
    [MobClick startWithAppkey:kUMengAppKey];
    [[DianJinOfferPlatform defaultPlatform] setAppId:kDianjinAppKey andSetAppKey:kDianjinAppSecrect];
	[[DianJinOfferPlatform defaultPlatform] setOfferViewColor:kDJBrownColor];
    [UMFeedback checkWithAppkey:kUMengAppKey];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRecNewMsg:) name:UMFBCheckFinishedNotification object:nil];
}

- (void)orientationChanged:(NSNotification *)notification
{
	uint o = iOSOrientationToGfx([[UIDevice currentDevice] orientation]);
	if(o == 255)
		return;
	if(o == Gfx::VIEW_ROTATE_180 && !Base::isIPad)
		return; // ignore upside-down orientation unless using iPad
	logMsg("new orientation %s", Gfx::orientationName(o));
	Gfx::preferedOrientation = o;
	Gfx::setOrientation(Gfx::preferedOrientation);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	logMsg("resign active");
	Base::stopAnimation();
	glFinish();
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	using namespace Base;
	logMsg("became active");
	Base::appState = APP_RUNNING;
	if(Base::displayLink)
		Base::startAnimation();
	Base::onResume(1);
	#ifdef CONFIG_INPUT_ICADE
		iCade.didBecomeActive();
	#endif
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	using namespace Base;
	logMsg("app exiting");
	Base::appState = APP_EXITING;
	Base::onExit(0);
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	using namespace Base;
	logMsg("entering background");
	appState = APP_PAUSED;
	Base::stopAnimation();
	Base::onExit(1);
	#ifdef CONFIG_INPUT_ICADE
		iCade.didEnterBackground();
	#endif
	glFinish();
}

- (void)timerCallback:(id)callback
{
	using namespace Base;
	logMsg("running callback");
	NSData *callbackData = (NSData*)callback;
	CallbackDelegate del;
	[callbackData getBytes:&del length:sizeof(del)];
	del.invoke();
}

- (void)handleThreadMessage:(NSValue *)arg
{
	using namespace Base;
	ThreadMsg msg;
	[arg getValue:&msg];
	processAppMsg(msg.type, msg.shortArg, msg.intArg, msg.intArg2);
}

-(void)onRecNewMsg:(NSNotification*)notification
{
    NSArray * newReplies = [notification.userInfo objectForKey:@"newReplies"];
    if (!newReplies) {
        return;
    }
    
    UIAlertView *alertView;
    NSString *title = [NSString stringWithFormat:@"有%d条新回复", [newReplies count]];
    NSMutableString *content = [NSMutableString string];
    for (int i = 0; i < [newReplies count]; i++) {
        NSString * dateTime = [[newReplies objectAtIndex:i] objectForKey:@"datetime"];
        NSString *_content = [[newReplies objectAtIndex:i] objectForKey:@"content"];
        [content appendString:[NSString stringWithFormat:@"%d: %@---%@\n", i+1, _content, dateTime]];
    }
    
    alertView = [[UIAlertView alloc] initWithTitle:title message:content delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    ((UILabel *) [[alertView subviews] objectAtIndex:1]).textAlignment = NSTextAlignmentLeft ;
    [alertView show];
    
}


@end

namespace Base
{

void nsLog(const char* format, va_list arg)
{
	char buff[256];
	vsnprintf(buff, sizeof(buff), format, arg);
	NSLog(@"%s", buff);
}

void setVideoInterval(uint interval)
{
	logMsg("setting frame interval %d", (int)interval);
	assert(interval >= 1);
	[Base::displayLink setFrameInterval:interval];
}

static void setViewportForStatusbar(UIApplication *sharedApp)
{
	using namespace Gfx;
	mainWin.rect.x = mainWin.rect.y = 0;
	mainWin.rect.x2 = mainWin.w;
	mainWin.rect.y2 = mainWin.h;
	//logMsg("status bar hidden %d", sharedApp.statusBarHidden);
	if(!sharedApp.statusBarHidden)
	{
		bool isSideways = rotateView == VIEW_ROTATE_90 || rotateView == VIEW_ROTATE_270;
		auto statusBarHeight = (isSideways ? sharedApp.statusBarFrame.size.width : sharedApp.statusBarFrame.size.height) * pointScale;
		if(isSideways)
		{
			if(rotateView == VIEW_ROTATE_270)
				mainWin.rect.x = statusBarHeight;
			else
				mainWin.rect.x2 -= statusBarHeight;
		}
		else
		{
			mainWin.rect.y = statusBarHeight;
		}
		logMsg("status bar height %d", (int)statusBarHeight);
		logMsg("adjusted window to %d:%d:%d:%d", mainWin.rect.x, mainWin.rect.y, mainWin.rect.x2, mainWin.rect.y2);
	}
}

void setStatusBarHidden(uint hidden)
{
	auto sharedApp = [UIApplication sharedApplication];
	[sharedApp setStatusBarHidden: hidden ? YES : NO withAnimation: UIStatusBarAnimationFade];
	setViewportForStatusbar(sharedApp);
	generic_resizeEvent(mainWin);
}

static UIInterfaceOrientation gfxOrientationToUIInterfaceOrientation(uint orientation)
{
	using namespace Gfx;
	switch(orientation)
	{
		default: return UIInterfaceOrientationPortrait;
		case VIEW_ROTATE_270: return UIInterfaceOrientationLandscapeLeft;
		case VIEW_ROTATE_90: return UIInterfaceOrientationLandscapeRight;
		case VIEW_ROTATE_180: return UIInterfaceOrientationPortraitUpsideDown;
	}
}

void setSystemOrientation(uint o)
{
	using namespace Input;
	auto sharedApp = [UIApplication sharedApplication];
	[sharedApp setStatusBarOrientation:gfxOrientationToUIInterfaceOrientation(o) animated:YES];
	setViewportForStatusbar(sharedApp);
}

static bool autoOrientationState = 0; // Turned on in applicationDidFinishLaunching

void setAutoOrientation(bool on)
{
	if(autoOrientationState == on)
		return;
	autoOrientationState = on;
	logMsg("set auto-orientation: %d", on);
	if(on)
		[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	else
	{
		Gfx::preferedOrientation = Gfx::rotateView;
		[[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
	}
}

void exitVal(int returnVal)
{
	appState = APP_EXITING;
	onExit(0);
	::exit(returnVal);
}

void displayNeedsUpdate()
{
	generic_displayNeedsUpdate();
	if(appState == APP_RUNNING && Base::displayLinkActive == NO)
	{
		Base::startAnimation();
	}
}

void setIdleDisplayPowerSave(bool on)
{
	[UIApplication sharedApplication].idleTimerDisabled = on ? NO : YES;
	logMsg("set idleTimerDisabled %d", (int)[UIApplication sharedApplication].idleTimerDisabled);
}

void sendMessageToMain(ThreadPThread &, int type, int shortArg, int intArg, int intArg2)
{
	ThreadMsg msg = { (int16)type, (int16)shortArg, intArg, intArg2 };
	NSValue *arg = [[NSValue alloc] initWithBytes:&msg objCType:@encode(Base::ThreadMsg)];
	[mainApp performSelectorOnMainThread:@selector(handleThreadMessage:)
		withObject:arg
		waitUntilDone:NO];
}

static const char *docPath = 0;

const char *documentsPath()
{
	if(!docPath)
	{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        docPath = strdup([documentsDirectory cStringUsingEncoding: NSASCIIStringEncoding]);
	}
	return docPath;
}

int runningDeviceType()
{
	return isIPad ? DEV_TYPE_IPAD : DEV_TYPE_GENERIC;
}
}

#ifdef CONFIG_INPUT_ICADE

namespace Input
{

void Device::setICadeMode(bool on)
{
	assert(map_ == Input::Event::MAP_ICADE); // BT Keyboard always treated as iCade
	logMsg("set iCade mode %s for %s", on ? "on" : "off", name());
	iCadeMode_ = on;
	Base::iCade.setActive(on);
}

}

#endif

double TimeMach::timebaseNSec = 0, TimeMach::timebaseUSec = 0,
	TimeMach::timebaseMSec = 0, TimeMach::timebaseSec = 0;

int main(int argc, char *argv[])
{
	using namespace Base;
	
	doOrExit(logger_init());
	TimeMach::setTimebase();
	FsPosix::changeToAppDir(argv[0]);

    @autoreleasepool {
        int retVal = UIApplicationMain(argc, argv, nil, @"MainApp");
        return retVal;
    }
}
