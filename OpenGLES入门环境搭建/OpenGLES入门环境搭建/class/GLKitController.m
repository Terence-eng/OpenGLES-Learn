//
//  GLKitController.m
//  OpenGLES入门环境搭建
//
//  Created by 陈伟鑫 on 2017/5/4.
//  Copyright © 2017年 陈伟鑫. All rights reserved.
//

#import "GLKitController.h"

@implementation GLKitController
- (void)viewDidLoad {
    GLKView *view = (GLKView *)self.view;
    view.context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:view.context];
    
    // 设置当前上下文的“清除颜色”为黑色，意思就是设置当前上下文的背景颜色
    glClearColor(0.5f, 0.5f, 1.0f, 1.0f);
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClear(GL_COLOR_BUFFER_BIT);
}

- (void)dealloc {
    NSLog(@"%@ delloc",[self class]);
}
@end
