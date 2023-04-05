
import UIKit

class SalonHome: UIViewController {

    @IBOutlet var labelName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Salon App"
        
        labelName.text = "Welcome \(User.current!.username!)"
    }
    
    @IBAction func bAppointmentsClicked(_ sender: Any) {
        
    }
    
    @IBAction func bUpdateProfileClicked(_ sender: Any) {
        
    }
    
    @IBAction func bServicesClicked(_ sender: Any) {
        
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
    
}
