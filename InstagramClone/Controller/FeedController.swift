//
//  FeedController.swift
//  InstagramClone
//
//  Created by Mitko on 13.02.21.
//

import UIKit
import FirebaseAuth

private var reuseIdentifier = "Cell"

class FeedController: UICollectionViewController {
    
    // MARK: - Properties
    
    private var posts = [Post]()
    var post: Post?

    private let refreshControl = UIRefreshControl()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureUI()
        fetchPosts()
    }
    
    // MARK: - Actions
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
            let controller = LoginController()
            controller.delegate = self.tabBarController as? MainTabController
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        } catch {
            print("DEBUG: Failed to log out")
        }
    }

    @objc func handleBackButtonTap() {

        navigationController?.popViewController(animated: true)
    }

    @objc func handleRefresh() {

        posts.removeAll()
        fetchPosts()
    }

    // MARK: - API
    
    func fetchPosts() {

        guard post == nil else { return }

        PostService.fetchPosts { posts in
            self.posts = posts
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Helpers

    func configureUI() {

        view.backgroundColor = .white
        collectionView.backgroundColor = .clear
        if post == nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                title: "Logout",
                style: .plain,
                target: self,
                action: #selector(handleLogout)
            )
        }
        
        navigationItem.title = "Feed"

        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)

        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.refreshControl = refreshControl
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension FeedController {

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return post == nil ? posts.count : 1
    }
        
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        if let post = post {
            cell.viewModel = PostViewModel(post: post)
        } else {
            cell.viewModel = PostViewModel(post: posts[indexPath.row])
        }
        cell.delegate = self
        return cell
    }
}

extension FeedController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = view.frame.width
        var height = width + 8 + 40 + 8 // top, bottom, right
        height += 50
        height += 60

        return CGSize(width: width, height: height)
    }
}

extension FeedController: FeedCellDelegate {

    func feedCell(_ cell: FeedCell, didShowCommentsFor post: Post) {

        let commentController = CommentController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(commentController, animated: true)
    }
}
