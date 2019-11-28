//
//  ViewController.swift
//  seefood
//
//  Created by Garima Bothra on 18/09/19.
//  Copyright © 2019 Garima Bothra. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        // Do any additional setup after loading the view.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
             imageView.image = userPickedImage
            
            guard  let ciimage = CIImage(image: userPickedImage)else {
                fatalError("Error converting to CIImage")
            }
            
            detect(image: ciimage)
            
        }
       
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    func detect(image : CIImage)
    {
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model)else {
            fatalError("Loading COREML model failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else{
                fatalError("Model failed to process error")
            }
            
            
            if let firstResult = results.first{
                if firstResult.identifier.contains("keyboard"){
                    self.navigationItem.title = "KEYBOARD!"
                }
                else{
                    self.navigationItem.title = "NOT KEYBOARD!"
                }
            }
        
        
        }
        
        let handler = VNImageRequestHandler(ciImage : image)
        do{
        try handler.perform([request])
        }
        catch{
            print(error)
        }
    }
    
    let imagePicker = UIImagePickerController()
    @IBAction func cameraPressed(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
    }
}

