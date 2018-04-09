//
//  NSData+ReadInts.h
//  CRHFileFormat
//
//  Created by Georg Seifert on 08.04.18.
//  Copyright © 2018 Georg Seifert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (ReadInts)
- (uint8_t)readUnsignedInt8:(NSUInteger*)offsetPtr;
- (int8_t)readInt8:(NSUInteger*)offsetPtr;
- (uint16_t)readUnsignedInt16:(NSUInteger*)offsetPtr;
@end
