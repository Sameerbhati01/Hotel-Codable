//
//  AddRegistrationTableViewController.swift
//  Hotel Codable
//
//  Created by Sameer Bhati on 17/06/25.
//

import UIKit

class AddRegistrationTableViewController: UITableViewController,SelectRoomTypeTableViewControllerDelegate {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet var checkInDateLabel: UILabel!

    @IBOutlet var checkInDatePicker: UIDatePicker!
    
    @IBOutlet var checkOutDateLabel: UILabel!

    @IBOutlet var checkOutDatePicker: UIDatePicker!
    
    
    @IBOutlet var numberOfAdultsLabel: UILabel!

    @IBOutlet var numberOfAdultsStepper: UIStepper!

    @IBOutlet var numberOfChildrenLabel: UILabel!

    @IBOutlet var numberOfChildrenStepper: UIStepper!
    
    @IBOutlet weak var wifiSwitch: UISwitch!
    
    @IBOutlet weak var roomTypeLabel: UILabel!
    
    var roomType: RoomType?
    
    var registration:Registration?{
        guard let roomType = roomType else { return nil}
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let checkInDate = checkInDatePicker.date
        let checkOutDate = checkOutDatePicker.date
        let numberOfAdults = Int(numberOfAdultsStepper.value)
        let numberOfChildren = Int (numberOfChildrenStepper.value)
        let hasWifi = wifiSwitch.isOn
        return Registration (firstName: firstName,
                             lastName: lastName, emailAddress: email, checkInDate: checkInDate, checkOutDate: checkOutDate, numberOfAdults: numberOfAdults, numberOfChildren: numberOfChildren, wifi: hasWifi,
        roomType: roomType)
    }
    
    let checkInDateLabelCellIndexPath: IndexPath = IndexPath(row: 0, section: 1)
    let checkOutDateLabelCellIndexPath: IndexPath = IndexPath(row: 2, section: 1)
    
    let checkInDatePickerCellIndexPath = IndexPath(row: 1, section: 1)
    let checkOutDatePickerCellIndexPath = IndexPath(row: 3, section: 1)
    var isCheckInDatePickerVisible: Bool = false {
        didSet {
            checkInDatePicker.isHidden = !isCheckInDatePickerVisible
        }
    }
    var isCheckOutDatePickerVisible: Bool = false {
        didSet {
            checkOutDatePicker.isHidden = !isCheckOutDatePickerVisible
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDateViews()
        updateNumberOfGuests()
        updateRoomType()
        
        let midnightoday = Calendar.current.startOfDay(for: Date())
        checkInDatePicker.minimumDate = midnightoday
        checkInDatePicker.date = midnightoday

    }
    
    func updateDateViews() {
        
        checkOutDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: checkInDatePicker.date)
        
        checkInDateLabel.text = checkInDatePicker.date.formatted(date: .abbreviated, time: .omitted)
        checkOutDateLabel.text = checkOutDatePicker.date.formatted(date: .abbreviated, time: .omitted)
        
    }
    
    func updateNumberOfGuests(){
        numberOfAdultsLabel.text = "\(Int(numberOfAdultsStepper.value))"
        numberOfChildrenLabel.text = "\(Int(numberOfChildrenStepper.value))"
    }
    
    func updateRoomType(){
        if let roomType = roomType{
            roomTypeLabel.text = roomType.name
        }else{
            roomTypeLabel.text = "Not Set"
        }
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        updateNumberOfGuests()
    }
    
    
    @IBAction func wifiSwitchChanged(_ sender: UISwitch) {
    }
    
    
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDateViews()
    }
    
    @IBAction func doneBarButtonTapped(_ sender: UIBarButtonItem) {
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let checkInDate = checkInDatePicker.date
        let checkOutDate = checkOutDatePicker.date
        let numberOfAdults = Int(numberOfAdultsStepper.value)
        let numberOfChildren = Int(numberOfChildrenStepper.value)
        let haswifi = wifiSwitch.isOn
        let roomChoice = roomType?.name ?? ""
        
        print ("DONE TAPPED" )
        print ("firstName: \(firstName)")
        print("lastName: \(lastName)")
        print("email: \(email)")
        print("checkIn: \(checkInDate)")
        print("checkOut: \(checkOutDate)")
        print("numberOfAdults:\(numberOfAdults))")
        print("numberOfChildren:\(numberOfChildren))")
        print("wifi: \(haswifi)")
        print("roomType: \(roomChoice)")
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath{
            case checkInDatePickerCellIndexPath where
                isCheckInDatePickerVisible == false:
                return 0
            case checkOutDatePickerCellIndexPath where
                isCheckOutDatePickerVisible == false:
                return 0
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath{
        case checkInDatePickerCellIndexPath:
            return 190
        case checkOutDatePickerCellIndexPath:
            return 190
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath == checkInDateLabelCellIndexPath && isCheckOutDatePickerVisible == false{
            isCheckInDatePickerVisible.toggle()
        }else if indexPath == checkOutDateLabelCellIndexPath && isCheckInDatePickerVisible == false{
            isCheckOutDatePickerVisible.toggle()
        }else if indexPath == checkInDateLabelCellIndexPath || indexPath == checkOutDateLabelCellIndexPath {
            isCheckInDatePickerVisible.toggle()
            isCheckOutDatePickerVisible.toggle()
        }else{
            return
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func selectRoomTypeTableViewController(_ controller: SelectRoomTypeTableViewController, didSelect roomType: RoomType){
        self.roomType = roomType
        updateRoomType()
    }
    
    
    @IBSegueAction func selectRoomType(_ coder: NSCoder) -> SelectRoomTypeTableViewController? {
        let selectRoomTypeController =
        SelectRoomTypeTableViewController(coder: coder)
        selectRoomTypeController?.delegate = self
        selectRoomTypeController?.roomType = roomType
        return selectRoomTypeController
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
