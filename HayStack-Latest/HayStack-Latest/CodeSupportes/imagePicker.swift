//
//  imagePicker.swift
//  HayStack-Army
//
//  Created by rajesh gandru on 18/05/21.
//

import Foundation
import UIKit


class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var picker = UIImagePickerController();
    var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    var viewController: UIViewController?
    var pickImageCallback : ((UIImage,String) -> ())?;
    
    override init(){
        super.init()
        let cameraAction = UIAlertAction(title: "Camera", style: .default){
            UIAlertAction in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "Gallery", style: .default){
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            UIAlertAction in
        }

        // Add the actions
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
    }

    func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage,String) -> ())) {
        pickImageCallback = callback;
        self.viewController = viewController;

        alert.popoverPresentationController?.sourceView = self.viewController!.view

        viewController.present(alert, animated: true, completion: nil)
    }
    func openCamera(){
        alert.dismiss(animated: true, completion: nil)
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            self.viewController!.present(picker, animated: true, completion: nil)
        } else {
            let alertWarning = UIAlertView(title:"Warning", message: "You don't have camera", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:"")
            alertWarning.show()
        }
    }
    func openGallery(){
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        self.viewController!.present(picker, animated: true, completion: nil)
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    //for swift below 4.2
    //func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    //    picker.dismiss(animated: true, completion: nil)
    //    let image = info[UIImagePickerControllerOriginalImage] as! UIImage
    //    pickImageCallback?(image)
    //}
    
    // For Swift 4.2+
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        var str = ""
        if (!(picker.sourceType == UIImagePickerController.SourceType.camera)) {
            let assetResources = info[UIImagePickerController.InfoKey.referenceURL] as! NSURL

//                   print(assetResources.originalFilename)

                    if (assetResources.absoluteString?.hasSuffix("JPG") == true) {
                       print("jpg")
                        str = "jpg"
                   } else if (assetResources.absoluteString?.hasSuffix("JPEG") == true) {
                       print("jpeg")
                       str = "jpeg"
                   } else if (assetResources.absoluteString?.hasSuffix("PNG") == true) {
                       print("png")
                       str = "png"
                   } else if (assetResources.absoluteString?.hasSuffix("GIF") == true) {
                       print("gif")
                       str = "gif"
                   } else if (assetResources.absoluteString?.hasSuffix("TIFF") == true) {
                       print("tiff")
                       str = "tiff"
                   } else if (assetResources.absoluteString?.hasSuffix("WEBP") == true) {
                       print("webp")
                       str = "webp"
                   } else if (assetResources.absoluteString?.hasSuffix("HEIC") == true) {
                       print("heic")
                       str = "heic"
                   } else if (assetResources.absoluteString?.hasSuffix("HEIX") == true) {
                       print("heix")
                       str = "heix"
                   } else if (assetResources.absoluteString?.hasSuffix("HEVC") == true) {
                       print("hevc")
                       str = "hevc"
                   } else if (assetResources.absoluteString?.hasSuffix("HEVX") == true) {
                       print("hevx")
                       str = "hevx"
                   } else {
                       print("Unknown")
                       str = "Unknown"
                   }
               }
        pickImageCallback?(image, str)
    }



    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
    }

}
