//
//  PatchBank.h
//  Theremin2
//
//  Created by Admin on 03/07/2017.
//  Copyright © 2017 MacBookPro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Patch.h"


@interface PatchBank : NSObject

@property (nonatomic, readonly, assign) BOOL isReadyToSave;
@property (nonatomic, assign) NSInteger selectedPatchIndex;

- (void)prepareForSaving;
- (void)abortSaving;
- (void)savePatchAtSelectedIndex:(Patch *)patch;
- (Patch *)patchAtSelectedIndex;

@end
