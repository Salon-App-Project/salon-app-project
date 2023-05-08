
import UIKit
import ParseSwift
import Alamofire
import AlamofireImage

class FindSalonViewController: UIViewController {

    @IBOutlet var tableSalons: UITableView!
    @IBOutlet var labelResult: UILabel!
    
    private let refreshControl = UIRefreshControl()
    
    private var salons = [SalonDetails]() {
        didSet {
            // Reload table view data any time the posts variable gets updated.
            tableSalons.reloadData()
        }
    }
    
    //for segue
    var clickedSalon:SalonDetails?
    
    //from segue
    var zipcode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        labelResult.text = "Salons at \(zipcode)"
        
        tableSalons.delegate = self
        tableSalons.dataSource = self
        tableSalons.allowsSelection = true

        tableSalons.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadSalons()
    }
    
    func loadSalons() {
        refreshControl.beginRefreshing()
        
        let constraint: QueryConstraint = "zipcode" == zipcode
        let query = SalonDetails.query(constraint)
            .include("user")
        
        query.find { [weak self] result in
            switch result {
            case .success(let salons):
                self?.salons = salons
                self?.refreshControl.endRefreshing()
                
                if salons.count == 0 {
                    self?.view.makeToast("No salons found")
                }
            case .failure(let error):
                self?.view.makeToast(error.localizedDescription)
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    @objc private func onPullToRefresh() {
        refreshControl.beginRefreshing()
        loadSalons()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "salondetails" {
            let vc = segue.destination as! SalonDetailsViewController
            vc.selectedSalon = clickedSalon
        }
    }
}

extension FindSalonViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return salons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FindSalonCell
        
        let colorView = UIView()
        colorView.backgroundColor = UIColor.clear
        UITableViewCell.appearance().selectedBackgroundView = colorView
        
        cell.configure(with: salons[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        clickedSalon = salons[indexPath.row]
        
        self.performSegue(withIdentifier: "salondetails", sender: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Class UITableViewCell
class FindSalonCell: UITableViewCell {
    @IBOutlet var imageSalon: UIImageView!
    @IBOutlet var labelSalonName: UILabel!
    @IBOutlet var labelSalonAddress: UILabel!
    
    private var imageDataRequest: DataRequest?
    
    func configure(with salon: SalonDetails) {
        
        labelSalonName.text = salon.user?.username
        labelSalonAddress.text = salon.address
        
        // Image
        if let imageFile = salon.imageFile,
           let imageUrl = imageFile.url {

            // Use AlamofireImage helper to fetch remote image from URL
            imageDataRequest = AF.request(imageUrl).responseImage { [weak self] response in
                switch response.result {
                case .success(let image):
                    // Set image view image with fetched image
                    self?.imageSalon.image = image
                case .failure(let error):
                    print("❌ Error fetching image: \(error.localizedDescription)")
                    break
                }
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        // Reset image view image.
        imageSalon.image = nil

        // Cancel image request.
        imageDataRequest?.cancel()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
