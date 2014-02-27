//
//  AQIManager.m
//  securityguards
//
//  Created by Zhao yang on 2/20/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "AQIManager.h"
#import "XXEventSubscriptionPublisher.h"
#import "RestClient.h"
#import "JsonUtils.h"
#import "GlobalSettings.h"

#define LOCATION_REFRESH_INTERVAL 1 * 60 * 60
#define DIRECTORY [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"familyguards-aqi"]

@implementation AQIManager {
    NSMutableDictionary *aqiInfo;
    CLLocationManager *locationManager;
}

@synthesize currentAqiInfo = _currentAqiInfo_;

@synthesize locationIsUpdating;
@synthesize locationLastRefreshDate;
@synthesize locationCoordinate;

+ (instancetype)manager {
    static AQIManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AQIManager alloc] init];
    });
    return manager;
}

- (id)init {
    self = [super init];
    if(self) {
        aqiInfo = [NSMutableDictionary dictionary];
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        
        [self readFromDisk];
    }
    return self;
}

- (void)mayUpdateAqi {
    if(self.locationLastRefreshDate == nil
       || abs(self.locationLastRefreshDate.timeIntervalSinceNow) >= LOCATION_REFRESH_INTERVAL) {
        if(!self.locationIsUpdating) {
            self.locationIsUpdating = YES;
            self.locationLastRefreshDate = [NSDate date];
            [locationManager startUpdatingLocation];
        }
    } else {
#ifdef DEBUG
        NSLog(@"[AQI MANAGER] Don't need to update current location .");
#endif
    }
}

- (AQIDetail *)aqiDetailForArea:(NSString *)area {
    if(area == nil) return nil;
    return [aqiInfo objectForKey:area];
}

- (void)addAqiDetail:(AQIDetail *)aqiDetail forArea:(NSString *)area {
    if(aqiDetail == nil) return;
    [aqiInfo setObject:aqiDetail forKey:area];
}

- (void)removeAqiDetailViaArea:(NSString *)area {
    if(area == nil) return;
    [aqiInfo removeObjectForKey:area];
}

- (void)readFromDisk {
    @synchronized(self) {
        NSString *filePath = [DIRECTORY stringByAppendingPathComponent:[NSString stringWithFormat:@"aqi.txt"]];
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
            NSDictionary *json = [JsonUtils createDictionaryFromJson:data];
            if(json != nil) {
                // set refresh date
                NSNumber *lastRefreshDate = [json objectForKey:@"locationLastRefreshDate"];
                if(lastRefreshDate != nil) {
                    self.locationLastRefreshDate = [NSDate dateWithTimeIntervalSince1970:lastRefreshDate.doubleValue];
                }
                
                // set current area
                NSString *currentArea = [json stringForKey:@"currentArea"];
                if(currentArea != nil) {
                    NSDictionary *allDetails = [json dictionaryForKey:@"aqiDetails"];
                    if(allDetails != nil) {
                        NSDictionary *aqiInfo_ = [allDetails dictionaryForKey:currentArea];
                        if(aqiInfo_ != nil) {
                            _currentAqiInfo_ = [[AQIDetail alloc] initWithJson:aqiInfo_];
                        } else {
                            self.locationLastRefreshDate = nil;
                        }
                    } else {
                        self.locationLastRefreshDate = nil;
                    }
                } else {
                    self.locationLastRefreshDate = nil;
                }
                
                // set coordinate
                CLLocationCoordinate2D coordinate;
                coordinate.latitude = [json doubleForKey:@"longitude"];
                coordinate.longitude = [json doubleForKey:@"latitude"];
                self.locationCoordinate = coordinate;
            }
        }
    }
}

- (void)saveToDisk {
    @synchronized(self) {
        BOOL directoryExists = [[NSFileManager defaultManager] fileExistsAtPath:DIRECTORY];
        // if dir doesn't exists, create new
        if(!directoryExists) {
            NSError *error;
            BOOL createDirSuccess = [[NSFileManager defaultManager] createDirectoryAtPath:DIRECTORY withIntermediateDirectories:YES attributes:nil error:&error];
            if(!createDirSuccess) {
#ifdef DEBUG
                NSLog(@"[AQI MANAGER] Create directory for aqi failed , error >>> %@", error.description);
#endif
                return;
            }
        }
        
        // remove old file
        NSString *filePath = [DIRECTORY stringByAppendingPathComponent:[NSString stringWithFormat:@"aqi.txt"]];
        BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
        if(exists) {
            NSError *error;
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
#ifdef DEBUG
            if(error) {
                NSLog(@"[AQI MANAGER] Remove aqi file failed. error >>>>  %@", error.description);
            }
#endif
        }
        
        if(aqiInfo.count == 0) return;
        
        // create new file
        
        NSArray *allKeys = aqiInfo.allKeys;
        NSMutableDictionary *aqiDetailsDictionary = [NSMutableDictionary dictionary];
        for(NSString *key in allKeys) {
            AQIDetail *aqiDetails = [aqiInfo objectForKey:key];
            [aqiDetailsDictionary setObject:[aqiDetails toJson] forKey:key];
        }
        NSMutableDictionary *shouldBeSaved = [NSMutableDictionary dictionary];
        [shouldBeSaved setObject:aqiDetailsDictionary forKey:@"aqiDetails"];
        [shouldBeSaved setObject:[NSNumber numberWithDouble:locationCoordinate.latitude] forKey:@"latitude"];
        [shouldBeSaved setObject:[NSNumber numberWithDouble:locationCoordinate.longitude] forKey:@"longitude"];
        
        if(self.currentAqiInfo != nil) {
            [shouldBeSaved setNoBlankString:self.currentAqiInfo.area forKey:@"currentArea"];
        }
        
        if(self.locationLastRefreshDate != nil) {
            [shouldBeSaved setObject:[NSNumber numberWithDouble:self.locationLastRefreshDate.timeIntervalSince1970] forKey:@"locationLastRefreshDate"];
        }

        NSData *data = [JsonUtils createJsonDataFromDictionary:shouldBeSaved];

        BOOL success = [data writeToFile:filePath atomically:YES];
        if(!success) {
#ifdef DEBUG
            NSLog(@"[AQI MANAGER] Save aqi failed ...");
#endif
        } else {
#ifdef DEBUG
            NSLog(@"[AQI MANAGER] Save aqi successed ...");
#endif
        }
    }
}

#pragma mark -
#pragma mark Core Location Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if(!self.locationIsUpdating || (locations == nil || locations.count == 0)) return;
    
    self.locationIsUpdating = NO;
    [manager stopUpdatingLocation];
    
    CLLocation *location = [locations lastObject];
    locationCoordinate = location.coordinate;
#ifdef DEBUG
    NSLog(@"[AQI MANAGER] Location Updated (longitude=%f,latitude=%f)", locationCoordinate.longitude, locationCoordinate.latitude);
#endif
    RestClient *client = [[RestClient alloc] initWithBaseUrl:[GlobalSettings defaultSettings].restAddress];
    NSString *url = [NSString stringWithFormat:@"/aqi/%f,%f?deviceCode=%@&appKey=%@&security=%@",
                     locationCoordinate.latitude, locationCoordinate.longitude,
                     [GlobalSettings defaultSettings].deviceCode, APP_KEY,
                     [GlobalSettings defaultSettings].secretKey];
    
    [client getForUrl:url acceptType:@"text/html" success:@selector(getAqiInfoSuccess:) error:@selector(getAqiInfoFailed:) for:self callback:nil];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
#ifdef DEBUG
    NSLog(@"[AQI MANAGER] Get location failed.");
#endif
    [manager stopUpdatingLocation];
    self.locationIsUpdating = NO;
}

#pragma mark -
#pragma mark AQI Service Callback

- (void)getAqiInfoSuccess:(RestResponse *)resp {
    if(resp.statusCode == 200) {
        NSDictionary *json = [JsonUtils createDictionaryFromJson:resp.body];
        if(json != nil) {
            int result = [json intForKey:@"i"];
            if(result == 1) {
                AQIDetail *aqiDetail = [[AQIDetail alloc] initWithJson:json];
                [self addAqiDetail:aqiDetail forArea:aqiDetail.area];
                _currentAqiInfo_ = aqiDetail;
                [self saveToDisk];
                CurrentLocationUpdatedEvent *event = [[CurrentLocationUpdatedEvent alloc] initWithAqiDetail:aqiDetail];
                [[XXEventSubscriptionPublisher defaultPublisher] publishWithEvent:event];
                return;
            } else if(result == 0) {
                _currentAqiInfo_ = nil;
                [self saveToDisk];
                CurrentLocationUpdatedEvent *event = [[CurrentLocationUpdatedEvent alloc] initWithAqiDetail:nil];
                [[XXEventSubscriptionPublisher defaultPublisher] publishWithEvent:event];
                return;
            }
        }
    }
    [self getAqiInfoFailed:resp];
}

- (void)getAqiInfoFailed:(RestResponse *)resp {
#ifdef DEBUG
    NSLog(@"[AQI MANAGER] Get Aqi failed, status code is %d.", resp.statusCode);
#endif
}

@end
