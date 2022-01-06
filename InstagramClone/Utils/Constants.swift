//
//  Constants.swift
//  InstagramClone
//
//  Created by Mitko on 17.03.21.
//

import Firebase
import FirebaseFirestore

let COLLECTION_USERS = Firestore.firestore().collection("users")
let COLLECTION_FOLLOWING = Firestore.firestore().collection("following")
let COLLECTION_FOLLOWERS = Firestore.firestore().collection("followers")
let COLLECTION_POSTS = Firestore.firestore().collection("posts")
