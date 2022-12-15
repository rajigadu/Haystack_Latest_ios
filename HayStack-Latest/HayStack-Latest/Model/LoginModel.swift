//
//  LoginModel.swift
//  HayStack-Army
//
//  Created by rajesh gandru on 13/05/21.
//

import Foundation
import UIKit
import ObjectMapper


class UserModel:Codable,Mappable {
    var data : UserModelData?
    var status : String?
    var message : String?
    var lognied_User : String?
    required init?(map: Map) {}
    init() {}
    func mapping(map: Map) {
         data <- map["data"]
        status <- map["status"]
        message <- map["message"]
        lognied_User <- map["lognied_User"]
    }
}

class SoldierUser : Codable,Mappable {
    var id : String?
    var fname : String?
    var lname : String?
    var govt_email : String?
    var username : String?
    var dod_id : String?

    required init?(map: Map) {}
    init() {}
    func mapping(map: Map) {

        id <- map["id"]
        fname <- map["fname"]
        lname <- map["lname"]
        govt_email <- map["govt_email"]
        username <- map["username"]
        dod_id <- map["dod_id"]
    }

}

class UserModelData : Codable,Mappable {
    var soldier : SoldierUser?
    var spouse : SpouseUser?

    required init?(map: Map) {}
    init() {}
    func mapping(map: Map) {

        soldier <- map["soldier"]
        spouse <- map["spouse"]
    }

}

class SpouseUser : Codable,Mappable {
    var id : String?
    var sub_id : String?
    var fname : String?
    var lname : String?
    var sponsors_govt_email : String?
    var username : String?
    var sponsor_id : String?
    var relation_to_sm : String?

    required init?(map: Map) {}
    init() {}
    func mapping(map: Map) {

        id <- map["id"]
        sub_id <- map["sub_id"]
        fname <- map["fname"]
        lname <- map["lname"]
        sponsors_govt_email <- map["sponsors_govt_email"]
        username <- map["username"]
        sponsor_id <- map["sponsor_id"]
        relation_to_sm <- map["relation_to_sm"]
    }

}



class RegisterUserModel:Codable,Mappable {
    var status  = ""
    var message = ""
    var uid = ""
    required init?(map: Map) {}
    init() {}
    func mapping(map: Map) {
        status <- map ["status"]
        message <- map ["message"]
        uid <- map ["uid"]
    }
}


class newUserModel :Codable,Mappable {
    var data : [NewUserModelData]?
    var status : String?

    required init?(map: Map) {}
    init() {}
    func mapping(map: Map) {

        data <- map["data"]
        status <- map["status"]
    }

}
class NewUserModelData :Codable,Mappable {
    var id : String?
    var acc_type : String?
    var fname : String?
    var lname : String?
    var govt_email : String?
    var username : String?
    var dod_id : String?
    var businessname : String?
    var businesstype : String?
    var employes : String?
    var email : String?
    var password : String?
    var mobile : String?
    var latitude : String?
    var longitude : String?
    var city : String?
    var state : String?
    var country : String?
    var zipcode : String?
    var address : String?
    var profilephoto : String?
    var devicetoken : String?
    var devicetyp : String?
    var cardtype : String?
    var device_id : String?
    var nameoncard : String?
    var cardno : String?
    var billingaddress : String?
    var bcity : String?
    var bstate : String?
    var bcountry : String?
    var companyname : String?
    var expirydate : String?
    var ccv : String?
    var dat : String?
    var status : String?

    required init?(map: Map) {}
    init() {}
    func mapping(map: Map) {

        id <- map["id"]
        acc_type <- map["acc_type"]
        fname <- map["fname"]
        lname <- map["lname"]
        govt_email <- map["govt_email"]
        username <- map["username"]
        dod_id <- map["dod_id"]
        businessname <- map["businessname"]
        businesstype <- map["businesstype"]
        employes <- map["employes"]
        email <- map["email"]
        password <- map["password"]
        mobile <- map["mobile"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        city <- map["city"]
        state <- map["state"]
        country <- map["country"]
        zipcode <- map["zipcode"]
        address <- map["address"]
        profilephoto <- map["profilephoto"]
        devicetoken <- map["devicetoken"]
        devicetyp <- map["devicetyp"]
        cardtype <- map["cardtype"]
        device_id <- map["device_id"]
        nameoncard <- map["nameoncard"]
        cardno <- map["cardno"]
        billingaddress <- map["billingaddress"]
        bcity <- map["bcity"]
        bstate <- map["bstate"]
        bcountry <- map["bcountry"]
        companyname <- map["companyname"]
        expirydate <- map["expirydate"]
        ccv <- map["ccv"]
        dat <- map["dat"]
        status <- map["status"]
    }

}


class editUserModel :Codable,Mappable {
    var data : [NewUserModelData]?
    var status : String?
    var message : String?

    required init?(map: Map) {}
    init() {}
    func mapping(map: Map) {

        data <- map["data"]
        status <- map["status"]
        message <- map["message"]
    }

}


//{"status":"1","data":[{"message":"Message sent successfully."}]}

class ReferFriendModel :Codable,Mappable {
    var data : [ReferFriendModelData]?
    var status : String?
    var message : String?

    required init?(map: Map) {}
    init() {}
    func mapping(map: Map) {

        data <- map["data"]
        status <- map["status"]
        message <- map["message"]
    }

}

class ReferFriendModelData :Codable,Mappable {
     var message : String?

    required init?(map: Map) {}
    init() {}
    func mapping(map: Map) {
        message <- map["message"]
    }

}


//["status": 1, "message": Password has been changed successfully.]

class changedPasswordModel :Codable,Mappable {
   // var data : ReferFriendModelData?
    var status : String?
    var message : String?

    required init?(map: Map) {}
    init() {}
    func mapping(map: Map) {

       // data <- map["data"]
        status <- map["status"]
        message <- map["message"]
    }

}
