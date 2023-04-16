
import UIKit
import LGButton
import ParseSwift
import Alamofire
import AlamofireImage

class StylishDetails: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var detailScrollView: UIScrollView!
    @IBOutlet var imgVw: UIImageView!
    @IBOutlet weak var lblStylishName: UILabel!
    @IBOutlet weak var lblStylishDescription: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnBookAppointment: LGButton!
    
    private var imageDataRequest: DataRequest?
    
    //from segue
    var selectedStyle:Style!
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        lblStylishName.text = selectedStyle.stylename
        lblStylishDescription.text = selectedStyle.styledescription
        lblPrice.text = "$\(selectedStyle.styleprice!)"
        
        if let imageFile = selectedStyle.imageFile,
           let imageUrl = imageFile.url {

            // Use AlamofireImage helper to fetch remote image from URL
            imageDataRequest = AF.request(imageUrl).responseImage { [weak self] response in
                switch response.result {
                case .success(let image):
                    // Set image view image with fetched image
                    self?.imgVw.image = image
                case .failure(let error):
                    print("❌ Error fetching image: \(error.localizedDescription)")
                    break
                }
            }
        }
    }
    
    // MARK: - Action
    @IBAction func bookAppointment(_ sender: LGButton)
    {
        self.performSegue(withIdentifier: "book", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "book" {
            let vc = segue.destination as! BookAppointment
            vc.selectedStyle = selectedStyle
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        imageDataRequest?.cancel()
    }
    
}
