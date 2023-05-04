
import UIKit
import PopupDialog
import ParseSwift

struct organizedApp {
    
}
class PastAppointment: UIViewController {

    struct organizedApps {
    var name: String
    var appointments: [Appointment]?
    }
    // MARK: - Outlet
    @IBOutlet weak var PastAppointmentTableView: UITableView!
    var apps: [organizedApps]? = []
    let constraints: QueryConstraint = "user" == User.current?.username
    var query: Query<Appointment> = Query()
    var appointments: [Appointment]? = []
    let dateFormatter = DateFormatter()
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        query = Appointment.query(constraints)
        query.find {[weak self] result in
            switch result {
            case .success(let array):
                self?.appointments = array
            case .failure(let error):
                print(error.description)
               // self?.view.makeToast(error.localizedDescription)
            }
        }
        
    }

}

// MARK: - Extension UITableView
extension PastAppointment: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.apps!.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.apps![section].appointments!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pastAppointmentAnimatedCell", for: indexPath) as! pastAppointmentCell
        let colorView = UIView()
        colorView.backgroundColor = UIColor.clear
        UITableViewCell.appearance().selectedBackgroundView = colorView
        cell.lblAppointmentSpecialistName.text = self.appointments![0].user?.username
        cell.lblAppointmentFor.text = self.appointments![0].name
        cell.lblAppointmentDate.text = dateFormatter.string(from: self.appointments![0].date!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - Class UITableViewCell
class pastAppointmentCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var customVw: UIView!
    @IBOutlet weak var lblAppointmentSpecialistName: UILabel!
    @IBOutlet weak var lblAppointmentFor: UILabel!
    @IBOutlet weak var lblAppointmentDate: UILabel!
    
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
