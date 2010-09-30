//
//  Chelf.m
//  Chelf
//
//  Created by Jean-Michel Lacroix (jmlacroix.com) on 10-08-04.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Chelf.h"
#import "JRSwizzle.h"


@implementation Chelf

@synthesize downloadShelf;

+ (Chelf*)sharedInstance {
    static Chelf* chelf = nil;

    if (chelf == nil)
        chelf = [[Chelf alloc] init];

    return chelf;
}

+ (void)load {
    [[Chelf sharedInstance] insertMenu];
    [NSClassFromString(@"DownloadShelfController")
        jr_swizzleMethod:@selector(showDownloadShelf:)
              withMethod:@selector(Shelf_showDownloadShelf:) error:NULL];
}

#pragma MenuItem

- (void)insertMenu
{
    NSMenu *appMenu = [NSApp mainMenu];
    NSEnumerator *menuEnum = [[appMenu itemArray] objectEnumerator];
    NSMenu *menu;

    while ((menu = [[menuEnum nextObject] submenu]) != nil) {
        if ([[menu _menuName] isEqualToString:@"NSWindowsMenu"]) {
            break;
        }
    }

    NSMenuItem *item = [[[NSMenuItem alloc] init] autorelease];
    [item setTitle:@"Hide Download Shelf"];
    [item setKeyEquivalent:@"x"];
    [item setKeyEquivalentModifierMask:(NSCommandKeyMask + NSShiftKeyMask)];
    [item setTarget:self];
    [item setAction:@selector(closeShelf:)];

    int index = [menu indexOfItemWithTarget:nil andAction:@selector(performMinimize:)];
    [menu insertItem:item atIndex:index + 9];
}

- (void)closeShelf:sender
{
    Chelf *chelf = [Chelf sharedInstance];
    [chelf.downloadShelf showDownloadShelf:NO];
}

@end

@implementation NSViewController(Chelf)

- (void)Shelf_showDownloadShelf:(BOOL)enable {

    Chelf *chelf = [Chelf sharedInstance];
    chelf.downloadShelf = self;

    [self Shelf_showDownloadShelf:enable];
}

@end
