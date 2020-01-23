//
//  PickerViewController.swift
//  Capstone
//
//  Created by Xinran Che on 1/8/20.
//  Copyright © 2020 Xinran Che. All rights reserved.
//

import UIKit
import SafariServices

class PickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var productName: UITextView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var goLinkButton: UIButton!
    @IBOutlet weak var exploreMoreButton: UIButton!
    
    var productImageValue: UIImage!
    var productNameValue = ""
    var pickerData: [Offer] = []
    var pickerOptions: [String] = [String]()
    var currentRow: Int? = 0
    //    var searchResults = [SearchResult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.picker.delegate = self
        self.picker.dataSource = self
        
        productName.text = productNameValue
        productImage.image = productImageValue
        productImage.layer.masksToBounds = true
        productImage.layer.cornerRadius = productImage.bounds.width / 2
        productImage.layer.borderWidth = 2
        productImage.layer.borderColor = UIColor.gray.cgColor
        
        if productNameValue == "Product was not found!" {
            exploreMoreButton.isEnabled = false
        }
         
        if pickerData.isEmpty {
            pickerOptions = ["Woops! Not found!"]
            goLinkButton.isEnabled = false
        } else {
            for option in pickerData {
                pickerOptions.append("\(option.merchant): \(option.price)")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()

        label.textColor = UIColor.darkGray
        label.font = UIFont(name: "Kefa-Regular", size: 17.0)
        label.textAlignment = .center
        label.text = pickerOptions[row]
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentRow = row
    }
    
    @IBAction func goButton(_ sender: Any) {
        if currentRow != nil {
            let safari = SFSafariViewController(url: URL(string: pickerData[currentRow!].link)! as URL)
            present(safari, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let resultVC = segue.destination as? GoogleTableViewController else { return }
        resultVC.searchTerm = self.productNameValue
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          
       }
    */

}
