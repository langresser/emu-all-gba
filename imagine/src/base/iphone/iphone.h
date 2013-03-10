#define Fixed MacTypes_Fixed
#define Rect MacTypes_Rect
#undef Fixed
#undef Rect

#include <config.h>
#import "GameListViewController.h"
#import "SettingViewController.h"

@interface MainApp : NSObject <UIApplicationDelegate, UIPopoverControllerDelegate>
{
    UINavigationController* gameVC;
    GameListViewController* gameListVC;
    SettingViewController* settingVC;
    UIPopoverController * popoverVC;
    
    UIWindow *window;
}

@property (nonatomic, strong) UIWindow *window;

-(void)showSettingPopup:(BOOL)show;
-(void)showGameList;

@end
