# OpenGLES-Learn
该代码库主要是总结下自己学习OpenGLES知识。
环境是Xcode8+OpenGLES2.0
主要使用了GLKit框架作为导向学习OpenGLES
博客地址：http://www.jianshu.com/users/b884a49d1ab4

这个demo主要从三角形的绘制开始。
这里在这里解释几个API


<!--第一个参数：指定要生成的缓存标识符的数量-->
<!--第二个参数：是一个指针，指向生成的标识符的内存保存位置-->
glGenBuffers (GLsizei n, GLuint* buffers);


<!--第一个参数：用于指定要绑定哪一种类型的缓存。glBindBuffer只支持两种类型的缓存，GL_ARRAY_BUFFER 和 GL_ELEMENT_ARRAY_BUFFER，-->
<!--GL_ARRAY_BUFFER用来指定一个顶点属性数组，指定的是真实数据，如果你指定的是这个，最后绘制的时候要调用glDrawArrays (GLenum mode, GLint first, GLsizei count);-->
<!---->
<!--GL_ELEMENT_ARRAY_BUFFER 用例指定一个真实数据的一个索引。是索引，如果你指定的是这个，最后绘制的时候要调用 glDrawElements (GLenum mode, GLsizei count, GLenum type, const GLvoid* indices);-->
<!--第二个参数：绑定的缓存的标识符-->
glBindBuffer (GLenum target, GLuint buffer)




<!--开启顶点属性-->
<!--有下面这几个属性-->
<!--GLKVertexAttribPosition,  位置-->
<!--GLKVertexAttribNormal,   法向量-->
<!--GLKVertexAttribColor,     顶点颜色-->
<!--GLKVertexAttribTexCoord0, 纹理0-->
<!--GLKVertexAttribTexCoord1  纹理1-->

glEnableVertexAttribArray (GLuint index)  



<!--glVertexAttribPointer（）函数告诉OpenGL ES 顶点数据在哪里，以及怎么解释为每个顶点保存的数据-->
<!--第一个参数：你glEnableVertexAttribArray 启动哪个属性就填哪个属性-->
<!--第二个参数：指示每个位置有几个部分-->
<!--第三个参数：告诉OpenGL ES每个部分都保存为一个浮点类型的值-->
<!--第四个参数：告诉OpenGL ES小数点固定数据是否可以被改变。-->
<!--第五个参数：指定每个顶点的保存需要多少个字节-->
<!--第六个参数：为NULL告诉OpenGL ES可以从当前绑定的顶点缓存的开始位置访问顶点数据-->

glVertexAttribPointer (GLuint indx, GLint size, GLenum type, GLboolean normalized, GLsizei stride, const GLvoid* ptr)




<!--glDrawArrays 绘制真实的顶点数据信息-->
<!--glDrawElements 绘制真实的顶点数据索引信息-->
<!---->
<!--第一个参数有以下几种：-->
<!-- GL_POINTS             点                                     -->
<!-- GL_LINES              线段                                    -->
<!-- GL_LINE_LOOP          指首尾相接的线段，第一条线和最后一条线连接在一起，即闭合的曲线  -->
<!-- GL_LINE_STRIP         首尾相接的线段，第一条和最后一条没有连接在一起                           -->
<!-- GL_TRIANGLES          三角形                            -->
<!-- GL_TRIANGLE_STRIP     三角形条带                           -->
<!-- GL_TRIANGLE_FAN       三角形扇   -->

glDrawArrays (GLenum mode, GLint first, GLsizei count);
glDrawElements (GLenum mode, GLsizei count, GLenum type, const GLvoid* indices);
