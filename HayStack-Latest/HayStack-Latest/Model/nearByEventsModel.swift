//
//  nearByEventsModel.swift
//  HayStack-Army
//
//  Created by rajesh gandru on 04/06/21.
//

import Foundation
import ObjectMapper
class nearByEventsModel:Codable,Mappable {
      var data : [nearByEventsModelData]?
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
class nearByEventsModelData:Codable,Mappable {
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


//{
//    "data": [
//        {
//            "id": "653",
//            "userid": "16",
//            "typ": "Public",
//            "event_name": "Mohali Tour",
//            "shortd": "test",
//            "distance_km": "0",
//            "distance_miles": "0",
//            "category": "People - Health & Wellness,Modernization - Information Operations - Cyber",
//            "startdate": "06-03-2021",
//            "startdate1": "2021-06-03",
//            "starttime": "09:05 PM",
//            "starttime1": "21",
//            "enddate": "06-23-2021",
//            "enddate1": "2021-06-23",
//            "endtime": "11:12 PM",
//            "endtime1": "23",
//            "streetaddress": "phase 5 sector 59 ",
//            "photo": "",
//            "membercount": "1",
//            "city": "Mohali",
//            "state": "Punjab",
//            "zipcode": "160059",
//            "country": "India",
//            "latitude": "30.7145",
//            "longitude": "76.7149",
//            "hostname": "harvinder singh",
//            "contactinfo": "8360757603",
//            "hosttype": "Public",
//            "dat": "2021-06-03 10:57:02",
//            "event_description": "",
//            "status": "1"
//        },
//        {
//            "id": "643",
//            "userid": "13",
//            "typ": "Public",
//            "event_name": "Memorial Day Observation",
//            "shortd": "",
//            "distance_km": "3644",
//            "distance_miles": "2265",
//            "category": "People - Retention - Community Relations (COMREL)",
//            "startdate": "06-01-2021",
//            "startdate1": "2021-06-01",
//            "starttime": "06:00 AM",
//            "starttime1": "6",
//            "enddate": "06-30-2021",
//            "enddate1": "2021-06-30",
//            "endtime": "06:00 AM",
//            "endtime1": "6",
//            "streetaddress": "230 R T Jones Rd",
//            "photo": "EEerTnVTEimage.jpg",
//            "membercount": "0",
//            "city": "Mountain View",
//            "state": "California",
//            "zipcode": "94043",
//            "country": "United States",
//            "latitude": "37.418871",
//            "longitude": "-122.0800265",
//            "hostname": "63D RD",
//            "contactinfo": "650-526-6055",
//            "hosttype": "Private",
//            "dat": "2021-05-29 14:40:29",
//            "event_description": "To honor those who made the ultimate sacrifice ",
//            "status": "1"
//        },
//        {
//            "id": "656",
//            "userid": "4",
//            "typ": "Public",
//            "event_name": "man from the dark world",
//            "shortd": "",
//            "distance_km": "0",
//            "distance_miles": "0",
//            "category": "People - Health & Wellness,Modernization - Information Operations - Cyber,Readiness - Mobilization & Power Projection,Readiness - Equipping & Fielding",
//            "startdate": "06-04-2021",
//            "startdate1": "2021-06-04",
//            "starttime": "10:00 AM",
//            "starttime1": "10",
//            "enddate": "06-15-2021",
//            "enddate1": "2021-06-15",
//            "endtime": "11:00 PM",
//            "endtime1": "23",
//            "streetaddress": "mohali phase 5",
//            "photo": "",
//            "membercount": "2",
//            "city": "mamillapalli",
//            "state": "Andhra Pradesh\n\n\n",
//            "zipcode": "523303",
//            "country": "india",
//            "latitude": "30.714478",
//            "longitude": "76.7148927",
//            "hostname": "Harvinder",
//            "contactinfo": "7307151068",
//            "hosttype": "Public",
//            "dat": "2021-06-04 08:58:59",
//            "event_description": "",
//            "status": "1"
//        },
//        {
//            "id": "661",
//            "userid": "1",
//            "typ": "Public",
//            "event_name": "Holiday monday",
//            "shortd": "",
//            "distance_km": "0",
//            "distance_miles": "0",
//            "category": "People - Health & Wellness,Modernization - Information Operations - Cyber,Readiness - Mobilization & Power Projection,Readiness - Equipping & Fielding",
//            "startdate": "12-06-2021",
//            "startdate1": "2021-12-06",
//            "starttime": "10:00 AM",
//            "starttime1": "10",
//            "enddate": "06-28-2021",
//            "enddate1": "2021-06-28",
//            "endtime": "11:00 PM",
//            "endtime1": "23",
//            "streetaddress": "mohali phase 5",
//            "photo": "",
//            "membercount": "2",
//            "city": "mohali",
//            "state": "punjab",
//            "zipcode": "160059",
//            "country": "india",
//            "latitude": "30.714478",
//            "longitude": "76.7148927",
//            "hostname": "Harvinder",
//            "contactinfo": "7307151068",
//            "hosttype": "Public",
//            "dat": "2021-06-04 09:37:45",
//            "event_description": "",
//            "status": "1"
//        },
//        {
//            "id": "651",
//            "userid": "16",
//            "typ": "Public",
//            "event_name": "Himachali tours",
//            "shortd": "",
//            "distance_km": "0",
//            "distance_miles": "0",
//            "category": "People - Health & Wellness,Modernization - Information Operations - Cyber,Modernization - Information Operations - Cyber,Readiness - Equipping & Fielding,Readiness - Equipping & Fielding,People - Rete",
//            "startdate": "06-04-2021",
//            "startdate1": "2021-06-04",
//            "starttime": "09:00 AM",
//            "starttime1": "9",
//            "enddate": "06-10-2021",
//            "enddate1": "2021-06-10",
//            "endtime": "12:00 PM",
//            "endtime1": "24",
//            "streetaddress": "village rail tehsil Jaswan district Kangra",
//            "photo": "nVETerEETimage.jpg",
//            "membercount": "0",
//            "city": "dada siba",
//            "state": "Himachal Pradesh",
//            "zipcode": "177106",
//            "country": "India",
//            "latitude": "31.9198827",
//            "longitude": "76.1174988",
//            "hostname": "Harvinder Singh ",
//            "contactinfo": "8360757603",
//            "hosttype": "Public",
//            "dat": "2021-06-03 08:26:00",
//            "event_description": "Test",
//            "status": "1"
//        },
//        {
//            "id": "660",
//            "userid": "4",
//            "typ": "Public",
//            "event_name": "h",
//            "shortd": "",
//            "distance_km": "0",
//            "distance_miles": "0",
//            "category": "People - Health & Wellness,Modernization - Information Operations - Cyber,Readiness - Mobilization & Power Projection,Readiness - Equipping & Fielding,Readiness - Equipping & Fielding",
//            "startdate": "06-04-2021",
//            "startdate1": "2021-06-04",
//            "starttime": "03:03 PM",
//            "starttime1": "15",
//            "enddate": "06-08-2021",
//            "enddate1": "2021-06-08",
//            "endtime": "03:03 PM",
//            "endtime1": "15",
//            "streetaddress": "mammillapalli ",
//            "photo": "EETEeTnrVimage.jpg",
//            "membercount": "1",
//            "city": "mammillapalli ",
//            "state": "Andhra Pradesh",
//            "zipcode": "523303",
//            "country": "India",
//            "latitude": "16.0177358",
//            "longitude": "79.9157721",
//            "hostname": "output",
//            "contactinfo": "6536888",
//            "hosttype": "Public",
//            "dat": "2021-06-04 09:34:28",
//            "event_description": "Jcivivib",
//            "status": "1"
//        },
//        {
//            "id": "659",
//            "userid": "4",
//            "typ": "Public",
//            "event_name": "gouciycoyc",
//            "shortd": "",
//            "distance_km": "0",
//            "distance_miles": "0",
//            "category": "Readiness - Individual & Collective Training,People - Retention - Community Relations (COMREL),Readiness - Equipping & Fielding,Readiness - Equipping & Fielding",
//            "startdate": "06-04-2021",
//            "startdate1": "2021-06-04",
//            "starttime": "03:01 PM",
//            "starttime1": "15",
//            "enddate": "06-08-2021",
//            "enddate1": "2021-06-08",
//            "endtime": "03:01 PM",
//            "endtime1": "15",
//            "streetaddress": "mammillapalli ",
//            "photo": "EVeTrnEETimage.jpg",
//            "membercount": "0",
//            "city": "mammillapalli ",
//            "state": "Andhra Pradesh",
//            "zipcode": "523303",
//            "country": "India",
//            "latitude": "16.0177358",
//            "longitude": "79.9157721",
//            "hostname": "ph coho",
//            "contactinfo": "4468888",
//            "hosttype": "Public",
//            "dat": "2021-06-04 09:32:34",
//            "event_description": " Oh oh ",
//            "status": "1"
//        },
//        {
//            "id": "657",
//            "userid": "4",
//            "typ": "Public",
//            "event_name": "ghhhh",
//            "shortd": "",
//            "distance_km": "0",
//            "distance_miles": "0",
//            "category": "People - Retention - Community Relations (COMREL),Readiness - Individual & Collective Training,Readiness - Equipping & Fielding",
//            "startdate": "06-04-2021",
//            "startdate1": "2021-06-04",
//            "starttime": "10:00 AM",
//            "starttime1": "10",
//            "enddate": "06-08-2021",
//            "enddate1": "2021-06-08",
//            "endtime": "11:00 PM",
//            "endtime1": "23",
//            "streetaddress": "mammillapalli",
//            "photo": "",
//            "membercount": "0",
//            "city": "mammillapalli",
//            "state": "Andhra Pradesh",
//            "zipcode": "523303",
//            "country": "india",
//            "latitude": "16.0177358",
//            "longitude": "79.9157721",
//            "hostname": "Harvinder",
//            "contactinfo": "7307151068",
//            "hosttype": "Public",
//            "dat": "2021-06-04 09:30:20",
//            "event_description": "",
//            "status": "1"
//        },
//        {
//            "id": "658",
//            "userid": "4",
//            "typ": "Public",
//            "event_name": "ghhhh",
//            "shortd": "",
//            "distance_km": "0",
//            "distance_miles": "0",
//            "category": "People - Retention - Community Relations (COMREL),Readiness - Individual & Collective Training,Readiness - Equipping & Fielding",
//            "startdate": "06-04-2021",
//            "startdate1": "2021-06-04",
//            "starttime": "10:00 AM",
//            "starttime1": "10",
//            "enddate": "06-08-2021",
//            "enddate1": "2021-06-08",
//            "endtime": "11:00 PM",
//            "endtime1": "23",
//            "streetaddress": "mammillapalli",
//            "photo": "",
//            "membercount": "0",
//            "city": "mammillapalli",
//            "state": "Andhra Pradesh",
//            "zipcode": "523303",
//            "country": "india",
//            "latitude": "16.0177358",
//            "longitude": "79.9157721",
//            "hostname": "Harvinder",
//            "contactinfo": "7307151068",
//            "hosttype": "Public",
//            "dat": "2021-06-04 09:30:36",
//            "event_description": "",
//            "status": "1"
//        },
//        {
//            "id": "654",
//            "userid": "16",
//            "typ": "Public",
//            "event_name": "Chandigarh Party",
//            "shortd": "test",
//            "distance_km": "0",
//            "distance_miles": "0",
//            "category": "People - Health & Wellness,Modernization - Information Operations - Cyber",
//            "startdate": "06-03-2021",
//            "startdate1": "2021-06-03",
//            "starttime": "04:11 PM",
//            "starttime1": "16",
//            "enddate": "06-23-2021",
//            "enddate1": "2021-06-23",
//            "endtime": "09:11 PM",
//            "endtime1": "21",
//            "streetaddress": "sector 17 ",
//            "photo": "",
//            "membercount": "1",
//            "city": "Chandigarh ",
//            "state": "Punjab",
//            "zipcode": "160017",
//            "country": "India",
//            "latitude": "30.7387558",
//            "longitude": "76.7807517",
//            "hostname": "Harvinder Singh",
//            "contactinfo": "8360757603",
//            "hosttype": "Public",
//            "dat": "2021-06-03 11:02:40",
//            "event_description": "",
//            "status": "1"
//        },
//        {
//            "id": "652",
//            "userid": "13",
//            "typ": "Public",
//            "event_name": "Birthday party",
//            "shortd": "",
//            "distance_km": "3632",
//            "distance_miles": "2257",
//            "category": "People - Health & Wellness",
//            "startdate": "06-03-2021",
//            "startdate1": "2021-06-03",
//            "starttime": "06:04 PM",
//            "starttime1": "18",
//            "enddate": "06-05-2021",
//            "enddate1": "2021-06-05",
//            "endtime": "06:04 PM",
//            "endtime1": "18",
//            "streetaddress": "1120 roosevelt ave",
//            "photo": "ETETEVrenimage.jpg",
//            "membercount": "0",
//            "city": "Redwood City ",
//            "state": "California",
//            "zipcode": "94063",
//            "country": "United States",
//            "latitude": "37.4720528",
//            "longitude": "-122.2355202",
//            "hostname": "MD",
//            "contactinfo": "manjeets",
//            "hosttype": "Public",
//            "dat": "2021-06-03 12:37:17",
//            "event_description": "This is test",
//            "status": "1"
//        },
//        {
//            "id": "635",
//            "userid": "13",
//            "typ": "Public",
//            "event_name": "ACFT TEST FIELDING",
//            "shortd": "",
//            "distance_km": "3644",
//            "distance_miles": "2265",
//            "category": "People - Health & Wellness,Readiness - Equipping & Fielding,Readiness - Individual & Collective Training",
//            "startdate": "05-28-2021",
//            "startdate1": "2021-05-28",
//            "starttime": "06:00 AM",
//            "starttime1": "6",
//            "enddate": "06-30-2021",
//            "enddate1": "2021-06-30",
//            "endtime": "06:00 PM",
//            "endtime1": "18",
//            "streetaddress": "230 R T Jones RD",
//            "photo": "",
//            "membercount": "1",
//            "city": "MTN View",
//            "state": "California",
//            "zipcode": "94043",
//            "country": "United States",
//            "latitude": "37.418871",
//            "longitude": "-122.0800265",
//            "hostname": "MAJ Brooks",
//            "contactinfo": "650-526-6055",
//            "hosttype": "Public",
//            "dat": "2021-05-28 14:07:58",
//            "event_description": "Test for App",
//            "status": "1"
//        },
//        {
//            "id": "648",
//            "userid": "13",
//            "typ": "Public",
//            "event_name": "81RD ACFT Event",
//            "shortd": "ACFT Demo",
//            "distance_km": "3631",
//            "distance_miles": "2256",
//            "category": "People - Health & Wellness,Modernization - Information Operations - Cyber,Readiness - Mobilization & Power Projection,Readiness - Equipping & Fielding,Readiness - Individual & Collective Training,Peop",
//            "startdate": "06-15-2021",
//            "startdate1": "2021-06-15",
//            "starttime": "06:00 AM",
//            "starttime1": "6",
//            "enddate": "06-30-2021",
//            "enddate1": "2021-06-30",
//            "endtime": "04:00 PM",
//            "endtime1": "16",
//            "streetaddress": "1240 Saratoga Ave",
//            "photo": "",
//            "membercount": "1",
//            "city": "Palo Alto",
//            "state": "California",
//            "zipcode": "94303",
//            "country": "United States",
//            "latitude": "37.4733",
//            "longitude": "-122.1531",
//            "hostname": "Antoine P Brooks",
//            "contactinfo": "650-526-6055",
//            "hosttype": "Public",
//            "dat": "2021-06-01 22:57:47",
//            "event_description": "",
//            "status": "1"
//        }
//    ],
//    "status": "1",
//    "message": "Done"
//}
