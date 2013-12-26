//
//  RestfulCommandService.h
//  SmartHome
//
//  Created by Zhao yang on 9/2/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ServiceBase.h"
#import "CommandExecutor.h"
#import "CommandFactory.h"

@interface RestfulCommandService : ServiceBase<CommandExecutor>

/*
 Units list
 ----------------------------------------------------*/
- (void)getUnitByUrl:(NSString *)url;
- (void)getUnitByIdentifier:(NSString *)unitIdentifier address:(NSString *)addr port:(NSInteger)port hashCode:(NSNumber *)hashCode;

/*
 Key control
 ----------------------------------------------------*/


/*
 Restful Service Callback Method
 ----------------------------------------------------*/
- (void)getUnitSucess:(RestResponse *)resp;
- (void)getUnitFailed:(RestResponse *)resp;

@end
