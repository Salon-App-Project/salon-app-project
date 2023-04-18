
import UIKit
import Alamofire
import AlamofireImage

class SalonDetailsViewController: UIViewController {

    @IBOutlet var labelSalonName: UILabel!
    @IBOutlet var labelSalonAddress: UILabel!
    @IBOutlet var labelSalonPhone: UILabel!
    @IBOutlet var bServices: UIButton!
    @IBOutlet var imgSalon: UIImageView!
    
    private var imageDataRequest: DataRequest?
    
    //from segue
    var selectedSalon:SalonDetails!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Salon Details"

        labelSalonName.text = selectedSalon.user!.username
        labelSalonAddress.text = selectedSalon.address
        labelSalonPhone.text = selectedSalon.phone
        
        // Image
        if let imageFile = selectedSalon.imageFile,
           let imageUrl = imageFile.url {

            // Use AlamofireImage helper to fetch remote image from URL
            imageDataRequest = AF.request(imageUrl).responseImage { [weak self] response in
                switch response.result {
                case .success(let image):
                    // Set image view image with fetched image
                    self?.imgSalon.image = image
                case .failure(let error):
                    print("❌ Error fetching image: \(error.localizedDescription)")
                    break
                }
            }
        }
        
        bServices.layer.cornerRadius = 20
        bServices.layer.masksToBounds = true
    }
    
    @IBAction func bServicesClicked(_ sender: Any) {
        performSegue(withIdentifier: "services", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "services" {
            let vc = segue.destination as! SubCateogry
            vc.selectedSalon = selectedSalon
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        imageDataRequest?.cancel()
    }
}
