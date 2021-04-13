//
//  FriendRequestModel.swift
//  AsiKarnesiMobil
//
//  Created by Elif Basak  Yildirim on 9.04.2021.
//

import Foundation

struct FriendRequestModel: Decodable {
    var friend_requests : [DetailedFriendRequestModel]
}

struct DetailedFriendRequestModel: Decodable, Hashable {
    var created, request_id, requester_email, requester_id, requester_name : String
}
