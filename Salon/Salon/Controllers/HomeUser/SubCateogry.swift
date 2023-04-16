
import UIKit
import ParseSwift
import Alamofire
import AlamofireImage

class SubCateogry: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var listView: UITableView!
    
    @IBOutlet var bAddStyle: UIBarButtonItem!
    
    private let refreshControl = UIRefreshControl()
    
    //from segue
    var selectedSalon:SalonDetails?
    
    //for segue
    var selectedStyle:Style!
    
    private var styles = [Style]() {
        didSet {
            // Reload table view data any time the posts variable gets updated.
            listView.reloadData()
        }
    }
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        if User.current!.usertype == "user" {
            bAddStyle.isEnabled = false
            bAddStyle.tintColor = UIColor.clear
            
        }
        
        listView.delegate = self
        listView.dataSource = self
        listView.allowsSelection = false
        if let _ = selectedSalon {
            listView.allowsSelection = true
        }

        listView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadStyles()
    }
    
    func loadStyles() {
        refreshControl.beginRefreshing()
        do {
            
            var constraint: QueryConstraint = try "user" == User.current!
            if let ss = selectedSalon {
                constraint = try
                "user" == ss.user!
            }
            let query = Style.query(constraint)
            
            query.find { [weak self] result in
                switch result {
                case .success(let styles):
                    self?.styles = styles
                    self?.refreshControl.endRefreshing()
                    
                    if styles.count == 0 {
                        self?.view.makeToast("No styles found")
                    }
                case .failure(let error):
                    self?.view.makeToast(error.localizedDescription)
                    self?.refreshControl.endRefreshing()
                }
            }
        } catch {
            self.view.makeToast(error.localizedDescription)
        }
    }
    
    @objc private func onPullToRefresh() {
        refreshControl.beginRefreshing()
        loadStyles()
    }
    
    @IBAction func bAddStyleClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "addstyle", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "styledetails" {
            let vc = segue.destination as! StylishDetails
            vc.selectedStyle = selectedStyle
        }
    }
}

// MARK: - Extension UITableView
extension SubCateogry: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return styles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subListAnimatedCell", for: indexPath) as! subListCell
        
        let colorView = UIView()
        colorView.backgroundColor = UIColor.clear
        UITableViewCell.appearance().selectedBackgroundView = colorView
        
        cell.configure(with: styles[indexPath.row])
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedStyle = styles[indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "styledetails", sender: nil)
    }
}

// MARK: - Class UITableViewCell
class subListCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var customVw: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imgVw: UIImageView!
    
    private var imageDataRequest: DataRequest?
    
    func configure(with style: Style) {
        
        lblName.text = style.stylename
        lblPrice.text = "$\(style.styleprice!)"
        
        // Image
        if let imageFile = style.imageFile,
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

    override func prepareForReuse() {
        super.prepareForReuse()

        // Reset image view image.
        imgVw.image = nil

        // Cancel image request.
        imageDataRequest?.cancel()
    }
    // MARK: - awakrFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
