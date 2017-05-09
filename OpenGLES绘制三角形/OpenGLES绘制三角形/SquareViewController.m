//
//  SquareViewController.m
//  OpenGLES绘制三角形
//
//  Created by 陈伟鑫 on 2017/5/7.
//  Copyright © 2017年 陈伟鑫. All rights reserved.
//

#import "SquareViewController.h"


typedef struct {
    GLKVector3 positionCoords;
}SquareScence;

static const SquareScence vertexs[] = {
    {{-0.5f, -0.5f, 0.0f}}, //左下
    {{0.5f, -0.5f, 0.0f}},  //右下
    {{-0.5f, 0.5f, 0.0f}},   //左上
    {{0.5f, 0.5f, 0.0f}},  //右上
};

static const

@interface SquareViewController ()
{
    GLuint _vertexBufferID; //顶点缓存标识
    GLuint _indicesBufferID; // 索引缓存标识
}

@property (nonatomic, strong) GLKBaseEffect *baseEffect;

@property (nonatomic, assign) NSUInteger mcount;
@end

@implementation SquareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 上下文
    GLKView *view = (GLKView *)self.view;
    view.context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:view.context];
    
    // 着色器
    self.baseEffect = [[GLKBaseEffect alloc]init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(0.5f, 0.5f, 1.0f, 1.0f);
    
    // 顶点索引
    GLuint indices[] = {
      0, 1, 2,
      1, 3, 2
    };
    
    self.mcount = sizeof(indices) / sizeof(GLuint);
    
    // 创建绑定顶点缓存区，分配内存
    glGenBuffers(1, &_vertexBufferID);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexs), vertexs, GL_STATIC_DRAW);
    
    // 创建绑定顶点索引缓存区，分配内存
    glGenBuffers(1, &_indicesBufferID);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indicesBufferID);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(SquareScence), NULL);
    
    
    
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    [self.baseEffect prepareToDraw];
    
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glDrawElements(GL_TRIANGLES, (int)self.mcount, GL_UNSIGNED_INT, 0);
    

}

- (void)viewDidDisappear:(BOOL)animated {
    if (_vertexBufferID) {
        glDeleteBuffers(1, &(_vertexBufferID));
        _vertexBufferID = 0;
    }
    if (_indicesBufferID) {
        glDeleteBuffers(1, &_indicesBufferID);
        _indicesBufferID = 0;
    }
    ((GLKView *)self.view).context = nil;
    [EAGLContext setCurrentContext:nil];
}

- (void)dealloc {
    NSLog(@"%@ delloc",[self class]);
}
@end
