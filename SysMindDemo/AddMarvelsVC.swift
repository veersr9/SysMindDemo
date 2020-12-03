//
//  AddMarvelsVC.swift
//  SysMindDemo
//
//  Created by veerendra Pratap Singh on 03/12/20.
//

import UIKit
import CoreData

class AddMarvelsVC: UIViewController {
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var txtFldName: UITextField!
    @IBOutlet weak var txtViewDesc: UITextView!
    @IBOutlet weak var imageShow: UIImageView!
    
    var picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageShow.isUserInteractionEnabled = true
        imageShow.addGestureRecognizer(tapGestureRecognizer)
        txtViewDesc.text = "Enter description"
        txtViewDesc.textColor = UIColor.lightGray
        // Do any additional setup after loading the view.
    }
    
    
    // MARK:- Button Action
    @IBAction func btnSave (_ sender: UIButton) {
        if let imageData = imageShow.image?.pngData() {
            if DataBaseHelper.shareInstance.saveImage(image: imageData, name: txtFldName.text!, description: txtViewDesc.text!){
                self.showAlertAction(title: "Congratulations", message: "Your data saved successfully")
            }
        }
    }
    @IBAction func btnBack (_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

//============================ UIImage Picker Delegate ======================================

extension AddMarvelsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let userPickedImage = info[.editedImage] as? UIImage else { return }
        imageShow.image = userPickedImage
        imageShow.layer.cornerRadius = 8
        picker.dismiss(animated: true)
    }
}

//=============================== UITextView Delegate =======================================
extension AddMarvelsVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtViewDesc.textColor == UIColor.lightGray {
            txtViewDesc.text = nil
            txtViewDesc.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if txtViewDesc.text.isEmpty {
            txtViewDesc.text = "Enter description"
            txtViewDesc.textColor = UIColor.lightGray
        }
    }
}

// ======================= Show Alert ===================================
extension AddMarvelsVC {
    func showAlertAction(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

// =========================== DB Helper ===================================
class DataBaseHelper {
    static let shareInstance = DataBaseHelper()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Save Data in DB
    func saveImage(image: Data, name:String, description:String) -> Bool {
        var dataSave = false
        let instance = Marvels(context: context)
        instance.image = image
        instance.name = name
        instance.desc = description
        do {
            try context.save()
            print("Data Saved")
            dataSave = true
        } catch {
            dataSave = false
            print(error.localizedDescription)
        }
        return dataSave
    }
    
    // Fetch Data from DB
    func fetchData() -> [Marvels] {
        var fetchingImage = [Marvels]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Marvels")
        do {
            fetchingImage = try context.fetch(fetchRequest) as! [Marvels]
        } catch {
            print("Error while fetching the image")
        }
        return fetchingImage
    }
}
