//
//  ViewController.swift
//  ImageCrop
//
//  Created by David on 2016/4/25.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	var imageView: UIImageView!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoImageCropViewController)))
		
		imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
		imageView.center = view.center
		view.addSubview(imageView)
		
		imageView.layer.cornerRadius = 150
		imageView.layer.borderWidth = 4.0
		imageView.layer.borderColor = UIColor.lightGrayColor().CGColor
		imageView.clipsToBounds = true
	}
	
	func gotoImageCropViewController() {
		performSegueWithIdentifier("show", sender: nil)
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "show" {
			let vc = segue.destinationViewController as! ImageCropViewController
			vc.inputImage = UIImage(named: "420_135a8cdf96ee535afd31b15e602347b2.jpg")
			vc.radius = 200
			vc.delegate = self
		}
	}
}

extension ViewController : ImageCropViewControllerDelegate {
	func ImageCropViewControllerFinishImageCrop(image: UIImage?) {
		imageView.image = image
	}
}

