//
//  AppDelegate.swift
//  BeReal Clone
//
//  Created by Ruth Bilaro 3/18/23.


import UIKit
import ParseSwift

class FeedViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()

    private var posts = [Post]() {
        didSet {
            // Reload table view data any time the posts variable gets updated.
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false

        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        queryPosts()
    }

    private func queryPosts(completion: (() -> Void)? = nil) {

        let yesterdayDate = Calendar.current.date(byAdding: .day, value: (-1), to: Date())!
        
        let query = Post.query()
            .include("user")
            .order([.descending("createdAt")])
            .where("createdAt" >= yesterdayDate)
            .limit(10)
            .order([.descending("createdAt")])

        // Find and return posts that meet query criteria (async)
        query.find { [weak self] result in
            switch result {
            case .success(let posts):
                // Update the local posts property with fetched posts
                self?.posts = posts
            case .failure(let error):
                self?.showAlert(description: error.localizedDescription)
            }

            // Call the completion handler (regardless of error or success, this will signal the query finished)
            // This is used to tell the pull-to-refresh control to stop refresshing
            completion?()
        }
    }

    @IBAction func onLogOutTapped(_ sender: Any) {
        showConfirmLogoutAlert()
    }

    @objc private func onPullToRefresh() {
        refreshControl.beginRefreshing()
        queryPosts { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }

    private func showConfirmLogoutAlert() {
        let alertController = UIAlertController(title: "Log out of \(User.current?.username ?? "current account")?", message: nil, preferredStyle: .alert)
        let logOutAction = UIAlertAction(title: "Log out", style: .destructive) { _ in
            NotificationCenter.default.post(name: Notification.Name("logout"), object: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(logOutAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell else {
            return UITableViewCell()
        }
        cell.configure(with: posts[indexPath.row])
        return cell
    }
}

extension FeedViewController: UITableViewDelegate { }
