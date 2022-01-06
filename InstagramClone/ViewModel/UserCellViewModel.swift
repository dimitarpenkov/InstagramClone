//
//  UserCellViewModel.swift
//  InstagramClone
//
//  Created by Mitko on 17.03.21.
//

import Foundation

struct UserCellViewModel {
    
    private let user: User

    var profileImageURL: URL? {
        return URL(string: user.profileImageUrl)
    }
    
    var username: String {
        return user.username
    }
    
    var fullname: String {
        return user.fullName
    }
    
    init(user: User) {
        self.user = user
    }
}
