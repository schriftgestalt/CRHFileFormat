//
//  CRHFileFormat.h
//  CRHFileFormat
//
//  Created by Georg Seifert on 08.04.18.
//Copyright © 2018 Georg Seifert. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <GlyphsCore/GlyphsFileFormatProtocol.h>

@class GSFont;
@class GSProgressWindow;

@interface GlyphsFileFormatCRHFileFormat : NSObject <GlyphsFileFormat> {
	NSImage*			_toolbarIcon;
	IBOutlet NSView*	_exportSettingsView;
	GSFont*				__unsafe_unretained _font;
}
@property(readonly) NSView *exportSettingsView;
@property(assign, nonatomic) GSFont *font;
@property(readonly) GSProgressWindow *progressWindow;

@end
