//
//  CRHFileFormat.m
//  CRHFileFormat
//
//  Created by Georg Seifert on 08.04.18.
//Copyright © 2018 Georg Seifert. All rights reserved.
//

#import "CRHFileFormat.h"
#import <GlyphsCore/GlyphsFilterProtocol.h>
#import <GlyphsCore/GSFont.h>
#import "NSData+ReadInts.h"

@implementation GlyphsFileFormatCRHFileFormat

@synthesize exportSettingsView = _exportSettingsView;
@synthesize font = _font;
@synthesize progressWindow = _progressWindow;
@synthesize toolbarIconName = _toolbarIconName;
@synthesize title = _title;

typedef struct {
	char fontName[4];
	uint16_t fontSize;
	uint8_t versionMajor;
	uint8_t versionMinor;
	uint16_t reservered;
} CHRHeader;

typedef struct {
	uint8_t signature; // '+' means stroke font
	unsigned short numChars;
	//uint8_t numChars_;
	uint8_t undefined;
	uint8_t firstChar;
	unsigned short strokeOffset;
	uint8_t scanFlag;
	
	short capHeight;
	short baseline;
	short descender;
	char fontName[4];
} CHRInfo;

- (id)init {
	self = [super init];
	[NSBundle loadNibNamed:@"CRHFileFormatDialog" owner:self];
	NSBundle * thisBundle = [NSBundle bundleForClass:[self class]];
	_toolbarIcon = [[NSImage alloc] initWithContentsOfFile:[thisBundle pathForImageResource: @"ExportIcon"]];
	[_toolbarIcon setName: @"ExportIcon"];
	return self;
}

- (NSUInteger) interfaceVersion {
	// Distinguishes the API verison the plugin was built for. Return 1.
	return 1;
}

- (NSString*) toolbarTitle {
	// Return the name of the tool as it will appear in export dialog.
	return @"CRHFileFormat";
}

- (NSUInteger) groupID {
	// Position in the export panel. Higher numbers move it to the right.
	return 10;
}

- (GSLayer*)readCharacterDefinitions:(NSData*)data offset:(NSUInteger)pos {
	
	return nil;
}

- (GSLayer*)readWidth:(NSData*)data offset:(NSUInteger)pos {
	return nil;
}

- (GSFont*) fontFromURL:(NSURL*)URL ofType:(NSString*)typeName error:(out NSError*__autoreleasing*)error {
	NSData* data = [[NSData alloc] initWithContentsOfURL:URL options:0 error:error];
	if (!data) {
		return nil;
	}
	char signature[9];
	[data getBytes:&signature range:NSMakeRange(0, 8)];
	signature[8] = 0;
	if (!(signature[0] == 'P' && signature[1] == 'K' && signature[2] == 8 && signature[3] == 8)) {
		NSLog(@"Wrong file format");
		return nil;
	}
	NSUInteger pos = 8;
	NSRange descriptionRange;
	descriptionRange.location = pos;
	char byte = 0;
	while (byte != 26 && pos < [data length]) {
		[data getBytes:&byte range:NSMakeRange(pos++, 1)];
	}
	descriptionRange.length = pos - descriptionRange.location - 1;
	NSString* descriptionString = [[NSString alloc] initWithData:[data subdataWithRange:descriptionRange] encoding:NSASCIIStringEncoding];
	NSLog(@"description %@", descriptionString);
	uint16_t headerSize;
	[data getBytes:&headerSize range:NSMakeRange(pos, 2)];
	pos+=2;
	NSLog(@"headerSize %d", headerSize);
	CHRHeader header;
	
	[data getBytes:&header range:NSMakeRange(pos, sizeof(CHRHeader))];
	
	NSLog(@"fontName %s", header.fontName);
	NSLog(@"fontSize %d", header.fontSize);
	NSLog(@"version major %d", header.versionMajor);
	NSLog(@"version minor %d", header.versionMinor);
	
	pos = headerSize;
	NSLog(@"**  info  **");
	CHRInfo info;
	//[data getBytes:&info range:NSMakeRange(pos, sizeof(CHRInfo))];
	info.signature = [data readUnsignedInt8:&pos];
	info.numChars = [data readUnsignedInt16:&pos];
	// scipt undefined byte
	pos++;
	info.firstChar = [data readUnsignedInt8:&pos];
	info.strokeOffset = [data readUnsignedInt16:&pos];
	info.scanFlag = [data readUnsignedInt8:&pos];
	info.capHeight = [data readInt8:&pos];
	info.baseline = [data readInt8:&pos];
	info.descender = [data readInt8:&pos];
	[data getBytes:&info.fontName range:NSMakeRange(pos, 4)];
	pos+=4;
	
	BOOL isStroke = info.signature == '+';
	NSLog(@"isStroke %s", isStroke ? "Yes" : "No");
	NSLog(@"numChars %d", (int)info.numChars);
	NSLog(@"firstChar %d", (int)info.firstChar);
	NSLog(@"strokeOffset %d", (int)info.strokeOffset);
	NSLog(@"scanFlag %d", (int)info.scanFlag);
	NSLog(@"capHeight %d", (int)info.capHeight);
	NSLog(@"baseline %d", (int)info.baseline);
	NSLog(@"descender %d", (int)info.descender);
	NSLog(@"fontName %s", info.fontName);
	
	NSLog(@"info.strokeOffset %d pos %ld", info.strokeOffset, pos);
	
	unsigned short* offsetToCharacterDef = malloc(info.numChars * 2);
	[data getBytes:offsetToCharacterDef range:NSMakeRange(pos, info.numChars * 2)];
	NSLog(@"offsetToCharacterDef %d %d %d", offsetToCharacterDef[0], offsetToCharacterDef[1], offsetToCharacterDef[2]);
	pos += info.numChars * 2;
	uint8_t* widthTable = malloc(info.numChars);
	[data getBytes:widthTable range:NSMakeRange(pos, info.numChars)];
	NSLog(@"widthTable %d %d %d", (int)widthTable[0], (int)widthTable[1], (int)widthTable[2]);
	pos += info.numChars;
	//http://www.delphigroups.info/2/c0/5350.html
	
	return nil;
}

- (BOOL) writeFont:(GSFont*)Font error:(out NSError*__autoreleasing*)error {
	// Write Font to disk. You have to ask for the path yourself. This is called from the export dialog.
	// Return YES on sucess, NO otherwise and add some infomation about the problem to 'error'). 
	return NO;
}

- (BOOL) writeFont:(GSFont*)Font toURL:(NSURL*)DestinationURL error:(out NSError*__autoreleasing*)error {
	// Write Font to DestinationURL.
	// Return YES on sucess, NO otherwise and add some infomation about the problem to 'error').
	return NO;
}

@end
