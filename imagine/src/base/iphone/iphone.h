#define Fixed MacTypes_Fixed
#define Rect MacTypes_Rect
#undef Fixed
#undef Rect

#include <config.h>
#import "GameListViewController.h"
#import "SettingViewController.h"
#import "EmuGameViewController.h"

@interface MainApp : NSObject <UIApplicationDelegate, UIPopoverControllerDelegate>
{
    UINavigationController* gameVC;
    GameListViewController* gameListVC;
    SettingViewController* settingVC;
    UIPopoverController * popoverVC;

    UIWindow *window;
    
    MDGameViewController* emuGameVC;
}

-(void)showSettingPopup;
-(void)showGameList;

@end


void showSettingPopup();
void showGameList();