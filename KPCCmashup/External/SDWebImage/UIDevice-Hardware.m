/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 5.0 Edition
 BSD License, Use at your own risk
 */

// Thanks to Emanuele Vulcano, Kevin Ballard/Eridius, Ryandjohnson, Matt Brown, etc.

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#import "UIDevice-Hardware.h"

@implementation UIDevice (Hardware)
/*
 Platforms
 
 iFPGA ->        ??
 
 iPhone1,1 ->    iPhone 1G, M68
 iPhone1,2 ->    iPhone 3G, N82
 iPhone2,1 ->    iPhone 3GS, N88
 iPhone3,1 ->    iPhone 4/AT&T, N89
 iPhone3,2 ->    iPhone 4/Other Carrier?, ??
 iPhone3,3 ->    iPhone 4/Verizon, TBD
 iPhone4,1 ->    (iPhone 5/AT&T), TBD
 iPhone4,2 ->    (iPhone 5/Verizon), TBD
 
 iPod1,1   ->    iPod touch 1G, N45
 iPod2,1   ->    iPod touch 2G, N72
 iPod2,2   ->    Unknown, ??
 iPod3,1   ->    iPod touch 3G, N18
 iPod4,1   ->    iPod touch 4G, N80
 
 // Thanks NSForge
 iPad1,1   ->    iPad 1G, WiFi and 3G, K48
 iPad2,1   ->    iPad 2G, WiFi, K93
 iPad2,2   ->    iPad 2G, GSM 3G, K94
 iPad2,3   ->    iPad 2G, CDMA 3G, K95
 iPad3,1   ->    (iPad 3G, GSM)
 iPad3,2   ->    (iPad 3G, CDMA)
 
 AppleTV2,1 ->   AppleTV 2, K66
 
 i386, x86_64 -> iPhone Simulator
 */
/* Since many of the devices have includes, it makes sense to define an unnamed enum here for adding devices. */
enum {
    /* iPhone 1st gen */
    PlatformCapabilitiesM68 = (UIDeviceSupportsTelephony  |
                               UIDeviceSupportsSMS  |
                               UIDeviceSupportsStillCamera  |
                               // UIDeviceSupportsAutofocusCamera |
                               // UIDeviceSupportsVideoCamera  |
                               UIDeviceSupportsWifi  |
                               UIDeviceSupportsAccelerometer  |
                               UIDeviceSupportsLocationServices  |
                               // UIDeviceSupportsGPS  |
                               // UIDeviceSupportsMagnetometer  |
                               UIDeviceSupportsBuiltInMicrophone  |
                               UIDeviceSupportsExternalMicrophone  |
                               UIDeviceSupportsOPENGLES1_1  |
                               // UIDeviceSupportsOPENGLES2  |
                               UIDeviceSupportsBuiltInSpeaker  |
                               UIDeviceSupportsVibration  |
                               UIDeviceSupportsBuiltInProximitySensor  |
                               // UIDeviceSupportsAccessibility  |
                               // UIDeviceSupportsVoiceOver |
                               // UIDeviceSupportsVoiceControl |
                               // UIDeviceSupportsPeerToPeer |
                               // UIDeviceSupportsARMV7 |
                               UIDeviceSupportsBrightnessSensor |
                               UIDeviceSupportsEncodeAAC |
                               UIDeviceSupportsBluetooth | // M68.plist says YES for this
                               // UIDeviceSupportsNike |
                               // UIDeviceSupportsPiezoClicker |
                               UIDeviceSupportsVolumeButtons
                               ),
    
    /* iPhone 3G */
    PlatformCapabilitiesN82 = (UIDeviceSupportsTelephony  |
                               UIDeviceSupportsSMS  |
                               UIDeviceSupportsStillCamera  |
                               UIDeviceSupportsWifi  |
                               UIDeviceSupportsAccelerometer  |
                               UIDeviceSupportsLocationServices  |
                               UIDeviceSupportsGPS  |
                               UIDeviceSupportsBuiltInMicrophone  |
                               UIDeviceSupportsExternalMicrophone  |
                               UIDeviceSupportsOPENGLES1_1  |
                               UIDeviceSupportsBuiltInSpeaker  |
                               UIDeviceSupportsVibration  |
                               UIDeviceSupportsBuiltInProximitySensor  |
                               UIDeviceSupportsPeerToPeer |
                               UIDeviceSupportsBrightnessSensor |
                               UIDeviceSupportsEncodeAAC |
                               UIDeviceSupportsBluetooth |
                               UIDeviceSupportsVolumeButtons
                               ),
    /* iPhone 3GS */
    PlatformCapabilitiesN88 = (PlatformCapabilitiesN82 |            // include[0] = N82AP
                               UIDeviceSupportsAutofocusCamera |
                               UIDeviceSupportsVideoCamera  |
                               UIDeviceSupportsMagnetometer  |
                               UIDeviceSupportsOPENGLES2  |
                               UIDeviceSupportsAccessibility  |
                               UIDeviceSupportsVoiceOver |
                               UIDeviceSupportsVoiceControl |
                               UIDeviceSupportsARMV7 |
                               UIDeviceSupportsNike
                               ),
    /* iPhone 4 */
    PlatformCapabilitiesN90 = (PlatformCapabilitiesN88 |           // include[0] = N88AP
                               UIDeviceSupportsCameraFlash |       // camera-flash
                               UIDeviceSupportsDisplayPort |       // displayport
                               UIDeviceSupportsFrontFacingCamera  // front-facing-camera
                               //                               UIDeviceSupportsGyroscope           // gyroscope
                               // NOT INCLUDED: 720p=true, horiz=true, how-encode-snapshots=true, venice=true
                               ),
    /* iPod Touch 1st gen */
    PlatformCapabilitiesN45 = (UIDeviceSupportsWifi  |
                               UIDeviceSupportsAccelerometer  |
                               UIDeviceSupportsLocationServices  |
                               // UIDeviceSupportsGPS  |
                               // UIDeviceSupportsMagnetometer  |
                               // UIDeviceSupportsBuiltInMicrophone  |
                               UIDeviceSupportsExternalMicrophone  |
                               UIDeviceSupportsOPENGLES1_1  |
                               // UIDeviceSupportsOPENGLES2  |
                               // UIDeviceSupportsBuiltInSpeaker  |
                               // UIDeviceSupportsVibration  |
                               // UIDeviceSupportsBuiltInProximitySensor  |
                               // UIDeviceSupportsAccessibility  |
                               // UIDeviceSupportsVoiceOver |
                               // UIDeviceSupportsVoiceControl |
                               UIDeviceSupportsBrightnessSensor |
                               // UIDeviceSupportsEncodeAAC |
                               // UIDeviceSupportsBluetooth |
                               // UIDeviceSupportsNike |
                               UIDeviceSupportsPiezoClicker
                               // UIDeviceSupportsVolumeButtons
                               ),
    
    /* iPod Touch 2nd gen */
    PlatformCapabilitiesN72 = ((PlatformCapabilitiesN45 |        // include[0] = N45AP
                                UIDeviceSupportsBuiltInSpeaker  |
                                UIDeviceSupportsPeerToPeer |
                                UIDeviceSupportsBrightnessSensor |
                                UIDeviceSupportsEncodeAAC |
                                UIDeviceSupportsBluetooth |
                                UIDeviceSupportsNike |
                                UIDeviceSupportsVolumeButtons
                                )
                               ^(UIDeviceSupportsPiezoClicker) // piezo clicker removed in 2nd gen
                               ),
    
    /* iPod Touch 3rd gen */
    PlatformCapabilitiesN18 = (PlatformCapabilitiesN72 |        // include[0] = N72AP
                               UIDeviceSupportsOPENGLES2  |
                               UIDeviceSupportsAccessibility  |
                               UIDeviceSupportsVoiceOver |
                               UIDeviceSupportsVoiceControl |
                               UIDeviceSupportsPeerToPeer |
                               UIDeviceSupportsARMV7 |
                               UIDeviceSupportsBrightnessSensor
                               ),
    
    /* iPod Touch 4th gen */
    PlatformCapabilitiesN80 = (PlatformCapabilitiesN18),        // ASSUMPTION: N80 is a superset of predecessor N18
    
    
    /* iPad 1st gen */
    PlatformCapabilitiesK48 = (UIDeviceSupportsWifi  |
                               UIDeviceSupportsAccelerometer  |
                               UIDeviceSupportsLocationServices  |
                               // UIDeviceSupportsGPS  |
                               // UIDeviceSupportsMagnetometer  |
                               UIDeviceSupportsBuiltInMicrophone  |
                               UIDeviceSupportsExternalMicrophone  |
                               UIDeviceSupportsOPENGLES1_1  |
                               UIDeviceSupportsOPENGLES2  |
                               UIDeviceSupportsBuiltInSpeaker  |
                               // UIDeviceSupportsVibration  |
                               // UIDeviceSupportsBuiltInProximitySensor  |
                               UIDeviceSupportsAccessibility  |
                               UIDeviceSupportsVoiceOver |
                               UIDeviceSupportsVoiceControl |
                               UIDeviceSupportsPeerToPeer |
                               UIDeviceSupportsARMV7 |
                               UIDeviceSupportsBrightnessSensor |
                               UIDeviceSupportsEncodeAAC |
                               UIDeviceSupportsBluetooth |
                               UIDeviceSupportsNike |
                               // UIDeviceSupportsPiezoClicker |
                               UIDeviceSupportsVolumeButtons |
                               UIDeviceSupportsEnhancedMultitouch
                               ),
    
    /* iPad 1st gen. (3G) */
    PlatformCapabilitiesK48_3G = (UIDeviceSupportsSMS  |
                                  // UIDeviceSupportsStillCamera  |
                                  // UIDeviceSupportsAutofocusCamera |
                                  // UIDeviceSupportsVideoCamera  |
                                  UIDeviceSupportsWifi  |
                                  UIDeviceSupportsAccelerometer  |
                                  UIDeviceSupportsLocationServices  |
                                  UIDeviceSupportsGPS  |
                                  // UIDeviceSupportsMagnetometer  |
                                  UIDeviceSupportsBuiltInMicrophone  |
                                  UIDeviceSupportsExternalMicrophone  |
                                  UIDeviceSupportsOPENGLES1_1  |
                                  UIDeviceSupportsOPENGLES2  |
                                  UIDeviceSupportsBuiltInSpeaker  |
                                  // UIDeviceSupportsVibration  |
                                  // UIDeviceSupportsBuiltInProximitySensor  |
                                  UIDeviceSupportsAccessibility  |
                                  UIDeviceSupportsVoiceOver |
                                  UIDeviceSupportsVoiceControl |
                                  UIDeviceSupportsPeerToPeer |
                                  UIDeviceSupportsARMV7 |
                                  UIDeviceSupportsBrightnessSensor |
                                  UIDeviceSupportsEncodeAAC |
                                  UIDeviceSupportsBluetooth |
                                  UIDeviceSupportsNike |
                                  // UIDeviceSupportsPiezoClicker |
                                  UIDeviceSupportsVolumeButtons |
                                  UIDeviceSupportsEnhancedMultitouch
                                  ),
    
};

#pragma mark sysctlbyname utils
- (NSString *) getSysInfoByName:(char *)typeSpecifier
{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    
    free(answer);
    return results;
}

- (NSString *) platform
{
    return [self getSysInfoByName:"hw.machine"];
}


// Thanks, Tom Harrington (Atomicbird)
- (NSString *) hwmodel
{
    return [self getSysInfoByName:"hw.model"];
}

#pragma mark sysctl utils
- (NSUInteger) getSysInfo: (uint) typeSpecifier
{
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results;
}

- (NSUInteger) cpuFrequency
{
    return [self getSysInfo:HW_CPU_FREQ];
}

- (NSUInteger) busFrequency
{
    return [self getSysInfo:HW_BUS_FREQ];
}

- (NSUInteger) totalMemory
{
    return [self getSysInfo:HW_PHYSMEM];
}

- (NSUInteger) userMemory
{
    return [self getSysInfo:HW_USERMEM];
}

- (NSUInteger) maxSocketBufferSize
{
    return [self getSysInfo:KIPC_MAXSOCKBUF];
}

#pragma mark file system -- Thanks Joachim Bean!
- (NSNumber *) totalDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemSize];
}

- (NSNumber *) freeDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemFreeSize];
}

#pragma mark platform type and name utils
- (NSUInteger) platformType
{
    NSString *platform = [self platform];
    
    // The ever mysterious iFPGA
    if ([platform isEqualToString:@"iFPGA"])        return UIDeviceIFPGA;
    
    // iPhone
    if ([platform isEqualToString:@"iPhone1,1"])    return UIDevice1GiPhone;
    if ([platform isEqualToString:@"iPhone1,2"])    return UIDevice3GiPhone;
    if ([platform hasPrefix:@"iPhone2"])            return UIDevice3GSiPhone;
    if ([platform hasPrefix:@"iPhone3"])            return UIDevice4iPhone;
    if ([platform hasPrefix:@"iPhone4"])            return UIDevice5iPhone;
    
    // iPod
    if ([platform hasPrefix:@"iPod1"])             return UIDevice1GiPod;
    if ([platform hasPrefix:@"iPod2"])              return UIDevice2GiPod;
    if ([platform hasPrefix:@"iPod3"])              return UIDevice3GiPod;
    if ([platform hasPrefix:@"iPod4"])              return UIDevice4GiPod;
    
    // iPad
    if ([platform hasPrefix:@"iPad1"])              return UIDevice1GiPad;
    if ([platform hasPrefix:@"iPad2"])              return UIDevice2GiPad;
    if ([platform hasPrefix:@"iPad3"])              return UIDevice3GiPad;
    
    // Apple TV
    if ([platform hasPrefix:@"AppleTV2"])           return UIDeviceAppleTV2;
    
    if ([platform hasPrefix:@"iPhone"])             return UIDeviceUnknowniPhone;
    if ([platform hasPrefix:@"iPod"])               return UIDeviceUnknowniPod;
    if ([platform hasPrefix:@"iPad"])               return UIDeviceUnknowniPad;
    
    // Simulator thanks Jordan Breeding
    if ([platform hasSuffix:@"86"] || [platform isEqual:@"x86_64"])
    {
        BOOL smallerScreen = [[UIScreen mainScreen] bounds].size.width < 768;
        return smallerScreen ? UIDeviceiPhoneSimulatoriPhone : UIDeviceiPhoneSimulatoriPad;
    }
    
    return UIDeviceUnknown;
}

- (NSString *) platformString
{
    switch ([self platformType])
    {
        case UIDevice1GiPhone: return IPHONE_1G_NAMESTRING;
        case UIDevice3GiPhone: return IPHONE_3G_NAMESTRING;
        case UIDevice3GSiPhone: return IPHONE_3GS_NAMESTRING;
        case UIDevice4iPhone: return IPHONE_4_NAMESTRING;
        case UIDevice5iPhone: return IPHONE_5_NAMESTRING;
        case UIDeviceUnknowniPhone: return IPHONE_UNKNOWN_NAMESTRING;
            
        case UIDevice1GiPod: return IPOD_1G_NAMESTRING;
        case UIDevice2GiPod: return IPOD_2G_NAMESTRING;
        case UIDevice3GiPod: return IPOD_3G_NAMESTRING;
        case UIDevice4GiPod: return IPOD_4G_NAMESTRING;
        case UIDeviceUnknowniPod: return IPOD_UNKNOWN_NAMESTRING;
            
        case UIDevice1GiPad : return IPAD_1G_NAMESTRING;
        case UIDevice2GiPad : return IPAD_2G_NAMESTRING;
        case UIDevice3GiPad : return IPAD_3G_NAMESTRING;
        case UIDeviceUnknowniPad : return IPAD_UNKNOWN_NAMESTRING;
            
        case UIDeviceAppleTV2 : return APPLETV_2G_NAMESTRING;
        case UIDeviceUnknownAppleTV: return APPLETV_UNKNOWN_NAMESTRING;
            
        case UIDeviceiPhoneSimulator: return IPHONE_SIMULATOR_NAMESTRING;
        case UIDeviceiPhoneSimulatoriPhone: return IPHONE_SIMULATOR_IPHONE_NAMESTRING;
        case UIDeviceiPhoneSimulatoriPad: return IPHONE_SIMULATOR_IPAD_NAMESTRING;
            
        case UIDeviceIFPGA: return IFPGA_NAMESTRING;
            
        default: return IOS_FAMILY_UNKNOWN_DEVICE;
    }
}

#pragma mark  platform capabilities
+ (UIDeviceCapabilities) platformCapabilities: (UIDevicePlatform) platform {
    switch (platform) {
        case UIDevice1GiPhone:
            return PlatformCapabilitiesM68;
            
        case UIDevice3GiPhone:
            return PlatformCapabilitiesN82;
            
        case UIDevice3GSiPhone:
            return PlatformCapabilitiesN88;
            
        case UIDevice4GiPhone:
        case UIDeviceFutureiPhone: // ASSUMPTION: Future iPhones will be a superset of 4th gen
            return PlatformCapabilitiesN90;
            
        case UIDeviceUnknowniPhone: return UIDeviceUnknownCapabilities;
            
        case UIDevice1GiPod:
            return PlatformCapabilitiesN45;
            
        case UIDevice2GiPod:
        case UIDevice2GPlusiPod:
            return PlatformCapabilitiesN72;
            
            
        case UIDevice3GiPod:
            return PlatformCapabilitiesN18;
            
        case UIDevice4GiPod:
        case UIDeviceFutureiPod: // ASSUMPTION: Future iPods will be a superset of 4th gen
            return PlatformCapabilitiesN80;
            
        case UIDeviceUnknowniPod:  return UIDeviceUnknownCapabilities;
            
        case UIDevice1GiPad:
            return PlatformCapabilitiesK48;
            
        case UIDevice1GiPad3G:
            return PlatformCapabilitiesK48_3G;
            
        case UIDeviceFutureiPad: // ASSUMPTION: Future iPads will be a superset of 1st gen.  Can't assume 3G yet though.
            return PlatformCapabilitiesK48;
            
        case UIDeviceiPhoneSimulator:
        case UIDeviceiPhoneSimulatoriPhone:
            return
            ( // UIDeviceSupportsTelephony  |
             // UIDeviceSupportsSMS  |
             // UIDeviceSupportsStillCamera  |
             // UIDeviceSupportsAutofocusCamera |
             // UIDeviceSupportsVideoCamera  |
             UIDeviceSupportsWifi  |
             // UIDeviceSupportsAccelerometer  |
             UIDeviceSupportsLocationServices  |
             // UIDeviceSupportsGPS  |
             // UIDeviceSupportsMagnetometer  |
             // UIDeviceSupportsBuiltInMicrophone  |
             // UIDeviceSupportsExternalMicrophone  |
             UIDeviceSupportsOPENGLES1_1  |
             // UIDeviceSupportsOPENGLES2  |
             UIDeviceSupportsAccessibility  | // with limitations
             UIDeviceSupportsVoiceOver | // with limitations
             UIDeviceSupportsBuiltInSpeaker
             // UIDeviceSupportsVibration  |
             // UIDeviceSupportsBuiltInProximitySensor  |
             // UIDeviceSupportsVoiceControl |
             // UIDeviceSupportsPeerToPeer |
             // UIDeviceSupportsARMV7 |
             // UIDeviceSupportsBrightnessSensor |
             // UIDeviceSupportsEncodeAAC |
             // UIDeviceSupportsBluetooth |
             // UIDeviceSupportsNike |
             // UIDeviceSupportsPiezoClicker |
             // UIDeviceSupportsVolumeButtons
             );
            
        case UIDeviceiPhoneSimulatoriPad:
            return
            ( // UIDeviceSupportsTelephony  |
             // UIDeviceSupportsSMS  |
             // UIDeviceSupportsStillCamera  |
             // UIDeviceSupportsAutofocusCamera |
             // UIDeviceSupportsVideoCamera  |
             UIDeviceSupportsWifi  |
             // UIDeviceSupportsAccelerometer  |
             UIDeviceSupportsLocationServices  |
             // UIDeviceSupportsGPS  |
             // UIDeviceSupportsMagnetometer  |
             // UIDeviceSupportsBuiltInMicrophone  |
             // UIDeviceSupportsExternalMicrophone  |
             UIDeviceSupportsOPENGLES1_1  |
             UIDeviceSupportsOPENGLES2  |
             UIDeviceSupportsAccessibility  | // with limitations
             UIDeviceSupportsVoiceOver | // with limitations
             UIDeviceSupportsBuiltInSpeaker
             // UIDeviceSupportsVibration  |
             // UIDeviceSupportsBuiltInProximitySensor  |
             // UIDeviceSupportsVoiceControl |
             // UIDeviceSupportsPeerToPeer |
             // UIDeviceSupportsARMV7 |
             // UIDeviceSupportsBrightnessSensor |
             // UIDeviceSupportsEncodeAAC |
             // UIDeviceSupportsBluetooth |
             // UIDeviceSupportsNike |
             // UIDeviceSupportsPiezoClicker |
             // UIDeviceSupportsVolumeButtons
             );
            
        default: return UIDeviceUnknownCapabilities;
    }
}

- (UIDeviceCapabilities) platformCapabilities {
    return [UIDevice platformCapabilities: [self platformType]];
}

// Courtesy of Danny Sung <dannys@mail.com>
- (BOOL) platformHasCapability: (UIDeviceCapabilities) capability {
    if ( ([self platformCapabilities] & capability) == capability)
        return YES;
    return NO;
}

- (NSArray*) capabilityArray {
    UIDeviceCapabilities flags = [self platformCapabilities];
    NSMutableArray* array = [NSMutableArray array];
    
    if (flags & UIDeviceSupportsTelephony) [array addObject: @"Telephony"];
    if (flags & UIDeviceSupportsSMS) [array addObject: @"SMS"];
    if (flags & UIDeviceSupportsStillCamera) [array addObject: @"Still Camera"];
    if (flags & UIDeviceSupportsAutofocusCamera) [array addObject: @"AutoFocus Camera"];
    if (flags & UIDeviceSupportsVideoCamera) [array addObject: @"Video Camera"];
    
    if (flags & UIDeviceSupportsWifi) [array addObject: @"WiFi"];
    if (flags & UIDeviceSupportsAccelerometer) [array addObject: @"Accelerometer"];
    if (flags & UIDeviceSupportsLocationServices) [array addObject: @"Location Services"];
    if (flags & UIDeviceSupportsGPS) [array addObject: @"GPS"];
    if (flags & UIDeviceSupportsMagnetometer) [array addObject: @"Magnetometer"];
    
    if (flags & UIDeviceSupportsBuiltInMicrophone) [array addObject: @"Built-in Microphone"];
    if (flags & UIDeviceSupportsExternalMicrophone) [array addObject: @"External Microphone Support"];
    if (flags & UIDeviceSupportsOPENGLES1_1) [array addObject: @"OpenGL ES 1.1"];
    if (flags & UIDeviceSupportsOPENGLES2) [array addObject: @"OpenGL ES 2.x"];
    if (flags & UIDeviceSupportsBuiltInSpeaker) [array addObject: @"Built-in Speaker"];
    
    if (flags & UIDeviceSupportsVibration) [array addObject: @"Vibration"];
    if (flags & UIDeviceSupportsBuiltInProximitySensor) [array addObject: @"Proximity Sensor"];
    if (flags & UIDeviceSupportsAccessibility) [array addObject: @"Accessibility"];
    if (flags & UIDeviceSupportsVoiceOver) [array addObject: @"VoiceOver"];
    if (flags & UIDeviceSupportsVoiceControl) [array addObject: @"Voice Control"];
    
    if (flags & UIDeviceSupportsBrightnessSensor) [array addObject: @"Brightness Sensor"];
    if (flags & UIDeviceSupportsPeerToPeer) [array addObject: @"Peer to Peer Bluetooth"];
    if (flags & UIDeviceSupportsARMV7) [array addObject: @"The armv7 instruction set"];
    if (flags & UIDeviceSupportsEncodeAAC) [array addObject: @"AAC Encoding"];
    if (flags & UIDeviceSupportsBluetooth) [array addObject: @"Basic Bluetooth"];
    
    if (flags & UIDeviceSupportsNike) [array addObject: @"Nike"];
    if (flags & UIDeviceSupportsPiezoClicker) [array addObject: @"Piezo clicker"];
    if (flags & UIDeviceSupportsVolumeButtons) [array addObject: @"Physical volume rocker"];
    
    if (flags & UIDeviceSupportsEnhancedMultitouch) [array addObject: @"Enhanced Multitouch"];
    
    if (flags & UIDeviceSupportsCameraFlash) [array addObject: @"Camera Flash"];
    if (flags & UIDeviceSupportsDisplayPort) [array addObject: @"Display Port"];
    if (flags & UIDeviceSupportsFrontFacingCamera) [array addObject: @"Front-Facing Camera"];
    // if (flags & UIDeviceSupportsGyroscope) [array addObject: @"Gryoscope"];
    
    return array;
}

- (NSString*) platformCode {
    switch ([self platformType]) {
        case UIDevice1GiPhone: return @"M68";
        case UIDevice3GiPhone: return @"N82";
        case UIDevice3GSiPhone: return @"N88";
        case UIDevice4GiPhone: return @"N90"; // cdonnelly 2010-06-25: not N89 as previously listed.  SDK lists as N90
        case UIDeviceUnknowniPhone: return IPHONE_UNKNOWN_NAMESTRING;
            
        case UIDevice1GiPod: return @"N45";
        case UIDevice2GiPod: return @"N72";
        case UIDevice3GiPod: return @"N18";
        case UIDevice4GiPod: return @"N80";
        case UIDeviceUnknowniPod: return IPOD_UNKNOWN_NAMESTRING;
            
        case UIDevice1GiPad: return @"K48";
        case UIDevice1GiPad3G: return @"K48";  // placeholder
            
        case UIDeviceiPhoneSimulator: return IPHONE_SIMULATOR_NAMESTRING;
        case UIDeviceiPhoneSimulatoriPad: return IPHONE_SIMULATOR_NAMESTRING;
        case UIDeviceiPhoneSimulatoriPhone: return IPHONE_SIMULATOR_NAMESTRING;
            
        default: return IPOD_FAMILY_UNKNOWN_DEVICE;
    }
}


#pragma mark MAC addy
// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to mlamb.
- (NSString *) macaddress
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    // NSString *outstring = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X", 
    //                       *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

// Illicit Bluetooth check -- cannot be used in App Store
/* 
 Class  btclass = NSClassFromString(@"GKBluetoothSupport");
 if ([btclass respondsToSelector:@selector(bluetoothStatus)])
 {
 printf("BTStatus %d\n", ((int)[btclass performSelector:@selector(bluetoothStatus)] & 1) != 0);
 bluetooth = ((int)[btclass performSelector:@selector(bluetoothStatus)] & 1) != 0;
 printf("Bluetooth %s enabled\n", bluetooth ? "is" : "isn't");
 }
 */
@end