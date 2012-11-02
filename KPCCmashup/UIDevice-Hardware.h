/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 5.0 Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>

#define IFPGA_NAMESTRING                @"iFPGA"

#define IPHONE_1G_NAMESTRING            @"iPhone 1G"
#define IPHONE_3G_NAMESTRING            @"iPhone 3G"
#define IPHONE_3GS_NAMESTRING           @"iPhone 3GS" 
#define IPHONE_4_NAMESTRING             @"iPhone 4" 
#define IPHONE_5_NAMESTRING             @"iPhone 5"
#define IPHONE_UNKNOWN_NAMESTRING       @"Unknown iPhone"

#define IPOD_1G_NAMESTRING              @"iPod touch 1G"
#define IPOD_2G_NAMESTRING              @"iPod touch 2G"
#define IPOD_3G_NAMESTRING              @"iPod touch 3G"
#define IPOD_4G_NAMESTRING              @"iPod touch 4G"
#define IPOD_UNKNOWN_NAMESTRING         @"Unknown iPod"

#define IPAD_1G_NAMESTRING              @"iPad 1G"
#define IPAD_2G_NAMESTRING              @"iPad 2G"
#define IPAD_3G_NAMESTRING              @"iPad 3G"
#define IPAD_UNKNOWN_NAMESTRING         @"Unknown iPad"

#define APPLETV_2G_NAMESTRING           @"Apple TV 2G"
#define APPLETV_UNKNOWN_NAMESTRING      @"Unknown Apple TV"

#define IOS_FAMILY_UNKNOWN_DEVICE       @"Unknown iOS device"
#define IPOD_FAMILY_UNKNOWN_DEVICE			@"Unknown device in the iPhone/iPod family"

#define IPHONE_SIMULATOR_NAMESTRING         @"iPhone Simulator"
#define IPHONE_SIMULATOR_IPHONE_NAMESTRING  @"iPhone Simulator"
#define IPHONE_SIMULATOR_IPAD_NAMESTRING    @"iPad Simulator"



typedef enum {
    UIDeviceUnknown,
    
    UIDeviceiPhoneSimulator,
    UIDeviceiPhoneSimulatoriPhone, // both regular and iPhone 4 devices
    UIDeviceiPhoneSimulatoriPad,
    
    UIDevice1GiPhone,
    UIDevice3GiPhone,
    UIDevice3GSiPhone,
    UIDevice4iPhone,
    UIDevice4GiPhone,
    UIDevice5iPhone,
    
    UIDevice1GiPod,
    UIDevice2GiPod,
    UIDevice2GPlusiPod,
	UIDevice3GiPod,
    UIDevice4GiPod,
    
    UIDevice1GiPad,
    UIDevice1GiPad3G,
	UIDevice2GiPad,
    UIDevice3GiPad,
    
    UIDeviceAppleTV2,
    UIDeviceUnknownAppleTV,
    
    UIDeviceUnknowniPhone,
    UIDeviceUnknowniPod,
    UIDeviceUnknowniPad,
    UIDeviceIFPGA,
    UIDeviceFutureiPhone,
    UIDeviceFutureiPod,
    UIDeviceFutureiPad
} UIDevicePlatform;

typedef enum {
    UIDeviceUnknownCapabilities = 0ULL,
    
	UIDeviceSupportsTelephony = 1 << 0,
	UIDeviceSupportsSMS = 1 << 1,
	UIDeviceSupportsStillCamera = 1 << 2,
	UIDeviceSupportsAutofocusCamera = 1 << 3,
	UIDeviceSupportsVideoCamera = 1 << 4,
	UIDeviceSupportsWifi = 1 << 5,
	UIDeviceSupportsAccelerometer = 1 << 6,
	UIDeviceSupportsLocationServices = 1 << 7,
	UIDeviceSupportsGPS = 1 << 8,
	UIDeviceSupportsMagnetometer = 1 << 9,
	UIDeviceSupportsBuiltInMicrophone = 1 << 10,
	UIDeviceSupportsExternalMicrophone = 1 << 11,
	UIDeviceSupportsOPENGLES1_1 = 1 << 12,
	UIDeviceSupportsOPENGLES2 = 1 << 13,
	UIDeviceSupportsBuiltInSpeaker = 1 << 14,
	UIDeviceSupportsVibration = 1 << 15,
	UIDeviceSupportsBuiltInProximitySensor = 1 << 16,
	UIDeviceSupportsAccessibility = 1 << 17,
	UIDeviceSupportsVoiceOver = 1 << 18,
	UIDeviceSupportsVoiceControl = 1 << 19,
	UIDeviceSupportsBrightnessSensor = 1 << 20,
	UIDeviceSupportsPeerToPeer = 1 << 21,
	UIDeviceSupportsARMV7 = 1 << 22,
	UIDeviceSupportsEncodeAAC = 1 << 23,
	UIDeviceSupportsBluetooth = 1 << 24,
	UIDeviceSupportsNike = 1 << 25,
	UIDeviceSupportsPiezoClicker = 1 << 26,
	UIDeviceSupportsVolumeButtons = 1 << 27,
	UIDeviceSupportsEnhancedMultitouch = 1 << 28, // http://www.boygeniusreport.com/2010/01/13/apples-tablet-is-an-iphone-on-steroids/
    UIDeviceSupportsCameraFlash = 1 << 29,
    UIDeviceSupportsDisplayPort = 1 << 30,
    UIDeviceSupportsFrontFacingCamera = 1 << 31,
    //    UIDeviceSupportsGyroscope = 1 << 32
} UIDeviceCapabilities;

@interface UIDevice (Hardware)
- (NSString *) platform;
+ (UIDeviceCapabilities) platformCapabilities: (UIDevicePlatform) platform;
- (UIDeviceCapabilities) platformCapabilities;
- (NSString *) hwmodel;
- (NSUInteger) platformType;
- (NSString *) platformString;

- (NSUInteger) cpuFrequency;
- (NSUInteger) busFrequency;
- (NSUInteger) totalMemory;
- (NSUInteger) userMemory;

- (NSNumber *) totalDiskSpace;
- (NSNumber *) freeDiskSpace;

- (NSString *) macaddress;
@end