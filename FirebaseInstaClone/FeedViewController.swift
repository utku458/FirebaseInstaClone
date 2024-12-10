//
//  FeedViewController.swift
//  FirebaseInstaClone
//
//  Created by Utku Altınay on 25.10.2024.
//

import UIKit
import Firebase
import FirebaseFirestore
import SDWebImage
class FeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    var documentIdArray = [String]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! FeedCell
      
        cell.userEmailLabel.text = userEmailArray[indexPath.row]
        cell.likeLabel.text = String(likeArray[indexPath.row])
        cell.commentLabel.text = userCommentArray[indexPath.row]
        cell.userImageView.sd_setImage(with: URL( string: self.userImageArray[indexPath.row]))
        cell.documentIdLabel.text = documentIdArray[indexPath.row]
        return cell
    }
    

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getDataFromFireStore()
        // Do any additional setup after loading the view.
    }
    
    func getDataFromFireStore(){
        let fireStoreDatabase = Firestore.firestore()
        fireStoreDatabase.collection("Post").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                print("Error")
            }else{
                if snapshot?.isEmpty != true {
                    self.userImageArray.removeAll()
                    self.likeArray.removeAll()
                    self.userEmailArray.removeAll()
                    self.userCommentArray.removeAll()
                    self.documentIdArray.removeAll()
                    for document in snapshot!.documents{
                        
                     
                            let documentId = document.documentID
                           self.documentIdArray.append(documentId)
                        
                        if let postedBy = document.get("PostedBy") as! String?{
                            self.userEmailArray.append(postedBy)
                        }
                        
                        if let postComment = document.get("postComment") as! String?{
                            self.userCommentArray.append(postComment)
                        }
                        if let likes = document.get("likes") as! Int?{
                            self.likeArray.append(likes)
                        }
                        
                        if let imageUrl = document.get("imageUrl") as! String?{
                            self.userImageArray.append(imageUrl)
                        }
                    }
                    self.tableView.reloadData()
                }
               
            }
        }
        
    }
    

 

}
