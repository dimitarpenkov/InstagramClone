//
//  PostViewModel.swift
//  InstagramClone
//
//  Created by Mitko on 1.04.21.
//

import UIKit
import Firebase

struct PostViewModel {

    let post: Post
    
    var caption: String { return post.caption }
    
    var likes: Int { return post.likes }
    
    var imageUrl: URL? { return URL(string: post.imageURL) }
    
    var ownerUid: String { return post.owernUid }
    
    var timestamp: Timestamp { return post.timestamp }

    var ownerImageUrl: URL? { return URL(string: post.ownerImageUrl) }

    var ownerUsername: String? { return post.ownerUsername}

    var likesLabelText: String {
        if post.likes != 1 {
            return "\(post.likes) likes"
        } else {
            return "\(post.likes) like"
        }
    }

    init(post: Post) {
        self.post = post
    }
}
