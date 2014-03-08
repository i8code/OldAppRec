//
//  Util.m
//  YapZap
//
//  Created by Jason R Boggess on 2/8/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "Util.h"

@implementation Util

// r,g,b values are from 0 to 1
// h = [0,360], s = [0,1], v = [0,1]
//		if s == 0, then h = -1 (undefined)
void RGBtoHSV( float r, float g, float b, float *h, float *s, float *v )
{
	float min, max, delta;
	min = MIN( MIN(r, g), b );
	max = MAX( MAX(r, g), b );
	*v = max;				// v
	delta = max - min;
	if( max != 0 )
		*s = delta / max;		// s
	else {
		// r = g = b = 0		// s = 0, v is undefined
		*s = 0;
		*h = -1;
		return;
	}
	if( r == max )
		*h = ( g - b ) / delta;		// between yellow & magenta
	else if( g == max )
		*h = 2 + ( b - r ) / delta;	// between cyan & yellow
	else
		*h = 4 + ( r - g ) / delta;	// between magenta & cyan
	*h *= 60;				// degrees
	if( *h < 0 )
		*h += 360;
}
void HSVtoRGB( float *r, float *g, float *b, float h, float s, float v )
{
	int i;
	float f, p, q, t;
	if( s == 0 ) {
		// achromatic (grey)
		*r = *g = *b = v;
		return;
	}
	h /= 60;			// sector 0 to 5
	i = floor( h );
	f = h - i;			// factorial part of h
	p = v * ( 1 - s );
	q = v * ( 1 - s * f );
	t = v * ( 1 - s * ( 1 - f ) );
	switch( i ) {
		case 0:
			*r = v;
			*g = t;
			*b = p;
			break;
		case 1:
			*r = q;
			*g = v;
			*b = p;
			break;
		case 2:
			*r = p;
			*g = v;
			*b = t;
			break;
		case 3:
			*r = p;
			*g = q;
			*b = v;
			break;
		case 4:
			*r = t;
			*g = p;
			*b = v;
			break;
		default:		// case 5:
			*r = v;
			*g = p;
			*b = q;
			break;
	}
}

+(UIColor*)colorFromMood:(CGFloat)mood andIntesity:(CGFloat)intensity{
    
    float *r = malloc(sizeof(float)), *g=malloc(sizeof(float)), *b=malloc(sizeof(float));
    HSVtoRGB(r,g,b,mood*360, intensity, 1);
    
    return [UIColor colorWithRed:*r green:*g blue:*b alpha:1.0f];
    
}
+(CGFloat)moodFromColor:(UIColor*)color{
    CGFloat h, s, b, a;
    [color getHue:&h saturation:&s brightness:&b alpha:&a];
    return h;
    
}
+(CGFloat)intenstiyFromColor:(UIColor*)color{
    CGFloat h, s, b, a;
    [color getHue:&h saturation:&s brightness:&b alpha:&a];
    return s;
}
+(NSDateFormatter*)getDateFormatter{
    
    static NSDateFormatter *dateFormatter;
    
    if (!dateFormatter){
        dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [dateFormatter setLocale:enUSPOSIXLocale];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    }
    
    return dateFormatter;
}
+(NSString*)trimUsername:(NSString*)username{
    if (!username){
        return nil;
    }
    
    NSRange underscore = [username rangeOfString: @"_"];
    if (underscore.location  == NSNotFound ){
        return username;
    }
    
    return [username substringWithRange:NSMakeRange(underscore.location+1, username.length - underscore.location-1)];
}

static const int recentSearchesCount = 10;
+(NSArray*)mostRecentSearches{
    NSMutableArray* mostRecent = [[NSMutableArray alloc] init];
    
    for (int i=0;i<recentSearchesCount;i++){
        NSString* key = [NSString stringWithFormat:@"YapZap_Recent_%u", i];
        NSString* name = [[NSUserDefaults standardUserDefaults] objectForKey:key];
        if (!name){
            break;
        }
        
        [mostRecent addObject:name];
    }
    return mostRecent;
}

+(void)addRecentSearch:(NSString*)term{
    for (int i=recentSearchesCount-2;i>=0;i--){
        NSString* name;
        
        if (i==0){
            name = term;
        }
        else {
            NSString* key = [NSString stringWithFormat:@"YapZap_Recent_%u", i-1];
            name = [[NSUserDefaults standardUserDefaults] objectForKey:key];
        }
        
        
        NSString* key = [NSString stringWithFormat:@"YapZap_Recent_%u", i];
        [[NSUserDefaults standardUserDefaults] setObject:name forKey:key];
        
    }
}


+(BOOL)shouldShareOnFB{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"YapZap_share_fb"];
}

+(void)setShareOnFB:(BOOL)share{
    [[NSUserDefaults standardUserDefaults] setBool:share forKey:@"YapZap_share_fb"];
}

+(BOOL)shouldShareOnTW{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"YapZap_share_tw"];
    
}

+(void)setShareOnTW:(BOOL)share{
    [[NSUserDefaults standardUserDefaults] setBool:share forKey:@"YapZap_share_tw"];
}

@end
