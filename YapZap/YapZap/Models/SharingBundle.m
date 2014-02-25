//
//  SharingBundle.m
//  YapZap
//
//  Created by Jason R Boggess on 2/13/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "SharingBundle.h"
#import "RecordingInfo.h"

@implementation SharingBundle

static SharingBundle* _sharingBundle;

+(SharingBundle*)getCurrentSharingBundle{
    if (_sharingBundle==nil){
        _sharingBundle = [[SharingBundle alloc] init];
    }
    
    return _sharingBundle;
}

+(void)clearSharingBundle{
    _sharingBundle = nil;
}


@end
