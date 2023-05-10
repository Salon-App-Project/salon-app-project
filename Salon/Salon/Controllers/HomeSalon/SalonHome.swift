
import UIKit
import ParseSwift
class SalonHome: UIViewController {

    @IBOutlet var labelName: UILabel!
    
    @IBOutlet weak var labelIncome:UILabel!
    var income: Double = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Salon App"
        labelIncome.layer.cornerRadius = labelIncome.frame.height / 4.0
        labelIncome.layer.masksToBounds = true
        labelIncome.text = String(income)
        labelName.text = "Welcome \(User.current!.username!)"
    }
    /*func grabDetails() {
        do {
            let constraint: QueryConstraint = try "user" == User.current
            
            let query = SalonDetails.query(constraint)
            
            query.first { [weak self] result in
                switch result {
                case .success(let salondetails):
                    self?.income = salondetails.salestotal
                case .failure(let error):
                    self?.view.makeToast(error.localizedDescription)
                }
            }
        } catch {
           self.view.makeToast(error.localizedDescription)
       }

                    
    }*/
    func loadIncome() {
        do {
            let constraint: QueryConstraint = try "user" == User.current
            let query = SalonDetails.query(constraint)
            
            query.first { [weak self] result in
                switch result {
                case .success(let userdetails):
                    self?.labelIncome.text = String(userdetails.salestotal!)
                    
                case .failure(let error):
                    self?.view.makeToast(error.localizedDescription)
                }
            }
        } catch {
            self.view.makeToast(error.localizedDescription)
        }
    }
    @IBAction func bAppointmentsClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "past", sender: nil)
    }
    
    @IBAction func bUpdateProfileClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "profile", sender: nil)
    }
    
    @IBAction func bServicesClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "style", sender: nil)
    }
    
    
    @IBAction func bLogoutClicked(_ sender: Any) {
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Alert", message: "Are you sure you want to logout?", preferredStyle: .alert)
        let saveActionButton = UIAlertAction(title: "Logout", style: .default)
        { _ in
            NotificationCenter.default.post(name: Notification.Name("logout"), object: nil)
        }
        actionSheetControllerIOS8.addAction(saveActionButton)
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .default)
        { _ in
            
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
    @IBAction func unwindToSalonHome(_ sender: UIStoryboardSegue){}
}
