//
//  main.m
//  shutdown
//
//  Created by 七味 on 2014/11/01.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <AppleScriptObjC/AppleScriptObjC.h>

int main(int argc, const char * argv[])
{
    [[NSBundle mainBundle] loadAppleScriptObjectiveCScripts];
    return NSApplicationMain(argc, argv);
}
