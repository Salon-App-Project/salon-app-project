
import UIKit
import LGButton

class BookAppointment: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var lblStyleName: UILabel!
    @IBOutlet weak var lblStylePrice: UILabel!
    @IBOutlet weak var btnBook: LGButton!
    @IBOutlet weak var txtFldFullName: TextFieldEffects!
    @IBOutlet weak var txtFldMobileNumber: TextFieldEffects!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet var datePicker: UIDatePicker!
    
    //from segue
    var selectedStyle:Style!
    var user:User!
    
    // MARK: - Actions
    @IBAction func bookAppointment(_ sender: LGButton) {
        if lblDateTime.text == "" {
            self.view.makeToast("Please select Date and Time")
        }
        else if txtFldFullName.text == "" || txtFldMobileNumber.text == "" {
            self.view.makeToast("Please enter Name and Mobile Number")
        }
        else {
            var usercredits = user.usercredits
            usercredits = 200.00
            var salestotal = selectedStyle.styleprice
            var creditsafterpay = usercredits! - Double(salestotal!)!
            
            self.openAlert(setMsg: "Booked Appointment Successfully and Paid and have",creditsafterpay,"left")
        }
    }
    func openAlert(setMsg: String,_: Double,_: String) {
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Success", message: setMsg, preferredStyle: .alert)
        let saveActionButton = UIAlertAction(title: "Ok", style: .default)
        { _ in
            
        }
        actionSheetControllerIOS8.addAction(saveActionButton)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
    
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        datePicker.locale = .current
        datePicker.date = Date()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(dateSelected), for: .valueChanged)
        
        lblStyleName.text = selectedStyle.stylename
        lblStylePrice.text = "$\(selectedStyle.styleprice!)"
        
    }
    
    @objc func dateSelected() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let date = dateFormatter.string(from: datePicker.date)
        lblDateTime.text = date
    }
}
