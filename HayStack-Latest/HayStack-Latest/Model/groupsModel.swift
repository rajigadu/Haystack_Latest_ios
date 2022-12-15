//
//  groupsModel.swift
//  HayStack-Army
//
//  Created by rajesh gandru on 17/05/21.
//

import Foundation
import ObjectMapper
//{
//    "status": "1",
//    "groupid": 2,
//    "data": [
//        {
//            "groupid": 2
//        }
//    ],
//    "message": "Group has been created successfully."
//}
class CreateGroupModel:Codable,Mappable {
    
    var status : String?
    var message : String?
    var groupid : Int?
    var data : CreateGroupModelData?
    required init?(map: Map) {}
    init() {}
    func mapping(map: Map) {
         data <- map["data"]
        groupid <- map["groupid"]
        status <- map["status"]
        message <- map["message"]
     }
}
class CreateGroupModelData : Codable,Mappable {
    var groupid : String?
     

    required init?(map: Map) {}
    init() {}
    func mapping(map: Map) {

         groupid <- map["groupid"]
    }

}




struct GroupsListModel : Mappable {
    var data : [GroupsListModel_data]?
    var status : String?
    var message : String?
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        message <- map["message"]
        data <- map["data"]
        status <- map["status"]
    }

}
struct GroupsMemberModel : Mappable {
    var id : String?
    var groupid : String?
    var userid : String?
    var member : String?
    var email : String?
    var number : String?
    var dat : String?
    var status : String?

    

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        groupid <- map["groupid"]
        userid <- map["userid"]
        member <- map["member"]
        email <- map["email"]
        number <- map["number"]
        dat <- map["dat"]
        status <- map["status"]
    }

}
struct GroupsListModel_data : Mappable {
    var id : String?
    var userid : String?
    var gname : String?
    var gdesc : String?
    var membercount : String?
    var dat : String?
    var status : String?
    var member : [GroupsMemberModel]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        userid <- map["userid"]
        gname <- map["gname"]
        gdesc <- map["gdesc"]
        membercount <- map["membercount"]
        dat <- map["dat"]
        status <- map["status"]
        member <- map["member"]
    }

}
struct GroupsmembersListModel : Mappable {
    var data : [GroupsMemberModel]?
    var status : String?
    var message : String?
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        message <- map["message"]
        data <- map["data"]
        status <- map["status"]
    }

}
