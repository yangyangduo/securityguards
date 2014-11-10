//
//  ScoringTools.m
//  securityguards
//
//  Created by Zhao yang on 8/18/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ScoringTools.h"
#import "Sensor.h"

@implementation ScoringTools

+ (NSNumber *)scoringForUnit:(Unit *)unit {
    if(unit == nil) return nil;
    float score = 0.f;
    
    /*
     *  range of sensor data value is [ >=1 && <= 6]
     */
    float pm25Score = 0.f;
    float vocScore = 0.f;
    float cameraScore = 0.f;
    float bodyDetectorScore = 0.f;
    float smokeDetectorScore = 0.f;
    
    for(Sensor *sensor in unit.sensors) {
        if(sensor.isPM25Sensor) {
            int pm25Value = (int)sensor.data.value;
            pm25Value = (pm25Value / 50) + 1;
            if(pm25Value > 6) pm25Value = 6;
            pm25Score = (6 - pm25Value) * 7.f;
            if(pm25Score > 35.f) pm25Score = 35.f;
        } else if(sensor.isVOCSensor) {
            vocScore = (6 - sensor.data.value) * 3.f;
            if(vocScore > 15.f) vocScore = 15.f;
        }
    }
    
    for(Device *device in unit.devices) {
        if(device.isCamera && device.isOnline) {
            cameraScore = 15.f;
        } else if(device.isBodyDetector) {
            if(device.isOnline) {
                if(device.isLowBattery && bodyDetectorScore < 5.f) {
                    bodyDetectorScore = 5.f;
                } else {
                    bodyDetectorScore = 10.f;
                }
            }
        } else if(device.isSmokeDetector) {
            if(device.isOnline) {
                if(device.isLowBattery && smokeDetectorScore < 5.f) {
                    smokeDetectorScore = 5.f;
                } else {
                    smokeDetectorScore = 15.f;
                }
            }
        }
    }
    
    score = pm25Score + vocScore + cameraScore + bodyDetectorScore + smokeDetectorScore;
    if(score > 90.f) score = 90.f;

#ifdef DEBUG
    //NSLog(@"Score [pm25=%.0f, voc=%.0f, camera=%.0f, body_detector=%.0f, smoke_detector=%.0f]",
            //pm25Score, vocScore, cameraScore, bodyDetectorScore, smokeDetectorScore);
#endif
    
    return [NSNumber numberWithFloat:score];
}

/*
 0: 超过0%用户
 10：超过6%用户
 20：超过17%用户
 30：超过38%用户
 40：超过41%用户
 50：超过56%用户
 60：超过62%用户
 70：超过68%用户
 80：超过87%用户
 90：超过94%用户
 */
+ (float)rankingForScore:(float)score {
    if(score == 0) return 0.f;
    if(score < 10) return 0.06f;
    if(score < 20) return 0.17f;
    if(score < 30) return 0.38f;
    if(score < 40) return 0.41f;
    if(score < 50) return 0.56f;
    if(score < 60) return 0.62f;
    if(score < 70) return 0.68f;
    if(score < 80) return 0.87f;
    if(score < 90) return 0.94f;
    return 0.f;
}

@end
