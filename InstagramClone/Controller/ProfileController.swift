//
//  ProfileController.swift
//  InstagramClone
//
//  Created by Mitko on 13.02.21.
//

import UIKit

private var cellIdentifier = "ProfileCell"
private var headerIdentifier = "ProfileHeader"


class ProfileController: UICollectionViewController {

    // MARK: - Properties

    private var user: User?
    private var posts = [Post]()

    // MARK: - Lifecycle
    
    init(user: User?) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {

        super.viewDidLoad()
        configureCollectionViewController()
        checkIfUserIsFollowed()
    }
    
    override func viewDidAppear(_ animated: Bool) {

        fetchUserStats()
        fetchPosts()
    }
    // MARK: - API
    
    func checkIfUserIsFollowed() {
        UserService.checkIfUserIsFollowed(uid: user?.uid ?? "") { isFollowed in
            self.user?.isFollowed = isFollowed
            self.collectionView.reloadData()
        }
    }
    
    func fetchUserStats() {
        UserService.fetchUserStats(uid: user?.uid ?? "") { (stats) in
            self.user?.stats = stats
            self.collectionView.reloadData()
        }
    }
    
    func fetchPosts() {

        PostService.fetchPosts(forUser: user?.uid ?? "") { posts in
            self.posts = posts
            self.collectionView.reloadData()
        }
    }

    // MARK: - Helpers
    
    func configureCollectionViewController() {

        collectionView.backgroundColor = .white
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(
            ProfileHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: headerIdentifier
        )
    }
}

// MARK: - UICollectionViewDataSource

extension ProfileController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ProfileCell
        
        let post = posts[indexPath.row]

        cell.viewModel = PostViewModel(post: post)

        return cell
    }
    
    //header

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: headerIdentifier,
            for: indexPath
        ) as! ProfileHeader
        header.delegate = self

        if let user = user {
            header.viewModel = ProfileHeaderViewModel(user: user)
        }

        return header
    }
}

// MARK: - UICollectionViewDelegate

extension ProfileController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let post = posts[indexPath.row]
        let feedController = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        feedController.post = post
        navigationController?.pushViewController(feedController, animated: true)
    }
}

// MARK: - // MARK: - UICollectionViewDelegateFlowLayout

extension ProfileController: UICollectionViewDelegateFlowLayout {
    
    // spacing and sizing

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 240)
    }
}

// MARK: - ProfileHeaderDelegate

extension ProfileController: ProfileHeaderDelegate {

    func header(_ profileHeader: ProfileHeader, didTapActionButtonFor user: User) {
        
        if user.isCurrentUser {
            print("DEBUG: Show edit profile here...")
        } else if user.isFollowed {
            UserService.unfollow(uid: user.uid) { _ in
                self.user?.isFollowed = false
                self.collectionView.reloadData()
            }
        } else {
            UserService.follow(uid: user.uid) { _ in
                self.user?.isFollowed = true
                self.collectionView.reloadData()
            }
        }
    }
}
