//
//  UploadViewController.swift
//  FirebaseInstaClone
//
//  Created by Utku Altınay on 25.10.2024.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth
class UploadViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var konuText: UITextField!
    
    @IBOutlet weak var upladBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func chooseImage(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    
    func makeAlert(title:String , message:String){
        let alert = UIAlertController(title: title , message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    @IBAction func uploadBtnClicked(_ sender: Any) {
        
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("media")
        
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child("\(uuid).jpg")
            
            imageReference.putData(data) { (metadata, error) in
                if error != nil {
                    self.makeAlert(title: "Error!", message: error?.localizedDescription ?? "error")
                }else{
                    imageReference.downloadURL { (url , error) in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            print(imageUrl)
                            let firestorePost = ["imageUrl":imageUrl!,"PostedBy":Auth.auth().currentUser!.email!,"postComment":self.konuText.text,"date":FieldValue.serverTimestamp(),"likes":0]
                            as [String: Any]
                            let db = Firestore.firestore()
                            db.collection("Post").addDocument(data: firestorePost) { (error) in
                                if error != nil{
                                    
                                    self.makeAlert(title: "ERROR", message: error?.localizedDescription ?? "error")
                                }else{
                                    self.imageView.image = UIImage(named:"download-1915753_640.png")
                                    self.konuText.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                }
                                
                                
                            }
                            
                            
                            
                            
                            
                        }
                    }
                }
            }
        }
    }
    
    
}
