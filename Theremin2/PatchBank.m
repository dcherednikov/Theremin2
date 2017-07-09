//
//  PatchBank.m
//  Theremin2
//
//  Created by Admin on 03/07/2017.
//  Copyright © 2017 MacBookPro. All rights reserved.
//

#import "PatchBank.h"

static const NSUInteger bankCapacity = 3;

@implementation PatchBank {
    
    NSMutableArray<Patch *> *bank;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        bank = [[NSMutableArray alloc] initWithCapacity:bankCapacity];
        [self restoreState];
    }
    return self;
}

- (void)restoreState {
    
    NSString *defaultValuesFile = [[NSBundle mainBundle] pathForResource:@"Default Values"
                                                                  ofType:@"plist"];
    NSDictionary *defaultPreferences = [NSDictionary dictionaryWithContentsOfFile:defaultValuesFile];
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    [standardDefaults registerDefaults:defaultPreferences];
    _selectedPatchIndex = [standardDefaults integerForKey:@"lastPatch"];
    
    for (int i = 0; i < bankCapacity; ++i) {
        
        NSURL *url = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                            inDomains:NSUserDomainMask].firstObject;
        NSString *patchComponent = [NSString stringWithFormat:@"Patch %d.plist", i];
        NSString *urlString = [url URLByAppendingPathComponent:patchComponent].path;
        if (![[NSFileManager defaultManager] fileExistsAtPath:urlString]) {
            
            NSString *defaultFileName = [NSString stringWithFormat:@"Default Patch %d", i];
            NSString *path = [[NSBundle mainBundle] pathForResource:defaultFileName
                                                        ofType:@"plist"];
            NSDictionary *properties = [NSDictionary dictionaryWithContentsOfFile:path];
            bank[i] = [[Patch alloc] initWithProperties:properties];
        }
        else {
            
            bank[i] = [NSKeyedUnarchiver unarchiveObjectWithFile:urlString];
        }
    }
}

- (void)prepareForSaving {
    
    _isReadyToSave = YES;
}

- (void)abortSaving {
    
    _isReadyToSave = NO;
}

- (void)setSelectedPatchIndex:(NSInteger)selectedPatchIndex {
    
    if (selectedPatchIndex >= bankCapacity) {
        
        return;
    }
    _selectedPatchIndex = selectedPatchIndex;
    [[NSUserDefaults standardUserDefaults] setInteger:_selectedPatchIndex
                                               forKey:@"lastPatch"];
}

- (void)savePatchAtSelectedIndex:(Patch *)patch {
    
    _isReadyToSave = NO;
    bank[_selectedPatchIndex] = patch;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:bank[_selectedPatchIndex]];
    
    NSURL *url = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                        inDomains:NSUserDomainMask].firstObject;
    NSString *patchComponent = [NSString stringWithFormat:@"Patch %d.plist", (int)_selectedPatchIndex];
    NSString *urlString = [url URLByAppendingPathComponent:patchComponent].path;
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:urlString
                                               error:&error];
    [data writeToFile:urlString atomically:YES];
}

- (Patch *)patchAtSelectedIndex {
    
    return bank[_selectedPatchIndex];
}

@end
