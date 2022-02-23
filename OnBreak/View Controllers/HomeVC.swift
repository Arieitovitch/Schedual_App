//
//  HomeVC.swift
//  OnBreak
//
//  Created by Arie Itovitch on 2021-08-12.
//

import UIKit
import Firebase

class HomeVC: UITableViewController {

    let signOutButton = UIBarButtonItem()
    var isSearching: Bool = false
    var users: [User] = []
    var filteredUsers: [User] = []
    var friends: [Friend] = []
    var friendsString: [String] = []
    var friendRequests: [String] = []
    var timer: Timer?
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        getFriends()
        authenticate()
        configureSignOutButton()
        configureSearchController()
        tableView.separatorStyle = .none
        tableView.register(FriendSearchCell.self, forCellReuseIdentifier: FriendSearchCell.reuseID)
        tableView.register(BreakCell.self, forCellReuseIdentifier: BreakCell.reuseID)
    }
    
    func configureSearchController(){
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = .systemRed
        searchController.searchBar.placeholder = "Search for a friend's email"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }

    func startMinuteTimer() {
      let now = Date.timeIntervalSinceReferenceDate
      let delayFraction = trunc(now) - now
      
      //Caluclate a delay until the next even minute
      let delay = 60.0 - Double(Int(now) % 60) + delayFraction
      
      DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        self.timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) {
          timer in
            self.showLoadingView()
            self.findBreaks()
        }
      }
    }
    
    //MARK: - Get Users
    func getFriends(){
        showLoadingView()
        friends.removeAll()
        friendRequests.removeAll()
        if let email = Auth.auth().currentUser?.email{
            db.collection(K.UserCollection).document(email).addSnapshotListener { docSnap, error in
                self.friends.removeAll()
                self.friendRequests.removeAll()
                if let e = error{
                    self.dismisLoadingView()
                    print(e)
                } else {
                    if let data = docSnap?.data(){
                        if let friends = data[K.friendsField] as? [String], let requests = data[K.requestsField] as? [String]{
                            self.friendRequests = requests
                            self.friendsString = friends
                            if self.friendsString.count == 0{
                                self.dismisLoadingView()
                            }
                            self.getFriendBreaks(friendStrings: friends)
                        }
                    }
                    self.getUsers()
                }
            }
        }
    }
    
    func getFriendBreaks(friendStrings: [String]){
        let today = Date().dayOfWeek()!
        for friend in friendStrings{
            db.collection(K.breakCollections).document(friend).collection(today).getDocuments{ querySanp, error in
                
                if let e = error{
                    print(e)
                } else {
                    var breaks: [eventBreak] = []
                    if let documents = querySanp?.documents{
                        for doc in documents{
                            let data = doc.data()
                            let docId = doc.documentID
                            if let startTime = data[K.breakStartField] as? String, let endTime = data[K.breakEndField] as? String{
                                let newBreak = eventBreak(startBreak: startTime, endBreak: endTime, docID: docId)
                                breaks.append(newBreak)
                            }
                        }
                        self.db.collection(K.UserCollection).document(friend).getDocument { docSnap, error in
                            if let e = error{
                                print(e)
                            } else {
                                if let data = docSnap?.data(){
                                    if let name = data[K.nameField] as? String{
                                        let newFriend = Friend(name: name, email: friend, breaks: breaks, isOnBreak: false)
                                        self.friends.append(newFriend)
                                    }
                                    self.findBreaks()
                                    self.startMinuteTimer()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func findBreaks(){
        if friends.count == friendsString.count{
            for friend in friends{
                for event in friend.breaks{
                    let start = event.startBreak
                    let end = event.endBreak
                    let startDate = start.convertToDate()
                    let endDate = end.convertToDate()
                    let now = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "h:mm a"
                    let nowString = dateFormatter.string(from: now)
                    let nowDate = nowString.convertToDate()
                    if startDate! <= nowDate! && nowDate! <= endDate!{
                        friend.isOnBreak = true
                    }
                }
            }
            friends.sort(by: {$0.isOnBreak && $1.isOnBreak})
            dismisLoadingView()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func getUsers(){
        users.removeAll()
        db.collection(K.UserCollection).addSnapshotListener { querySnap, error in
            if let e = error{
                print(e)
            } else {
                self.users.removeAll()
                if let documents = querySnap?.documents{
                    for doc in documents{
                        let data = doc.data()
                        if let currentEmail = Auth.auth().currentUser?.email{
                            if let email = data[K.emailField] as? String, let name = data[K.nameField] as? String{
                                print(email,currentEmail,self.friendsString)
                                if email != currentEmail && !self.friendsString.contains(email){
                                    let newUser = User(email: email, name: name)
                                    self.users.append(newUser)
                                }
                        }
                        }
                    }
                }
            }
        }
    }
    
    
    //MARK: - Authenticate users
    
    
    func authenticate(){
        if Auth.auth().currentUser?.isAnonymous ?? true{
            let VC = LoginVC()
            VC.title = "Sign In"
            VC.navigationItem.hidesBackButton = true
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(VC, animated: true)
            }
        }
        
    }
    
    //MARK: - Signn out
    
    func configureSignOutButton(){
        signOutButton.title = "Sign Out"
        signOutButton.target = self
        signOutButton.action = #selector(signOut)
        signOutButton.tintColor = .systemRed
        navigationItem.setLeftBarButton(signOutButton, animated: false)
    }
    
    @objc func signOut(){
        do {
            try Auth.auth().signOut()
            let VC = LoginVC()
            VC.title = "Sign In"
            VC.navigationItem.hidesBackButton = true
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(VC, animated: true)
            }
        } catch {
            print("It Fucked up")
        }
    }
    
    //MARK: - Table View Data Sources
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching{
            return filteredUsers.count
        } else {
            return friends.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSearching{
            let user = filteredUsers[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: FriendSearchCell.reuseID) as! FriendSearchCell
            cell.nameLabel.text = user.name.capitalized
            cell.emailLabel.text = user.email
            tableView.separatorStyle = .singleLine
            tableView.rowHeight = 80
            return cell
        } else {
            tableView.rowHeight = 160
            tableView.separatorStyle = .none
            let cell = tableView.dequeueReusableCell(withIdentifier: BreakCell.reuseID) as! BreakCell
            cell.contentView.layer.masksToBounds = true
            let friend = friends[indexPath.row]
            cell.nameLabel.text = friend.name
            cell.emailLabel.text = friend.email
            for event in friend.breaks{
                let start = event.startBreak
                let end = event.endBreak
                let startDate = start.convertToDate()
                let endDate = end.convertToDate()
                let now = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:mm a"
                let nowString = dateFormatter.string(from: now)
                let nowDate = nowString.convertToDate()
                if startDate! <= nowDate! && nowDate! <= endDate!{
                    cell.statusView.backgroundColor = .systemGreen
                    cell.breakStatusLabel.text = "On Break"
                    cell.timeLabel.text = "⏰\(start) - \(end)"
                    return cell
                }
            }
            var nextBreaks: [eventBreak] = []
            for event in friend.breaks{
                let start = event.startBreak
                let startDate = start.convertToDate()
                let now = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:mm a"
                let nowString = dateFormatter.string(from: now)
                let nowDate = nowString.convertToDate()
                if startDate! > nowDate!{
                    nextBreaks.append(event)
                }
            }
            if nextBreaks.count > 0{
                nextBreaks = nextBreaks.sorted( by: {$0.startBreak < $1.startBreak})
                cell.breakStatusLabel.text = "Next Break From"
                cell.timeLabel.text = "⏰\(nextBreaks[0].startBreak) - \(nextBreaks[0].endBreak)"
                cell.statusView.backgroundColor = .systemRed
                return cell
            }
            cell.statusView.backgroundColor = .systemRed
            cell.breakStatusLabel.text = "No More Breaks😞"
            cell.timeLabel.text = ""
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if isSearching{
            let newFriend = filteredUsers[indexPath.row]
            print(newFriend)
            if friendRequests.contains(newFriend.email){
                let alert = UIAlertController(title: "\(newFriend.name.capitalized) has already requested you, do you want to add \(newFriend.name.capitalized) back", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "✅", style: .default, handler: { action in
                    self.db.collection(K.UserCollection).document(newFriend.email).getDocument { docSnap, error in
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
                    
                    
                }))
                alert.addAction(UIAlertAction(title: "❌", style: .cancel, handler: { action in }))
                present(alert, animated: true)
            } else {
                
                self.db.collection(K.UserCollection).document(newFriend.email).getDocument { docSnap, error in
                    if let e = error{
                        print(e)
                    } else {
                        if let data = docSnap?.data(){
                            if let email = data[K.emailField] as? String, let name = data[K.nameField] as? String, let newFriends = data[K.friendsField] as? [String], let requests = data[K.requestsField] as? [String]{
                                if let newEmail = Auth.auth().currentUser?.email{
                                    
                                    if !requests.contains(newEmail){
                                        let alert = UIAlertController(title: "Are you sure you want to send \(newFriend.name.capitalized) a friend request!", message: "", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "✅", style: .default, handler: { action in
                                            var friendRequests = requests
                                            friendRequests.append(newEmail)
                                            if !requests.contains(newEmail){
                                                self.db.collection(K.UserCollection).document(newFriend.email).updateData([K.emailField: email, K.nameField: name, K.friendsField: newFriends, K.requestsField:friendRequests])
                                            }
                                            DispatchQueue.main.async {
                                                self.tableView.reloadData()
                                            }
                                        }))
                                        alert.addAction(UIAlertAction(title: "❌", style: .cancel, handler: { action in }))
                                        DispatchQueue.main.async {
                                            self.present(alert, animated: true)
                                        }
                                    } else {
                                        let alert = UIAlertController(title: "Sorry, you have already requested this user!", message: "", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { UIAlertAction in
                                            
                                        }))
                                        DispatchQueue.main.async {
                                            self.present(alert, animated: true)
                                        }
                                    }
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    

}


//MARK: - Authenticate users

extension HomeVC: UISearchResultsUpdating, UISearchBarDelegate{
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
        isSearching = true
        filteredUsers = users.filter { $0.email.lowercased().contains(filter.lowercased()) }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}
