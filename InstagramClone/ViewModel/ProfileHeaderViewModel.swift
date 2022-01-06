//
//  ProfileHeaderViewModel.swift
//  InstagramClone
//
//  Created by Mitko on 17.03.21.
//

import UIKit

struct ProfileHeaderViewModel {

    let user: User?

    var fullName: String {
        return user?.fullName ?? ""
    }
    
    var profileImageUrl: URL? {
        return URL(string: user?.profileImageUrl ?? "")
    }
    
    var followButtonText: String {

        if (user?.isCurrentUser ?? false) {
            return "Edit Profile"
        }
        return (user?.isFollowed ?? false) ? "Following" : "Follow"
    }
    
    var followButtonBackgroundColor: UIColor {
        return (user?.isCurrentUser ?? false) ? .white : .systemBlue
    }
    
    var followButtonTextColor: UIColor {
        return (user?.isCurrentUser ?? false) ? .black : .white
    }
    
    var numberOfFollowing: NSAttributedString {
        return attributedStatText(value: user?.stats?.following ?? .zero, label: "following")
    }
    
    var numberOfFollowers: NSAttributedString {
        return attributedStatText(value: user?.stats?.followers ?? .zero, label: "followers")
    }

    var numberOfPosts: NSAttributedString {
        return attributedStatText(value: user?.stats?.posts ?? .zero, label: "posts")
    }

    init(user: User) {
        self.user = user
    }
    
    func attributedStatText(value: Int, label: String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(
            string: "\(value)\n",
            attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: label, attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return attributedText
    }
}
