//
//  ESharedUserDefault.m
//  EasyCode
//
//  Created by gao feng on 2016/10/20.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "ESharedUserDefault.h"
#import "ECMappingForObjectiveC.h"
#import "ECMappingForSwift.h"

#define KeySharedContainerGroup @"5RQCS68BQ4.group.com.music4kid.easycode"

#define KeyCodeShortcutForObjectiveC @"KeyCodeShortcutForObjectiveC"
#define KeyCodeShortcutForSwift @"KeyCodeShortcutForSwift"

#define KeyCurrentUDVersion @"KeyCurrentUDVersion"
#define ValueCurrentUDVersion @"1"

#define KeyPrefixObjectiveC @"oc."
#define KeyPrefixSwift @"swift."

@interface ESharedUserDefault ()
@property (nonatomic, strong) NSUserDefaults*                   sharedUD;

@property (nonatomic, strong) NSDictionary*                     ocMappingDefault;
@property (nonatomic, strong) NSDictionary*                     swiftMappingDefault;

@property (nonatomic, strong) NSMutableDictionary*              ocMapping;
@property (nonatomic, strong) NSMutableDictionary*              swiftMapping;

@end

@implementation ESharedUserDefault

+ (instancetype)sharedInstance
{
    static ESharedUserDefault* instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [ESharedUserDefault new];
    });

    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self initSharedUD];
    }
    return self;
}

- (void)initSharedUD
{
    self.sharedUD = [[NSUserDefaults alloc] initWithSuiteName:KeySharedContainerGroup];
    if ([_sharedUD objectForKey:KeyCurrentUDVersion] == nil) {
        [_sharedUD setObject:ValueCurrentUDVersion forKey:KeyCurrentUDVersion];
    }
}

- (void)clearMapping
{
    _ocMapping = nil;
    _swiftMapping = nil;
}

#pragma mark - Objective-C

- (NSDictionary*)readMappingForOC
{
    if (_ocMapping == nil) {
        _ocMapping = [_sharedUD dictionaryForKey:KeyCodeShortcutForObjectiveC].mutableCopy;
//        _ocMapping = nil;
        if (_ocMapping == nil) {
            _ocMapping = self.ocMappingDefault.mutableCopy;
            [self saveMappingForOC:self.ocMappingDefault];
        }
    }
    
    return _ocMapping;
}

- (void)saveMappingForOC:(NSDictionary*)mapping
{
    self.ocMapping = mapping.mutableCopy;
    [_sharedUD setObject:mapping forKey:KeyCodeShortcutForObjectiveC];
    [_sharedUD synchronize];
}

- (NSDictionary*)ocMappingDefault
{
    if (_ocMappingDefault == nil) {
        _ocMappingDefault = [[ECMappingForObjectiveC new] provideMapping];
    }
    return _ocMappingDefault;
}

#pragma mark - Swift

- (NSDictionary*)readMappingForSwift
{
    if (_swiftMapping == nil) {
        _swiftMapping = [_sharedUD dictionaryForKey:KeyCodeShortcutForSwift].mutableCopy;
//        _swiftMapping = nil;
        if (_swiftMapping == nil) {
            _swiftMapping = self.swiftMappingDefault.mutableCopy;
            [self saveMappingForOC:self.swiftMappingDefault];
        }
    }
    
    return _swiftMapping;
}

- (void)saveMappingForSwift:(NSDictionary*)mapping
{
    self.swiftMapping = mapping.mutableCopy;
    [_sharedUD setObject:mapping forKey:KeyCodeShortcutForSwift];
    [_sharedUD synchronize];
}

- (NSDictionary*)swiftMappingDefault
{
    if (_swiftMappingDefault == nil) {
        _swiftMappingDefault = [[ECMappingForSwift new] provideMapping];
    }
    return _swiftMappingDefault;
}

@end
