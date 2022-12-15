//
//  MyEventsModel.swift
//  HayStack-Army
//
//  Created by rajesh gandru on 27/05/21.
//

import Foundation
import ObjectMapper

struct MyEventsModel : Mappable {
    var data : [SearchEventModeldata]?
    var status : String?
    var message : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        data <- map["data"]
        status <- map["status"]
        message <- map["message"]
    }

}
struct MyEventsModelData : Mappable {
    var id : String?
    var userid : String?
    var typ : String?
    var event_name : String?
    var shortd : String?
    var distance_km : String?
    var distance_miles : String?
    var category : String?
    var startdate : String?
    var startdate1 : String?
    var starttime : String?
    var starttime1 : String?
    var enddate : String?
    var enddate1 : String?
    var endtime : String?
    var endtime1 : String?
    var streetaddress : String?
    var photo : String?
    var membercount : String?
    var city : String?
    var state : String?
    var zipcode : String?
    var country : String?
    var latitude : String?
    var longitude : String?
    var hostname : String?
    var contactinfo : String?
    var hosttype : String?
    var dat : String?
    var event_description : String?
    var status : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
         
        id <- map["id"]
        userid <- map["userid"]
        typ <- map["typ"]
        event_name <- map["event_name"]
        shortd <- map["shortd"]
        distance_km <- map["distance_km"]
        distance_miles <- map["distance_miles"]
        category <- map["category"]
        
        
       
        
        startdate <- map["startdate"]
        startdate1 <- map["startdate1"]
        starttime <- map["starttime"]
        starttime1 <- map["starttime1"]
        enddate <- map["enddate"]
        enddate1 <- map["enddate1"]
        endtime <- map["endtime"]
        endtime1 <- map["endtime1"]
        streetaddress <- map["streetaddress"]
        photo <- map["photo"]
        
        
  
        
        membercount <- map["membercount"]
        city <- map["city"]
        state <- map["state"]
        zipcode <- map["zipcode"]
        country <- map["country"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        
   
        
        hostname <- map["hostname"]
        contactinfo <- map["contactinfo"]
        hosttype <- map["hosttype"]
        dat <- map["dat"]
        event_description <- map["event_description"]
        status <- map["status"]
    }

}

class Events_Invited_Model :Codable,Mappable {
    var data : [Events_Invited_Data]?
    var status : String?

    required init?(map: Map) {}
    init() {}
    func mapping(map: Map) {

        data <- map["data"]
        status <- map["status"]
    }

}

class Events_Invited_Data :Codable,Mappable {
    var id : String?
    var userid : String?
    var typ : String?
    var event_name : String?
    var shortd : String?
    var distance_km : String?
    var distance_miles : String?
    var category : String?
    var startdate : String?
    var startdate1 : String?
    var starttime : String?
    var starttime1 : String?
    var enddate : String?
    var enddate1 : String?
    var endtime : String?
    var endtime1 : String?
    var streetaddress : String?
    var photo : String?
    var membercount : String?
    var city : String?
    var state : String?
    var zipcode : String?
    var country : String?
    var latitude : String?
    var longitude : String?
    var hostname : String?
    var contactinfo : String?
    var hosttype : String?
    var dat : String?
    var event_description : String?
    var status : String?

    required init?(map: Map) {}
    init() {}
    func mapping(map: Map) {

        id <- map["id"]
        userid <- map["userid"]
        typ <- map["typ"]
        event_name <- map["event_name"]
        shortd <- map["shortd"]
        distance_km <- map["distance_km"]
        distance_miles <- map["distance_miles"]
        category <- map["category"]
        startdate <- map["startdate"]
        startdate1 <- map["startdate1"]
        starttime <- map["starttime"]
        starttime1 <- map["starttime1"]
        enddate <- map["enddate"]
        enddate1 <- map["enddate1"]
        endtime <- map["endtime"]
        endtime1 <- map["endtime1"]
        streetaddress <- map["streetaddress"]
        photo <- map["photo"]
        membercount <- map["membercount"]
        city <- map["city"]
        state <- map["state"]
        zipcode <- map["zipcode"]
        country <- map["country"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        hostname <- map["hostname"]
        contactinfo <- map["contactinfo"]
        hosttype <- map["hosttype"]
        dat <- map["dat"]
        event_description <- map["event_description"]
        status <- map["status"]
    }

}
