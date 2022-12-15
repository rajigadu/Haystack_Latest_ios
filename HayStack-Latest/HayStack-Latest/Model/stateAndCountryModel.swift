//
//  stateAndCountryModel.swift
//  HayStack-Army
//
//  Created by rajesh gandru on 26/05/21.
//

import Foundation
import ObjectMapper

class countryModel :Codable,Mappable {
    var data : [countryModelData]?
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
class countryModelData :Codable,Mappable {
    var id : String?
    var sortname : String?
    var name : String?

    required init?(map: Map) {}
    init() {}
    func mapping(map: Map) {

        id <- map["id"]
        sortname <- map["sortname"]
        name <- map["name"]
    }

}
class StateModel :Codable,Mappable {
    var data : [StateModelData]?
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
class StateModelData :Codable,Mappable {
    var id : String?
    var name : String?
    var country_id : String?


    required init?(map: Map) {}
    init() {}
    func mapping(map: Map) {

        id <- map["id"]
        name <- map["name"]
        country_id <- map["country_id"]
    }

}
