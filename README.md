# TrecVID2018
TrecVID2018人脸部分的处理代码。
***
## 文件夹功能说明：

### “similarity_compute”相似度计算
  
### “topic_test”topic任务测试  

### “topic_person_find”在keyframe中筛选topic人物  

## 文件说明：

***
### 1、 “info\_integration\_trid4.m”文件说明
#### 功能：
将每张keyframe中检测到的人脸与参考集（reference）中的人脸比较后，取相似度最高的人脸图片信息，并保存到mat文件中。
#### 输出格式：
一共有80个mat文件，每个文件分为10列，每一列分别代表：  
（1）mat文件序号  
（2）shot号  
（3）场景号  
（4）该场景下关键帧序号  
（5）最相似人脸图像序号  
（6）该人脸检测尺度的宽（W）  
（7）该人脸检测尺度的高（H）  
（8）人脸相似度分数  
（9）对应参考集ID号  
（10）该ID号下人脸图像序号
