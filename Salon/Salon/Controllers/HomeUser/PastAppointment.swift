
import UIKit
import PopupDialog

class PastAppointment: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var PastAppointmentTableView: UITableView!
    
    let arrStatus = ["Waiting","On Going","Confirmed","Confirmed","Waiting","Confirmed"]
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

}

// MARK: - Extension UITableView
extension PastAppointment: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrStatus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pastAppointmentAnimatedCell", for: indexPath) as! pastAppointmentCell
        
        let colorView = UIView()
        colorView.backgroundColor = UIColor.clear
        UITableViewCell.appearance().selectedBackgroundView = colorView
        let getStatusUpdate = arrStatus[indexPath.row]
        
        
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
