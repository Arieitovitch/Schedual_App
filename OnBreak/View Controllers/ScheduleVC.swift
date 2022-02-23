//
//  ScheduleVC.swift
//  OnBreak
//
//  Created by Arie Itovitch on 2021-08-12.
//

import UIKit
import Firebase
import SwipeCellKit


class ScheduleVC: UIViewController, UITableViewDataSource, UITableViewDelegate, SwipeTableViewCellDelegate{

    let addEventButton = UIBarButtonItem()
    let stackView = UIStackView()
    let sundayButton = OBdateButton(backgroundcolor: .clear, title: "S")
    let mondayButton = OBdateButton(backgroundcolor: .clear, title: "M")
    let tuesdayButton = OBdateButton(backgroundcolor: .clear, title: "T")
    let wednesdayButton = OBdateButton(backgroundcolor: .clear, title: "W")
    let thursdayButton = OBdateButton(backgroundcolor: .clear, title: "T")
    let fridayButton = OBdateButton(backgroundcolor: .clear, title: "F")
    let saturdayButton = OBdateButton(backgroundcolor: .clear, title: "S")
    let tableView = UITableView()
    let startTime = UIDatePicker()
    let endTime = UIDatePicker()
    
    var breaks: [eventBreak] = []
    
    var dayOfTheWeek: String?
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        tableView.register(SchedualCell.self, forCellReuseIdentifier: SchedualCell.reuseID)
        tableView.rowHeight = 70
        tableView.delegate = self
        tableView.dataSource = self
        configureaddEventButton()
        configureStackView()
        getCurrentDay()
        getBreaks(dayOfTheWeek: dayOfTheWeek)
        
    }
    
    func getBreaks(dayOfTheWeek: String?){
        breaks.removeAll()
        let day = dayOfTheWeek ?? Date().dayOfWeek()!
        if let email = Auth.auth().currentUser?.email{
            self.db.collection(K.breakCollections).document(email).collection(day).addSnapshotListener { querySnap, error in
                if let e = error{
                    print(e)
                } else {
                    self.breaks.removeAll()
                    if let documents = querySnap?.documents{
                        for doc in documents{
                            let docID = doc.documentID
                            let data = doc.data()
                            if let start = data[K.breakStartField] as? String, let end = data[K.breakEndField] as? String{
                                let newEvent = eventBreak(startBreak: start, endBreak: end, docID: docID)
                                self.breaks.append(newEvent)
                            }
                        }
                        self.breaks = self.breaks.sorted(by: { $0.startBreak < $1.startBreak })
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
        
    }
    
    func addBreak(dayOfTheWeek: String?, endTime: String, startTime: String){
        let day = dayOfTheWeek ?? Date().dayOfWeek()!
        if let email = Auth.auth().currentUser?.email{
            self.db.collection(K.breakCollections).document(email).collection(day).addDocument(data: [K.breakEndField: endTime, K.breakStartField: startTime])
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    func configureaddEventButton(){
        addEventButton.title = "Add Break"
        addEventButton.target = self
        addEventButton.action = #selector(addEventButtonPressed)
        addEventButton.tintColor = .systemGreen
        navigationItem.setRightBarButton(addEventButton, animated: false)
    }
    
    func configureStackView(){
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.addSubviews(
            sundayButton,mondayButton,tuesdayButton,wednesdayButton,thursdayButton,fridayButton,saturdayButton
        )
        sundayButton.addTarget(self, action: #selector(sundayButtonPressed), for: .touchUpInside)
        mondayButton.addTarget(self, action: #selector(mondayButtonPressed), for: .touchUpInside)
        tuesdayButton.addTarget(self, action: #selector(tuesdayButtonPressed), for: .touchUpInside)
        wednesdayButton.addTarget(self, action: #selector(wednesdayButtonPressed), for: .touchUpInside)
        thursdayButton.addTarget(self, action: #selector(thursdayButtonPressed), for: .touchUpInside)
        fridayButton.addTarget(self, action: #selector(fridayButtonPressed), for: .touchUpInside)
        saturdayButton.addTarget(self, action: #selector(saturdayButtonPressed), for: .touchUpInside)
        view.addSubviewsForView(stackView, tableView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            stackView.heightAnchor.constraint(equalToConstant: 40),
            
            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
    }
    
    
    @objc func addEventButtonPressed(){
        let alert = UIAlertController(title: "Choose a start and end time⏳", message: "", preferredStyle: .alert)
        let height:NSLayoutConstraint = NSLayoutConstraint(item: alert.view as Any, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.25)
        alert.view.addConstraint(height);
        startTime.timeZone = .current
        startTime.datePickerMode = .time
        endTime.timeZone = .current
        endTime.datePickerMode = .time
        startTime.translatesAutoresizingMaskIntoConstraints = false
        endTime.translatesAutoresizingMaskIntoConstraints = false
        endTime.minimumDate = startTime.date
        startTime.maximumDate = endTime.date
        
        endTime.addTarget(self, action: #selector(timeChanged), for: .allEvents)
        startTime.addTarget(self, action: #selector(timeChanged), for: .allEvents)
        
        alert.view.addConstraint(NSLayoutConstraint(item: startTime, attribute: .centerX, relatedBy: .equal, toItem: alert.view, attribute: .centerX, multiplier: 1, constant: 0))
        alert.view.addConstraint(NSLayoutConstraint(item: startTime, attribute: .centerY, relatedBy: .equal, toItem: alert.view, attribute: .centerY, multiplier: 0.9, constant: 0))
        alert.view.addConstraint(NSLayoutConstraint(item: startTime, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 64.0))
        alert.view.addSubview(startTime)
        
        alert.view.addConstraint(NSLayoutConstraint(item: endTime, attribute: .centerX, relatedBy: .equal, toItem: alert.view, attribute: .centerX, multiplier: 1, constant: 0))
        alert.view.addConstraint(NSLayoutConstraint(item: endTime, attribute: .centerY, relatedBy: .equal, toItem: alert.view, attribute: .centerY, multiplier: 1.3, constant: 0))
        alert.view.addConstraint(NSLayoutConstraint(item: endTime, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 64.0))
        alert.view.addSubview(endTime)
        
        
        let submitAction = UIAlertAction(title: "Add", style: .default) { _ in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            let startDate = dateFormatter.string(from: self.startTime.date)
            let endDate = dateFormatter.string(from:self.endTime.date)
            self.addBreak(dayOfTheWeek: self.dayOfTheWeek, endTime: endDate, startTime: startDate)
        }
        let NoButton = UIAlertAction(title: "Cancel", style: .destructive) { (UIAlertAction) in
        }
        alert.addAction(submitAction)
        alert.addAction(NoButton)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    @objc func timeChanged(){
        endTime.minimumDate = startTime.date
        startTime.maximumDate = endTime.date
    }
    
    // MARK: - Table view data source
    
    func removeProduct(at indexpath: IndexPath){
        let eventbreak = breaks[indexpath.row]
        breaks.remove(at: indexpath.row)
        if let email = Auth.auth().currentUser?.email{
            self.db.collection(K.breakCollections).document(email).collection(dayOfTheWeek ?? Date().dayOfWeek()!).document(eventbreak.docID).delete()
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.removeProduct(at: indexPath)
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breaks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SchedualCell.reuseID) as! SchedualCell
        cell.selectionStyle = .none
        cell.delegate = self
        let event = breaks[indexPath.row]
        cell.timeLabel.text = "\(event.startBreak) - \(event.endBreak)"
        cell.timeLabel.font = .boldSystemFont(ofSize: 24)
        
        return cell
    }
    
    
}


//MARK: - Get The current Day

extension ScheduleVC{
    func getCurrentDay(){
        
        switch Date().dayOfWeek()! {
        case "Sunday":
            sundayButton.backgroundColor = .systemTeal
        case "Monday":
            mondayButton.backgroundColor = .systemTeal
        case "Tuesday":
            tuesdayButton.backgroundColor = .systemTeal
        case "Wednesday":
            wednesdayButton.backgroundColor = .systemTeal
        case "Thursday":
            thursdayButton.backgroundColor = .systemTeal
        case "Friday":
            fridayButton.backgroundColor = .systemTeal
        case "Saturday":
            saturdayButton.backgroundColor = .systemTeal
        default:
            print("Wasn't a day")
        }
    }
        
        // MARK: - Date Buttons Pressed
        
        @objc func sundayButtonPressed(){
            clearAllBackgrounds()
            sundayButton.backgroundColor = .systemTeal
            dayOfTheWeek = "Sunday"
            getBreaks(dayOfTheWeek: dayOfTheWeek)
        }
        
        @objc func mondayButtonPressed(){
            clearAllBackgrounds()
            mondayButton.backgroundColor = .systemTeal
            dayOfTheWeek = "Monday"
            getBreaks(dayOfTheWeek: dayOfTheWeek)
        }
        
        @objc func tuesdayButtonPressed(){
            clearAllBackgrounds()
            tuesdayButton.backgroundColor = .systemTeal
            dayOfTheWeek = "Tuesday"
            getBreaks(dayOfTheWeek: dayOfTheWeek)
        }
        
        @objc func wednesdayButtonPressed(){
            clearAllBackgrounds()
            wednesdayButton.backgroundColor = .systemTeal
            dayOfTheWeek = "Wednesday"
            getBreaks(dayOfTheWeek: dayOfTheWeek)
        }
        
        @objc func thursdayButtonPressed(){
            clearAllBackgrounds()
            thursdayButton.backgroundColor = .systemTeal
            dayOfTheWeek = "Thursday"
            getBreaks(dayOfTheWeek: dayOfTheWeek)
        }
        
        @objc func fridayButtonPressed(){
            clearAllBackgrounds()
            fridayButton.backgroundColor = .systemTeal
            dayOfTheWeek = "Friday"
            getBreaks(dayOfTheWeek: dayOfTheWeek)
        }
        
        @objc func saturdayButtonPressed(){
            clearAllBackgrounds()
            saturdayButton.backgroundColor = .systemTeal
            dayOfTheWeek = "Saturday"
            getBreaks(dayOfTheWeek: dayOfTheWeek)
        }
        
        func clearAllBackgrounds(){
            sundayButton.backgroundColor = .clear
            mondayButton.backgroundColor = .clear
            tuesdayButton.backgroundColor = .clear
            wednesdayButton.backgroundColor = .clear
            thursdayButton.backgroundColor = .clear
            fridayButton.backgroundColor = .clear
            saturdayButton.backgroundColor = .clear
        }
}
