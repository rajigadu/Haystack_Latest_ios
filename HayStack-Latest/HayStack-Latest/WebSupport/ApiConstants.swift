//
//  ApiConstants.swift
//  HayStack-Latest
//
//  Created by rajesh gandru on 15/12/22.
//

import Foundation

let kApptitle = "HayStack"
class API_URl  {
    var Shared = API_URl()
    static let BaseUrl = "https://haystackevents.com/event-new/ios/"
    static let ImageBaseURL = "https://haystackevents.com/event-images/"
}

extension API_URl  {
     static let LogINURL = API_URl.BaseUrl + "login.php?"
     static let SignUPURL = API_URl.BaseUrl + "registration.php?"
//     static let SpouseSignUPURL = API_URl.BaseUrl + "spouse_registration.php?"
    
     static let ForGotPassWordURL = API_URl.BaseUrl + "forgotpassword.php?"
}

extension API_URl  {
    static let ChangePassWordURL = API_URl.BaseUrl + "changepassword.php?"
    static let ContactUsURL = API_URl.BaseUrl + "contact-us.php?"
    static let ReferFriendURL = API_URl.BaseUrl + "send-message.php?"
    
    static let UpdateProfileURL = API_URl.BaseUrl + "editprofile.php"
}

extension API_URl  {
    
    static let create_Group_URL = API_URl.BaseUrl + "creategroup.php"
    static let add_Member_To_Group_URL = API_URl.BaseUrl + "addmember.php"
     static let Get_Group_List_URL = API_URl.BaseUrl + "allgroups.php"
    
    static let Edit_Group_URL = API_URl.BaseUrl + "editgroup.php"
    static let Delete_the_GroupURL = API_URl.BaseUrl + "deletegroup.php"
    
    static let GetGroupMembersListURL = API_URl.BaseUrl + "group-members.php"
    
    static let EditGroupMembersListURL = API_URl.BaseUrl + "edit-group-member.php"
    static let deleteGroupMembersListURL = API_URl.BaseUrl + "delete-group-member.php"
   
}
extension API_URl  {
    
    static let getCategorysList_URL = API_URl.BaseUrl + "allcategory.php"
}


extension API_URl  {
    static let popularEvent_URL = API_URl.BaseUrl + "nearEventList.php"
    
    static let CreateNewEvent_URL = API_URl.BaseUrl + "create-event.php"
    
    static let UpdateEvent_URL = API_URl.BaseUrl + "editevent.php"
    
    static let Search_for_Event_URL = API_URl.BaseUrl + "search-events_new.php"
    //"search-test.php"
    //"search-events_new.php"
    
    static let NearByEventsURL = API_URl.BaseUrl + "near-events.php"
    static let DeleteAccountURL = API_URl.BaseUrl + "delete-account.php"
}
extension API_URl  {
    
    static let Get_CountryCode_URL = API_URl.BaseUrl + "country.php"
    
    static let Get_StateCode_URL = API_URl.BaseUrl + "state.php?"
}
extension API_URl  {
    static let myEvents_URL = API_URl.BaseUrl + "myevents.php"
    static let myInterest_URL = API_URl.BaseUrl + "myinterestevents.php"
    static let myAttend_URL = API_URl.BaseUrl + "myattendevents.php"
    static let myInvited_URL = API_URl.BaseUrl + "newmembersevents.php"
}
extension API_URl  {
    static let AttendedToEventURL = API_URl.BaseUrl + "attend_event.php"
    static let IntrestedToEventURL = API_URl.BaseUrl + "add_interest_event.php"
    
    static let DeleteEventURL = API_URl.BaseUrl + "deleteevent.php"
    static let DeleteAllEventURL = API_URl.BaseUrl + "deleteall.php"

 }

