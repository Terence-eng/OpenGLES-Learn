//
//  ViewController.m
//  OpenGLES绘制三角形
//
//  Created by 陈伟鑫 on 2017/5/6.
//  Copyright © 2017年 陈伟鑫. All rights reserved.
//

#import "ViewController.h"

/**
 VBO： 显卡存储空间里的一块缓存区(Buffer)，用于记录顶点的信息，包括法线，问路坐标等，这个Buffer有它的名字(VBO的ID)，OpenGL在GPU的某处记录着这个ID和对应的显存地址（或者地址偏移，类似内存）。
 */
@interface ViewController ()
{
    GLuint _vertexBufferID; //创建一个顶点缓存对象标识 Vertex Buffer Object（VBO）
}
@property (nonatomic, strong) GLKBaseEffect *baseEffect;

@end

@implementation ViewController
typedef struct {
    GLKVector3 positionCoords;
}TriangleScence;

//顶点数据数据
static const TriangleScence vertexs[] =
{
    {{-0.5f, -0.5f, 0.0f}}, //左下
    {{0.5f, -0.5f, 0.0f}},  //右下
    {{0.0f, 0.5f, 0.0f}},   //中上
};


- (void)viewDidLoad {
    
    GLKView *view = (GLKView *)self.view;
    // 设置view的上下文
    view.context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    // 设置当前上下文
    [EAGLContext setCurrentContext:view.context];
    
    //初始化着色器
    self.baseEffect = [[GLKBaseEffect alloc]init];
    // 一个开关
    self.baseEffect.useConstantColor = GL_TRUE;
    // 设置三角形颜色
    self.baseEffect.constantColor = GLKVector4Make(0.5f, 0.5f, 1.0f, 1.0f);
    
    // 设置清屏颜色黑色，意思就是设置当前上下文的背景颜色
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    
    /**
     第一个参数：指定要生成的缓存标识符的数量
     第二个参数：是一个指针，指向生成的标识符的内存保存位置
     */
    glGenBuffers(1, &_vertexBufferID);
    
    /**
    第一个参数：用于指定要绑定哪一种类型的缓存。glBindBuffer只支持两种类型的缓存，GL_ARRAY_BUFFER 和 GL_ELEMENT_ARRAY_BUFFER，
     GL_ARRAY_BUFFER用来指定一个顶点属性数组
     GL_ELEMENT_ARRAY_BUFFER 用例指定一个真实数据的一个索引。是索引
    第二个参数：绑定的缓存的标识符
    */
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferID);
    
    /**
     glBufferData 复制 应用的顶点数据 到 当前上下文所绑定的顶点缓存中
     第一个参数：用于指定要更新当前上下文中所绑定的是哪一个缓存
     第二个参数：要复制进这个缓存的字节的数量
     第三个参数：复制的字节的地址
     第四个参数：提示了 缓存 在 未来的运算中可能将会被怎样使用，
     GL_STATIC_DRAW 告诉上下文，缓存中的内容适合复制到GPU控制的内存，因为很少对其进行修改，这个信息可以帮助OpenGL ES 优化内存使用。
     使用GL_DYNAMIC_DRAW作为提示会告诉上下文，表示该缓存区会被周期性更改变
     GL_STREAM_DRAW：表示该缓存区会被频繁更改；
     */
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexs), vertexs, GL_STATIC_DRAW);
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    // 告诉baseEffect 准备好当前OpenGL ES 的上下文，以便为使用baseEffect生成的属性和Shading Language程序的绘图做好准备
    [self.baseEffect prepareToDraw];
    
    glClear(GL_COLOR_BUFFER_BIT);
    
    // 启动顶点缓存渲染操作
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    
    /*
     glVertexAttribPointer（）函数告诉OpenGL ES 顶点数据在哪里，以及怎么解释为每个顶点保存的数据
     第一个参数：当前绑定的缓存包含每个定点的位置信息
     第二个参数：指示每个位置有3个部分
     第三个参数：告诉OpenGL ES每个部分都保存为一个浮点类型的值
     第四个参数：告诉OpenGL ES小数点固定数据是否可以被改变。
     第五个参数：指定每个顶点的保存需要多少个字节
     第六个参数：为NULL告诉OpenGL ES可以从当前绑定的顶点缓存的开始位置访问顶点数据
     */

    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(TriangleScence), NULL);
    
    /*
     通过调用glDrawArrays（）来执行绘图
     第一个参数：告诉GPU怎么处理绑定的顶点缓存内的顶点数据，GL_TRIANGLES 三角形，
     第二个参数：缓存内需要渲染的第一个顶点的位置
     第三个参数：需要渲染的顶点的数量
     */
    glDrawArrays(GL_TRIANGLES, 0, 3);
    
}

- (void)viewDidDisappear:(BOOL)animated {
    if (_vertexBufferID != 0) {
        glDeleteBuffers(1, &_vertexBufferID);
        _vertexBufferID = 0;
    }
    ((GLKView *)self.view).context = nil;
    [EAGLContext setCurrentContext:nil];
}

- (void)dealloc {
    NSLog(@"%@ delloc",[self class]);
}
@end
