//
//  OpenGLESView.m
//  OpenGLES入门环境搭建
//
//  Created by 陈伟鑫 on 2017/5/4.
//  Copyright © 2017年 陈伟鑫. All rights reserved.
//

#import "OpenGLESView.h"
#import <OpenGLES/ES2/gl.h>

@interface OpenGLESView ()
{
    EAGLContext *_context;//上下文
    CAEAGLLayer *_eagllayer; //画布
    GLuint _colorRenderBuffer; //颜色渲染缓存
    GLuint _frameBuffer; //帧缓存 FBO
    
}
@end

@implementation OpenGLESView

/**
 每一个UIView 实例都有一个相关联的被Cocoa Touch 按需自动创建的coreAnimation 层。
 Cocoa Touch 会调用"+layerClass"方法来确定要创建什么类型的层。
 当Cocoa Touch调用 OpenGLESView 实现的 “+layerClass”方法时。
 它被告知要使用一个 CAEAGLLayer 类的实例，而不是原先的 CALayer.
 CAEAGLLayer 是coreAnimation 提供的标准层类之一。
 CAEAGLLayer会与一个OpenGL ES 的帧缓存共享它的像素颜色仓库。
 */
+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupContext];
        [self setupEAGLLayer];
    }
    return self;
}


/**
 任何在接受到视图重新调整大小的消息时候，Cocoa Touch都会调用下面的layoutSubviews方法
 视图附属的帧缓存和像素颜色缓存渲染取决于视图的尺寸，视图会自动调整相关层的尺寸。
 上下文的“renderbufferStorage：fromDrawable:”方法会调整视图的缓存的尺寸以匹配层的新尺寸
 layoutSubviews在以下情况会被调用
 1、init初始化不会触发layoutSubviews 
 2、addSubview会触发layoutSubviews 
 3、设置view的Frame会触发layoutSubviews，当然前提是frame的值设置前后发生了变化
 4、滚动一个UIScrollView会触发layoutSubviews
 5、旋转Screen会触发父UIView上的layoutSubviews事件
 6、改变一个UIView大小的时候也会触发父UIView上的layoutSubviews事件
 */
- (void)layoutSubviews {
    [EAGLContext setCurrentContext:_context];
    [self destoryColorRenderAndFrameBuffer];
    [self setupFrameAndColorRenderBuffer];
    [self render];
}
#pragma mark -- setup
- (void)setupContext {
    // 设置OpenGLES的版本为2.0
    if (_context == nil) {
        _context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
        // 设置当前上下文为我们创建的上下文
        [EAGLContext setCurrentContext:_context];
    }
    
    
}
- (void)setupEAGLLayer {
    _eagllayer = (CAEAGLLayer *)self.layer;
    
    // CALayer 默认是透明的，必须将它设为不透明才能让其可见
    _eagllayer.opaque = YES;
    
    //设置描述属性
    //kEAGLDrawablePropertyRetainedBacking保留背景，NO表示在屏幕上显示绘制整个内容
    //kEAGLColorFormatRGBA8告诉coreAnimation用8位来保存层内的每个像素的每个颜色元素的值
    _eagllayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithBool:NO],kEAGLDrawablePropertyRetainedBacking,kEAGLColorFormatRGBA8,
                                     kEAGLDrawablePropertyColorFormat, nil];
}

#pragma mark -- 设置颜色和帧缓存
- (void)setupFrameAndColorRenderBuffer {
    glGenRenderbuffers(1, &_colorRenderBuffer); //创建渲染缓存区
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer); //绑定渲染缓冲区到渲染管道
    // 为 _colorRenderBuffer 分配存储空间
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eagllayer];
    
    glGenFramebuffers(1, &_frameBuffer); //创建帧缓存区
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer); //绑定帧缓存区到渲染管道
    
    // 将颜色渲染缓存区绑定到帧缓存区上，将_colorRenderBuffer装配到GL_COLOR_ATTACHMENT0这个装配店上
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
}

- (void)destoryColorRenderAndFrameBuffer {
    glDeleteFramebuffers(1, &_frameBuffer);
    _frameBuffer = 0;
    glDeleteRenderbuffers(1, &_colorRenderBuffer);
    _colorRenderBuffer = 0;
}

- (void)render {
    glClearColor(0.5f, 0.5f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
     //将指定 renderbuffer 呈现在屏幕上，在这里我们指定的是前面已经绑定为当前 renderbuffer 的那个，在 renderbuffer 可以被呈现之前，必须调用renderbufferStorage:fromDrawable: 为之分配存储空间。
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}
@end
