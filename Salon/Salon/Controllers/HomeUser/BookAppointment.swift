
import UIKit
import LGButton
import MessageUI
import ParseSwift

class BookAppointment: UIViewController, MFMailComposeViewControllerDelegate {

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
    var selectedSalon:SalonDetails!
    
    // MARK: - Actions
    @IBAction func bookAppointment(_ sender: LGButton) {
        if lblDateTime.text == "" {
            self.view.makeToast("Please select Date and Time")
        }
        else if txtFldFullName.text == "" || txtFldMobileNumber.text == "" {
            self.view.makeToast("Please enter Name and Mobile Number")
        }
        else {
            sender.isLoading = true
            
            let name = txtFldFullName.text!
            let phone = txtFldMobileNumber.text!
            let date = datePicker.date
            
            do {
                let constraint: QueryConstraint = try "user" == User.current!
                let query = UserDetails.query(constraint)
                
                query.first { [weak self] result in
                    switch result {
                    case .success(let userdetails):
                        var appointment = Appointment()
                        appointment.user = User.current!
                        appointment.salondetail = self?.selectedSalon
                        appointment.userdetail = userdetails
                        appointment.style = self?.selectedStyle
                        appointment.appointmentdate = date
                        appointment.customername = name
                        appointment.customerphone = phone
                        appointment.status = "Pending"
                        
                        appointment.save { [weak self] result in
                            DispatchQueue.main.async {
                                switch result {
                                case .success(let appointment):
                                    print("✅ Appointment Saved! \(appointment)")

                                    sender.isLoading = false

                                    // Post a notification that the user has successfully logged in.
                                    DispatchQueue.main.async {
                                        
                                        let salonname = self?.selectedSalon.user!.username!
                                        let stylename = self?.selectedStyle.stylename!
                                        let appdate = self?.lblDateTime.text!
                                        self?.sendEmail(recipient: (self?.selectedSalon.email!)!, message: "Hi \(salonname!),\n\nI want to book appointment for \(stylename!) at \(appdate!).Tell me if that works for you.\n\nThank you")
                                    }


                                case .failure(let error):
                                    self?.view.makeToast(error.localizedDescription)
                                }
                            }
                        }
                        
                    case .failure(let error):
                        self?.view.makeToast(error.localizedDescription)
                    }
                }
            } catch {
                self.view.makeToast(error.localizedDescription)
            }
        }
    }
    
    func sendEmail(recipient:String, message:String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([recipient])
            mail.setSubject("Appointment.")
            mail.setMessageBody(message, isHTML: false)
            
            present(mail, animated: true)
        } else {
            view.makeToast("Your device is not configured to send email")
            
            self.openAlert(setMsg: "Appointment Booked Successfully")
        }
    }
    
    func openAlert(setMsg: String) {
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Success", message: setMsg, preferredStyle: .alert)
        let saveActionButton = UIAlertAction(title: "Ok", style: .default)
        { _ in
            self.performSegue(withIdentifier: "backhome", sender: nil)
        }
        actionSheetControllerIOS8.addAction(saveActionButton)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
    
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.locale = .current
        datePicker.timeZone = .current
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
        dateFormatter.timeZone = .current
        dateFormatter.locale = .current
        let date = dateFormatter.string(from: datePicker.date)
        lblDateTime.text = date
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        
        self.openAlert(setMsg: "Appointment Booked Successfully")
    }
}
