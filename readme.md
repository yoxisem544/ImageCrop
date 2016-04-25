#Image Crop
一個簡單的照片剪裁工具

A simple image crop tool

Demo:

![](ImageCrop.gif)


## 用法 How to use it
### Setup
在進入這個VC前，傳入一張你要剪裁的照片即可

如果需要指定剪裁框大小，指定VC的 radius 即可。

### Return Imgae
接上 `ImageCropViewControllerDelegate` 這個 protocol，有三個方法可以用，其中有一個 `ImageCropViewControllerFinishImageCrop(image: UIImage?)` 可以取得裁切過的照片。