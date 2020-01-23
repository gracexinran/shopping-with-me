//
//  BarcodeViewController.swift
//  Capstone
//
//  Created by Xinran Che on 1/7/20.
//  Copyright © 2020 Xinran Che. All rights reserved.
//

import UIKit
import Firebase

class BarcodeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var resultView: UITextView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var errorMessage: UILabel!
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    var progressView = UIView()
    
    var imagePicker = UIImagePickerController()
    let options = VisionBarcodeDetectorOptions(formats: .all)
    lazy var vision = Vision.vision()
    var product = [ProductInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        nextButton.isHidden = true
        errorMessage.isHidden = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.bounds.width / 2
        // Do any additional setup after loading the view.
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func uploadImage(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let pickerVC = segue.destination as? PickerViewController else { return }
        if self.product.isEmpty {
            pickerVC.productNameValue = "Product was not found!"
            pickerVC.pickerData = []
        } else {
            pickerVC.productNameValue = (self.product[0].title)
            pickerVC.pickerData = self.product[0].offers
        }
        
        var imageURL = URL(string: "https://m.gardensbythebay.com.sg/etc/designs/gbb/clientlibs/images/common/not_found.jpg")
        if !self.product.isEmpty && !self.product[0].images.isEmpty {
            imageURL = URL(string: (self.product[0].images[0]))
        }
        
        if let data = try? Data(contentsOf: imageURL!) {
            pickerVC.productImageValue = UIImage(data: data)!
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        if let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            imageView.image = pickedImage
            let barcodeDetector = vision.barcodeDetector(options: options)
            let visionImage = VisionImage(image: pickedImage)
            
            startLoadingView()
            
            barcodeDetector.detect(in: visionImage) { (barcodes, error) in
                guard error == nil, let barcodes = barcodes, !barcodes.isEmpty else {
                    self.dismiss(animated: true, completion: nil)
                    self.resultView.text = "No Barcode Detected"
                    DispatchQueue.main.async {
                        self.errorMessage.isHidden = true
                        self.nextButton.isHidden = true
                        self.stopLoadingView()
                    }
                    return
                }
                
                for barcode in barcodes {
                    let rawValue = barcode.rawValue!
                    let valueType = barcode.valueType
                    
                    switch valueType {
                    case .ISBN:
                        self.resultView.text = "ISBN Barcode: \(rawValue)"
                    case .product:
                        self.resultView.text = "Product Barcode: \(rawValue)"
                    default:
                        self.resultView.text = rawValue
                    }
                    
                    let productRequest = ProductRequest(barcode: rawValue)
                    productRequest.getProduct { [weak self] result in
                        DispatchQueue.main.async {
                            self?.stopLoadingView()
                        }
//                        print("call")
                        switch result {
                        case .failure(let error):
                            DispatchQueue.main.async{
                                self?.nextButton.isHidden = true
                                self?.errorMessage.isHidden = false
                                self?.errorMessage.text = error.localizedDescription
                            }
                            
                        case .success(let productInfo):
                            self?.product = productInfo
                            DispatchQueue.main.async{
                                self?.errorMessage.isHidden = true
                                self?.nextButton.isHidden = false
                            }
                        }
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                        if self.activityIndicator.isAnimating{
                            self.stopLoadingView()
                            self.nextButton.isHidden = true
                            self.errorMessage.isHidden = false
                            self.errorMessage.text = "Error! No available data! Check your internet connection!"
                        }
                    }
                }
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func startLoadingView(){
        progressView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        progressView.center = view.center
        progressView.backgroundColor = UIColor.init(red: 210.0/255.0, green: 210.0/255.0, blue: 210.0/255.0, alpha: 1.0)
        progressView.clipsToBounds = true
        progressView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.center = CGPoint(x: progressView.bounds.width / 2, y: progressView.bounds.height / 2)
        
        progressView.addSubview(activityIndicator)
        view.addSubview(progressView)
        
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
    }

    func stopLoadingView(){
        activityIndicator.stopAnimating()
        progressView.removeFromSuperview()
        view.isUserInteractionEnabled = true
    }
}

fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
