//
//  ViewController.swift
//  Fiftygram
//
//  Created by Tran Le on 7/17/20.
//  Copyright © 2020 Tran. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let context = CIContext()
    var original: UIImage?
    
    @IBOutlet var imageView: UIImageView!
    
    @IBAction func choosePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            navigationController?.present(picker, animated: true, completion: nil)
        }
    }
    // save photo to photo library
    @IBAction func savePhoto() {
        if let image = imageView.image {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
    // create sepia filter
    @IBAction func applySepia() {
        if original == nil {
            return
        }
        // create object to rep filter
        let filter = CIFilter(name: "CISepiaTone")
        // call sepia methods
        filter?.setValue(0.5, forKey: kCIInputIntensityKey)
        display(filter: filter!)
    }
    
    @IBAction func applyNoir () {
        if original == nil {
            return
        }
        let filter = CIFilter(name: "CIPhotoEffectNoir")
        
        display(filter: filter!)
    }
    
    @IBAction func applyVintage() {
        if original == nil {
            return
        }
        let filter = CIFilter(name: "CIPhotoEffectProcess")
        
        display(filter: filter!)
    }
    
    @IBAction func applyFade() {
        if original == nil {
            return
        }
        let filter = CIFilter(name: "CIPhotoEffectFade")
        
        display(filter: filter!)
    }
    
    @IBAction func applyInstant() {
        if original == nil {
            return
        }
        let filter = CIFilter(name: "CIPhotoEffectInstant")
        
        display(filter: filter!)
    }
    
    func display(filter: CIFilter) {
        // call sepia methods
        // set/configure CI image from UI Image we want to filter
        filter.setValue(CIImage(image: original!), forKey: kCIInputImageKey)
        // run filter for resulting image (which will be CI Image)
        let output = filter.outputImage
        // convert back to UI image using context
        imageView.image = UIImage(cgImage: self.context.createCGImage(output!, from: output!.extent)!)
    }
    // info about what user selected is contained
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // dismiss viewcontroller after clicking photo so that image shows up on expected imageview
        navigationController?.dismiss(animated: true, completion: nil)
        // give back an image and cast in UIImage
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // display in imageView
            imageView.image = image
            original = image
        }
    }
}

