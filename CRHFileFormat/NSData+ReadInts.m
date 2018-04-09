//
//  NSData+ReadInts.m
//  CRHFileFormat
//
//  Created by Georg Seifert on 08.04.18.
//  Copyright © 2018 Georg Seifert. All rights reserved.
//

#import "NSData+ReadInts.h"

@implementation NSData (ReadInts)

- (uint8_t)readUnsignedInt8:(NSUInteger*)offsetPtr {
	if ([self length] > *offsetPtr) {
		uint8_t x = *(const uint8_t*)([self bytes] + *offsetPtr);
		*offsetPtr += sizeof(uint8_t);
		return x;
	}
	return 0;
}

- (int8_t)readInt8:(NSUInteger*)offsetPtr {
	if ([self length] > *offsetPtr) {
		int8_t x = *(const int8_t*)([self bytes] + *offsetPtr);
		*offsetPtr += sizeof(int8_t);
		return x;
	}
	return 0;
}

- (uint16_t)readUnsignedInt16:(NSUInteger*)offsetPtr {
	if ([self length] > *offsetPtr) {
		uint16_t x = *(const uint16_t*)([self bytes] + *offsetPtr);
		*offsetPtr += sizeof(uint16_t);
		return x; // CFSwapInt16BigToHost(x);
	}
	return 0;
}
@end
