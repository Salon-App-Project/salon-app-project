
import UIKit
import PopupDialog
import ParseSwift
import MessageUI
struct organizedAppointments{
var statusName: String?
var apps: [Appointment]
}
class PastAppointment: UIViewController, MFMailComposeViewControllerDelegate {

    // MARK: - Outlets
    @IBOutlet weak var appointmentTableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    
    var clickedAppointment:Appointment!
    
    private var appointments = [Appointment]() {
        didSet {
            // Reload table view data any time the posts variable gets updated.
            appointmentTableView.reloadData()
        }
    }
    var sections = [organizedAppointments]() {
        didSet {
            appointmentTableView.reloadData()
        }
    }
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        appointmentTableView.delegate = self
        appointmentTableView.dataSource = self
        appointmentTableView.allowsSelection = true

        appointmentTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadAppointments()
    }
    
    func loadAppointments() {
        refreshControl.beginRefreshing()
        
        do {
            if User.current!.usertype == "salon" {
                let constraint: QueryConstraint = try "user" == User.current!
                let query = SalonDetails.query(constraint)
                
                query.first { [weak self] result in
                    switch result {
                    case .success(let salondetails):
                        do {
                            let constraint2: QueryConstraint = try "salondetail" == salondetails
                            
                            let query2 = Appointment.query(constraint2)
                                .include("user", "salondetail", "style", "salondetail.user", "userdetail", "userdetail.user")
                                .order([.descending("appointmentdate")])
                            
                            query2.find { [weak self] result in
                                switch result {
                                case .success(let appointments):
                                    print(appointments)
                                    
                                    self?.appointments = appointments
                                    self?.refreshControl.endRefreshing()
                                    
                                    if appointments.count == 0 {
                                        self?.view.makeToast("No past appointments")
                                    }
                                    else {
                                        self?.sectionsCreate()
                                    }
                                case .failure(let error):
                                    self?.view.makeToast(error.localizedDescription)
                                    self?.refreshControl.endRefreshing()
                                }
                            }
                        }catch {
                            self?.view.makeToast(error.localizedDescription)
                        }
                        
                    case .failure(let error):
                        self?.view.makeToast(error.localizedDescription)
                    }
                }
            } else {
                let constraint: QueryConstraint = try "user" == User.current!
                
                let query = Appointment.query(constraint)
                    .include("user", "salondetail", "style", "salondetail.user", "userdetail", "userdetail.user")
                    .order([.descending("appointmentdate")])
                
                query.find { [weak self] result in
                    switch result {
                    case .success(let appointments):
                        print(appointments)
                        
                        self?.appointments = appointments
                        self?.refreshControl.endRefreshing()
                        
                        if appointments.count == 0 {
                            self?.view.makeToast("No past appointments")
                        }
                        else {
                            self?.sectionsCreate()
                        }
                    case .failure(let error):
                        self?.view.makeToast(error.localizedDescription)
                        self?.refreshControl.endRefreshing()
                    }
                }
            }
        } catch {
            self.view.makeToast(error.localizedDescription)
        }
        
    }
    
    @objc private func onPullToRefresh() {
        refreshControl.beginRefreshing()
        loadAppointments()
    }
    func sectionsCreate() {
        let groups = Dictionary(grouping: self.appointments) { (appointment) in
            return appointment.status
        }
        self.sections = groups.map(organizedAppointments.init(statusName:apps:))
        self.sections.sort{ (lhs, rhs) in
            if (rhs.statusName == "Pending") {
                return false
            } else if (lhs.statusName == "Cancelled") {
                return false
            } else {
                return true
            }
        }
    }
}


// MARK: - Extension UITableView
extension PastAppointment: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentSection = self.sections[section]
        return currentSection.apps.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let currentSection = self.sections[section]
        return currentSection.statusName
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pastAppointmentAnimatedCell", for: indexPath) as! pastAppointmentCell
        let currentSection = sections[indexPath.section]
        let colorView = UIView()
        colorView.backgroundColor = UIColor.clear
        UITableViewCell.appearance().selectedBackgroundView = colorView
        
        if User.current!.usertype == "salon" {
            cell.lblAppointmentSalonName.text = currentSection.apps[indexPath.row].customername
        } else {
            cell.lblAppointmentSalonName.text = currentSection.apps[indexPath.row].salondetail!.user!.username
        }
        
        cell.lblAppointmentStyle.text = "\(currentSection.apps[indexPath.row].style!.stylename!) - $\(currentSection.apps[indexPath.row].style!.styleprice!)"
        
        cell.lblStatus.text = currentSection.apps[indexPath.row].status!
        
        if currentSection.apps[indexPath.row].status! == "Pending" {
            cell.lblStatus.textColor = .orange
        } else if currentSection.apps[indexPath.row].status! == "Confirmed" {
            cell.lblStatus.textColor = .green
        } else if currentSection.apps[indexPath.row].status! == "Cancelled" {
            cell.lblStatus.textColor = .red
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.timeZone = .current
        dateFormatter.locale = .current
        let date = dateFormatter.string(from: currentSection.apps[indexPath.row].appointmentdate!)
        cell.lblAppointmentDate.text = date
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let currentSection = sections[indexPath.section]
        clickedAppointment = currentSection.apps[indexPath.row]
        
        if appointments[indexPath.row].status == "Pending" && User.current!.usertype == "salon" {
            openActionSheet(usertype: "salon")
        } else if appointments[indexPath.row].status != "Cancelled" && User.current!.usertype == "user" {
            openActionSheet(usertype: "user")
        }
    }
    
    func openActionSheet(usertype:String) {
        let alert = UIAlertController(title: "Choose", message: nil, preferredStyle: .actionSheet)
        
        if usertype == "salon" {
            alert.addAction(UIAlertAction(title: "Confirm Appointment", style: .default) {
                action in
                
                self.clickedAppointment.status = "Confirmed"
                self.clickedAppointment.save {[weak self] result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let appointment):
                                print("✅ Appointment Confirmed! \(appointment)")
                            
                                let username = self?.clickedAppointment.userdetail!.user!.username!
                                let stylename = self?.clickedAppointment.style!.stylename!
                                let styledate = self?.clickedAppointment.appointmentdate!
                                
                                self?.sendEmail(recipient: (self?.clickedAppointment.userdetail!.email!)!, message: "Hi \(username!),\n\nYour \(stylename!) appointment is confirmed for \(styledate!).\n\nThank you", subject: "Your Appointment Is Confirmed")
                            case .failure(let error):
                                self?.view.makeToast(error.localizedDescription)
                            }
                        }
                }
            })
        }
        else if usertype == "user" {
            alert.addAction(UIAlertAction(title: "Cancel Appointment", style: .default) {
                action in
                
                self.clickedAppointment.status = "Cancelled"
                self.clickedAppointment.save {[weak self] result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let appointment):
                                print("✅ Appointment Cancelled! \(appointment)")
                                
                                let username = self?.clickedAppointment.salondetail!.user!.username!
                                let stylename = self?.clickedAppointment.style!.stylename!
                                let styledate = self?.clickedAppointment.appointmentdate!
                                
                                self?.sendEmail(recipient: (self?.clickedAppointment.userdetail!.email!)!, message: "Hi \(username!),\n\nI'm sorry, but I will have to cancel my appointment for \(stylename!) at \(styledate!).\n\nI'd appreciate your understanding. Thank you", subject: "Appointment Cancellation")
                            case .failure(let error):
                                self?.view.makeToast(error.localizedDescription)
                            }
                        }
                }
            })
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        
        self.present(alert, animated: true)
    }
    
    func sendEmail(recipient:String, message:String, subject:String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([recipient])
            mail.setSubject(subject)
            mail.setMessageBody(message, isHTML: false)
            
            present(mail, animated: true)
        } else {
            view.makeToast("Your device is not configured to send email")
            
            if User.current!.usertype == "salon" {
                view.makeToast("Appointment Confirmed")
            } else {
                view.makeToast("Appointment Cancelled")
            }
            
            loadAppointments()
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        
        if User.current!.usertype == "salon" {
            view.makeToast("Appointment Confirmed")
        } else {
            view.makeToast("Appointment Cancelled")
        }
        
        loadAppointments()
    }
    
}

// MARK: - Class UITableViewCell
class pastAppointmentCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var customVw: UIView!
    @IBOutlet weak var lblAppointmentSalonName: UILabel!
    @IBOutlet weak var lblAppointmentStyle: UILabel!
    @IBOutlet weak var lblAppointmentDate: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    // MARK: - awakrFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        customVw.layer.cornerRadius = 10
        customVw.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
