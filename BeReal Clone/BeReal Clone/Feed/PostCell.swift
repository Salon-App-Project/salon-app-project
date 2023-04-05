//
//  AppDelegate.swift
//  BeReal Clone
//
//  Created by Ruth Bilaro 3/18/23.

import UIKit
import Alamofire
import AlamofireImage

class PostCell: UITableViewCell {

    @IBOutlet var userImage: UIImageView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet private weak var postImageView: UIImageView!
    @IBOutlet private weak var captionLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!

    private var imageDataRequest: DataRequest?

    func configure(with post: Post) {
        // TODO: Pt 1 - Configure Post Cell
        
        // Username
        if let user = post.user {
            usernameLabel.text = user.username
        }

        // Image
        if let imageFile = post.imageFile,
           let imageUrl = imageFile.url {

            // Use AlamofireImage helper to fetch remote image from URL
            imageDataRequest = AF.request(imageUrl).responseImage { [weak self] response in
                switch response.result {
                case .success(let image):
                    // Set image view image with fetched image
                    self?.postImageView.image = image
                case .failure(let error):
                    print("❌ Error fetching image: \(error.localizedDescription)")
                    break
                }
            }
        }

        //location
        locationLabel.text = post.location
        
        // Caption
        captionLabel.text = post.caption

        // Date
        if let date = post.createdAt {
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .full
            let relativeDate = formatter.localizedString(for: date, relativeTo: Date())
            dateLabel.text = relativeDate
            //dateLabel.text = DateFormatter.postFormatter.string(from: date)
        }
        
        //profile photo
        //user profilephoto
        let initials = usernameLabel.text!.components(separatedBy: " ").reduce("") {
            ($0.isEmpty ? "" : "\($0.first?.uppercased() ?? "")") +
            ($1.isEmpty ? "" : "\($1.first?.uppercased() ?? "")")
        }
        let lblNameInitialize = UILabel()
        lblNameInitialize.frame.size = CGSize(width: 40.0, height: 40.0)
        lblNameInitialize.textColor = UIColor.white
        lblNameInitialize.text = initials
        lblNameInitialize.textAlignment = NSTextAlignment.center
        lblNameInitialize.backgroundColor = UIColor.gray
        lblNameInitialize.layer.cornerRadius = 40.0

        UIGraphicsBeginImageContext(lblNameInitialize.frame.size)
        lblNameInitialize.layer.render(in: UIGraphicsGetCurrentContext()!)
        userImage.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

    }

    override func prepareForReuse() {
        super.prepareForReuse()

        // Reset image view image.
        postImageView.image = nil

        // Cancel image request.
        imageDataRequest?.cancel()
    }
}
