//
//  ImageCropViewController.swift
//  ImageCrop
//
//  Created by David on 2016/4/25.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

@objc public protocol ImageCropViewControllerDelegate: class {
	optional func ImageCropViewControllerCancelImageCrop()
	optional func ImageCropViewControllerFinishImageCrop(image: UIImage?)
	optional func ImageCropViewControllerFailToCropImage()
}

class ImageCropViewController: UIViewController {
	
	private var imageContainer: UIScrollView!
	private var imageView: UIImageView!
	
	var inputImage: UIImage?
	var maxScaleFactor: CGFloat = 5.0
	var minScaleFactor: CGFloat = 0.5
	
	weak var delegate: ImageCropViewControllerDelegate?
	
	var radius: CGFloat = UIScreen.mainScreen().bounds.width / 2

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		configureContainer()
		view.backgroundColor = UIColor.grayColor()
    }
	
	func configureContainer() {
		// init a scroll view to put imageview inside
		imageContainer = UIScrollView()
		// size
		imageContainer.frame = CGRect(origin: CGPointZero, size: CGSize(width: radius * 2, height: radius * 2))
		// center it to center of the view controller
		imageContainer.center = view.center
		// content will exceed the bounds of the container
		imageContainer.clipsToBounds = false
		// add it to view
		view.addSubview(imageContainer)
		// configure image view
		configureImageView()
		// resize container view's content size, same as imageview's size
		imageContainer.contentSize = imageView.frame.size
		// add image to container
		imageContainer.addSubview(imageView)
		// set zoom factor
		imageContainer.maximumZoomScale = maxScaleFactor
		minScaleFactor = getMinimunZoomScale()
		imageContainer.minimumZoomScale = minScaleFactor
		// set delegate
		imageContainer.delegate = self
		imageContainer.decelerating
		
		// move to center of the image
		centerImage()
		
		// dig a hole here
		let transparentHoleView = TransparentHoleView(frame: UIScreen.mainScreen().bounds, radius: radius)
		// pass the gesture to imageContainer view
		transparentHoleView.reciever = imageContainer
		view.addSubview(transparentHoleView)
		
		titleOnCircle("安安")
		
		zoomImage()
		centerImage()
		
		let button = UIButton(type: .System)
		button.frame = CGRect(x: 0, y: 0, width: 150, height: 60)
		button.center = CGPoint(x: UIScreen.mainScreen().bounds.width * 0.9, y: UIScreen.mainScreen().bounds.height * 0.9)
		button.setTitle("幹", forState: UIControlState.Normal)
		button.addTarget(self, action: #selector(cropImage), forControlEvents: UIControlEvents.TouchUpInside)
		view.addSubview(button)
	}
	
	func cropImage() {
		if let cgImage = imageView.image?.CGImage {
			let offset = imageContainer.contentOffset
			let zoomScale = imageContainer.zoomScale
			// divide by current zoom scale, because real offset and height is small if you zoom in.
			let rectToCrop = CGRect(x: offset.x / zoomScale, y: offset.y / zoomScale, width: radius * 2/zoomScale, height: radius * 2/zoomScale)
			let croppedCGImage = CGImageCreateWithImageInRect(cgImage, rectToCrop)
			
			if let croppedCGImage = croppedCGImage {
				delegate?.ImageCropViewControllerFinishImageCrop?(UIImage(CGImage: croppedCGImage))
			} else {
				delegate?.ImageCropViewControllerFailToCropImage?()
			}
		} else {
			delegate?.ImageCropViewControllerFailToCropImage?()
		}
		
		dismissViewControllerAnimated(true, completion: nil)
		
	}
	
	func zoomImage() {
		imageContainer.zoomScale = minScaleFactor * 1.2
	}
	
	func centerImage() {
		let zoomScale = imageContainer.zoomScale
		let x = (imageView.bounds.size.width * zoomScale - imageContainer.bounds.size.width) / 2
		let y = (imageView.bounds.size.height * zoomScale - imageContainer.bounds.size.height) / 2
		
		imageContainer.contentOffset = CGPoint(x: x, y: y)
	}
	
	func titleOnCircle(text: String?) {
		let title = UILabel()
		title.frame.size.width = UIScreen.mainScreen().bounds.size.width - 40
		title.textAlignment = .Center
		title.textColor = UIColor.whiteColor()
		title.text = text
		title.font = UIFont.systemFontOfSize(30)
		title.sizeToFit()
		
		title.center.x = view.center.x
		let margin: CGFloat = 40
		title.frame.origin.y = UIScreen.mainScreen().bounds.size.height / 2 - radius - margin
		
		view.addSubview(title)
	}
	
	func getMinimunZoomScale() -> CGFloat {
		let imageMinSize = imageView.bounds.size.height > imageView.bounds.size.width ? imageView.bounds.size.width : imageView.bounds.size.height
		return radius * 2 / imageMinSize
	}
	
	func configureImageView() {
		// image view can enlarge to whole screen
		imageView = UIImageView(frame: UIScreen.mainScreen().bounds)
		// set image
		imageView.image = inputImage
		imageView.contentMode = .ScaleAspectFill
		// size to image's origin size
		imageView.sizeToFit()
	}
}

extension ImageCropViewController : UIScrollViewDelegate {
	func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
		return imageView
	}
}
