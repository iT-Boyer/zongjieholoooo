//
//  TopsGetBlueMac.m
//  Tops
//
//  Created by Ding Sheng on 13-4-19.
//  Copyright (c) 2013年 鼎晟中天. All rights reserved.
//

#import "TopsGetBlueMac.h"

#include <sys/types.h>

#include <sys/socket.h>

#include <ifaddrs.h>

#include <netdb.h>

#include <net/if_dl.h>

#include <string.h>

@implementation TopsGetBlueMac


#if ! defined(IFT_ETHER)
 
#define IFT_ETHER 0x6/* Ethernet CSMACD */
 
#endif
 
void doMacTest() {
     
    BOOL                        success;
     
    struct ifaddrs *            addrs;
     
    const struct ifaddrs *      cursor;
     
    const struct sockaddr_dl *  dlAddr;
     
    const uint8_t *             base;
    
    // We look for interface "en0" on iPhone
     
    
    success = getifaddrs(&addrs) == 0;
     
    if (success) {
         
        cursor = addrs;
        //将mac保存在NSUserDefaults
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        while (cursor != NULL) {
            
            if ( (cursor->ifa_addr->sa_family == AF_LINK)
                 
                && (((const struct sockaddr_dl *) cursor->ifa_addr)->sdl_type == IFT_ETHER)
                 
                && (strcmp(cursor->ifa_name, "en0") == 0)) {
                
                dlAddr = (const struct sockaddr_dl *) cursor->ifa_addr;
                 
                base = (const uint8_t *) &dlAddr->sdl_data[dlAddr->sdl_nlen];
               
                if (dlAddr->sdl_alen == 6) {
                    
                    fprintf(stderr, ">>> WIFI MAC ADDRESS: %02x:%02x:%02x:%02x:%02x:%02x\n", base[0], base[1], base[2], base[3], base[4], base[5]);
                    [userDefaults setObject:[NSString localizedStringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x",base[0], base[1], base[2], base[3], base[4], base[5]] forKey:WifiMACKEY];
                    
                    
                    fprintf(stderr, ">>> IPAD BLUETOOTH MAC ADDRESS: %02x:%02x:%02x:%02x:%02x:%02x\n", base[0], base[1], base[2], base[3], base[4], base[5]-1);
                    [userDefaults setObject:[NSString localizedStringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x",base[0], base[1], base[2], base[3], base[4], base[5]-1] forKey:IpadBlueToothMAC];
                     
                    fprintf(stderr, ">>>   IPHONE BLUETOOTH MAC ADDRESS: %02x:%02x:%02x:%02x:%02x:%02x\n", base[0], base[1], base[2], base[3], base[4], base[5]+1);
                    [userDefaults setObject:[NSString localizedStringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x",base[0], base[1], base[2], base[3], base[4], base[5]+1] forKey:BlueToothMACKEY];
                     
                } else {
                     
                    fprintf(stderr, "ERROR - len is not 6");
                     
                }
 
            }
             
            cursor = cursor->ifa_next;
             
        }

        freeifaddrs(addrs);
    }
   
}
@end
