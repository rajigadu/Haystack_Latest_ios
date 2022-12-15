//
//  CreateEventModel.swift
//  HayStack-Army
//
//  Created by rajesh gandru on 18/05/21.
//

import Foundation
import ObjectMapper

class CreateEventListModel :Codable,Mappable {
    var data : [CreateEventListModelData]?
    var status : String?
    var message : String?
    required init?(map: Map) {}
    init() {}
    func mapping(map: Map) {
        message <- map["message"]
        data <- map["data"]
        status <- map["status"]
    }

}
class CreateEventListModelData :Codable,Mappable {
    var id : String?
    var category : String?
    var photo : String?
    var status : String?
    required init?(map: Map) {}
    init() {}
    func mapping(map: Map) {
        id <- map["id"]
        category <- map["category"]
        photo <- map["photo"]
        status <- map["status"]
    }

}
struct  FinalPushingEvent {
    
    var contactinfo: String?
    var hostname: String?
    var hosttype: String?
    var event_name: String?
     var startdate: String?
    var starttime: String?
    var enddate: String?
    var endtime: String?
     var category: String?
    var eventtype: String?
    var shortd: String?
     var streetaddress: String?
    var city: String?
    var state: String?
    var zipcode: String?
    var country: String?
    var latitude: String?
    var longitude: String?
   
    
    var allmembers: [AllMebersModel]?
    
}

struct AllMebersModel {
    var member : String?
    var email : String?
    var number : String?
}
