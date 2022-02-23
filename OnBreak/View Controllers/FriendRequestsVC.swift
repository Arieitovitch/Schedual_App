//
//  FriendRequestsVC.swift
//  OnBreak
//
//  Created by Arie Itovitch on 2021-08-12.
//

import UIKit
import Firebase

class FriendRequestsVC: UITableViewController, OBFreindRequestButtonTappedDeleget {
    
    
    var requests: [String] = []
    var name: String?
    var email: String?
    var friends: [String]?
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(FriendRequestCell.self, forCellReuseIdentifier: FriendRequestCell.reuseID)
        tableView.rowHeight = 90
        getRequests()
    }
    
    func getRequests(){
        if let myEmail = Auth.auth().currentUser?.email{
            db.collection(K.UserCollection).document(myEmail).addSnapshotListener { docSnap, error in
                if let e = error{
                    print(e)
                } else {
                    if let data = docSnap?.data(){
                        if let firRequets = data[K.requestsField] as? [String], let firFriends = data[K.friendsField] as? [String], let firEmail = data[K.emailField] as? String, let firName = data[K.nameField] as? String{
                            self.name = firName
                            self.email = firEmail
                            self.requests = firRequets
                            self.friends = firFriends
                        }
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func didTapAceptButton(email: String) {
        self.db.collection(K.UserCollection).document(email).getDocument { docSnap, error in
            if let e = error{
                print(e)
            } else {
                if let data = docSnap?.data(){
                    if let newFriendEmail = data[K.emailField] as? String, let newFriendName = data[K.nameField] as? String, var newFriendFriends = data[K.friendsField] as? [String], var newFriendRequests = data[K.requestsField] as? [String]{
                        if let meEmail = Auth.auth().currentUser?.email{
                            var index = 0
                            for r in newFriendRequests{
                                if r == meEmail{
                                    newFriendRequests.remove(at: index)
                                } else {
                                    index += 1
                                }
                            }
                            if !newFriendFriends.contains(meEmail){
                                newFriendFriends.append(meEmail)
                                self.db.collection(K.UserCollection).document(newFriendEmail).updateData([K.emailField: newFriendEmail, K.nameField: newFriendName, K.friendsField: newFriendFriends, K.requestsField:newFriendRequests])
                                self.db.collection(K.UserCollection).document(meEmail).getDocument { docSnap2, error in
                                    if let e = error{
                                        print(e)
                                    } else {
                                        if let data = docSnap2?.data(){
                                            if var meFriends = data[K.friendsField] as? [String], let meEmail2 = data[K.emailField] as? String, let meName = data[K.nameField] as? String, var meRequests = data[K.requestsField] as? [String]{
                                                var index = 0
                                                for r in meRequests{
                                                    if r == newFriendEmail{
                                                        meRequests.remove(at: index)
                                                    } else {
                                                        index += 1
                                                    }
                                                }
                                                if !meFriends.contains(newFriendEmail){
                                                    meFriends.append(newFriendEmail)
                                                    self.db.collection(K.UserCollection).document(meEmail).updateData([K.emailField: meEmail2, K.nameField: meName, K.friendsField: meFriends, K.requestsField:meRequests])
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func didTapRejectButton(email: String) {
        var index = 0
        for n in requests{
            if n == email{
                requests.remove(at: index)
                db.collection(K.UserCollection).document(self.email!).updateData([K.emailField: self.email!, K.nameField: name!, K.friendsField: friends!, K.requestsField: requests])
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                index += 1
            }
        }
    }
    
    //MARK: - Table View Shit
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let friend = requests[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendRequestCell.reuseID) as! FriendRequestCell
        cell.nameLabel.text = friend
        cell.delegte = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

}
