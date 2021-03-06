//
//  MD5Hash.m
//  FlickrKit
//
//  Created by Felix Morgner on 25.04.11.
//  Someone created this code. If you know who did it please tell me!
//

#import "NSString+MD5Hash.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5Hash)

- (NSString *) MD5Hash 
	{
	const char *cStr = [self UTF8String];
	unsigned char result[16];
	
	CC_MD5( cStr, (unsigned int)strlen(cStr), result );

	return [NSString stringWithFormat: @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
        result[0],  result[1],  result[2],  result[3], 
        result[4],  result[5],  result[6],  result[7],
        result[8],  result[9],  result[10], result[11],
        result[12], result[13], result[14], result[15]];  
	}

@end
