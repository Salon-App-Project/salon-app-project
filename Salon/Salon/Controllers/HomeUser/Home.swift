
import UIKit
import ParseSwift

class Home: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet var bFindSalon: UIButton!
    
    //for segue
    var enteredZip = ""
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        
        CommonClass().borderForImageView(customImgVw: profileImageView)
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height/2
        
        self.title = "Salon App"
        self.lblName.text = "Welcome \(User.current!.username!)"
        
        bFindSalon.layer.cornerRadius = 20
        bFindSalon.layer.masksToBounds = true
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    @IBAction func bFindSalonClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Zip Code", message: "Enter zip code to find salons.", preferredStyle: .alert)
        
        alert.addTextField { (tf) in
            tf.placeholder = "Write Zip Code"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
            let tf = alert.textFields![0]
            if let value = tf.text {
                self.enteredZip = value
                self.performSegue(withIdentifier: "findsalon", sender: nil)
            }
        })
        
        self.present(alert, animated: true)
    }
    
    @IBAction func bPastClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "past", sender: nil)
    }
    
    @IBAction func bUpdateProfileClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "editprofile", sender: nil)
    }
    @IBAction func bGenerateClicked(_ sender: Any) {
        var user = User.current
        user?.usercredits! += 100.00
        
        user?.save { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let details):
                    print("✅ Details Saved! \(details)")
                    
                case .failure(let error):
                    self?.view.makeToast(error.localizedDescription)
                }
            }
        }
        self.view.makeToast("100.00 credits added.")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "findsalon" {
            let vc = segue.destination as! FindSalonViewController
            vc.zipcode = enteredZip
        }
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
    
    @IBAction func unwindToHome(_ sender: UIStoryboardSegue) {}
}
