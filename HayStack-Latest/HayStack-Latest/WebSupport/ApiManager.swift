//
//  ApiManager.swift
//  HayStack-Latest
//
//  Created by rajesh gandru on 15/12/22.
//

import Foundation
import CoreLocation
import GoogleMaps
import Alamofire
import ObjectMapper
import UIKit

enum DataNotFound:Error {
    case dataNotFound
}

typealias successs = (Data)-> Void
typealias failure = (Any)-> Void
typealias Response = [String:Any]
var AccessToken = String()


func header()->HTTPHeaders{
    let bearerToken = UserDefaults.standard.string(forKey:"Accesstoken") ?? ""
    var headerMessage :HTTPHeaders!
    if bearerToken != ""{
        headerMessage = [
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization":"Bearer \(bearerToken)"]
        
    }else{
        headerMessage = [
            "Content-Type":"application/x-www-form-urlencoded","Accept":"application/json" ]
    }
    return headerMessage
}

class NetworkManager{
    var alamoFireManager : SessionManager?
    private init(){}
    
    static  var alamoFireManager : SessionManager?
    
    
    
    static func Apicalling<T:Mappable>(
        url:String,
        paramaters:Response = [:],
        httpMethodType:HTTPMethod = .post ,
        success:@escaping(T)-> () ,
        failure: @escaping failure)
    {
        if Connectivity.isNotConnectedToInternet{
            failure("No Internet,Please Check")
        }
        guard let httpMethod = HTTPMethod(rawValue: httpMethodType.rawValue) else{
            assertionFailure("OOPS !!! HTTP Method Not Found \(httpMethodType)")
            return
        }
        print(" ---------- T ** Model  ---------- \n ","\(T.self)")
        print(" ---------- HTTP Method  ---------- \n",httpMethod)
        print(" ----------  URL  ---------- \n",url)
        print(" ---------- parameters  ---------- \n",paramaters)
        print(" ---------- Header  ---------- \n",header())
        
        let configuration = URLSessionConfiguration.default
        alamoFireManager = Alamofire.SessionManager(configuration: configuration)
        alamoFireManager?.request(url, method: httpMethod, parameters: paramaters, encoding:  URLEncoding.default, headers: header()).responseJSON { (response) in
            print(response.response?.statusCode as Any)
            switch response.result{
            case .success(let value):
                guard let responseDict = value as? Response else{return}
                print(" ---------- responseDict  ---------- \n",responseDict)
                guard let item = Mapper<T>.init().map(JSON: responseDict) else{
                    if let error = response.result.error{
                        failure(error)
                    }
                    return
                }
                print(" ---------- MODEL  ---------- \n",item)
                guard let statusCode = response.response?.statusCode,statusCode == 200 else{
                    if let errorMessage = responseDict["message"] as? String{
                        failure(errorMessage)
                    }
                    return
                }
                success(item)
            case .failure(let error):
                failure(error)
            }
        }.session.finishTasksAndInvalidate()
    }
    
    
}
class NetworkManager2{
    var alamoFireManager : SessionManager?
    private init(){}
    
    static  var alamoFireManager : SessionManager?
    
    
    
    static func Apicalling<T:Mappable>(
        url:String,
        paramaters:Response = [:],
        ImageData:UIImage?,
        imagetype:String,
        httpMethodType:HTTPMethod = .post ,
        success:@escaping(T)-> () ,
        failure: @escaping failure)
    {
        if Connectivity.isNotConnectedToInternet{
            failure("No Internet,Please Check")
        }
        guard let httpMethod = HTTPMethod(rawValue: httpMethodType.rawValue) else{
            assertionFailure("OOPS !!! HTTP Method Not Found \(httpMethodType)")
            return
        }
        print(" ---------- T ** Model  ---------- \n ","\(T.self)")
        print(" ---------- HTTP Method  ---------- \n",httpMethod)
        print(" ----------  URL  ---------- \n",url)
        print(" ---------- parameters  ---------- \n",paramaters)
        print(" ---------- Header  ---------- \n",header())
        
        let configuration = URLSessionConfiguration.default
        alamoFireManager = Alamofire.SessionManager(configuration: configuration)
        alamoFireManager?.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in paramaters {
                if let temp = value as? String {
                    multipartFormData.append(temp.data(using: .utf8)!, withName: key )
                }
                if let temp = value as? Int {
                    multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key )
                }
                if let temp = value as? NSArray {
                    temp.forEach({ element in
                        let keyObj = key + "[]"
                        if let string = element as? String {
                            multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
                        } else
                        if let num = element as? Int {
                            let value = "\(num)"
                            multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
                        }
                    })
                }
            }
            
//            for (key, value) in paramaters {
//                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
//            }
            if let imagePic = ImageData {
                if let datar = imagePic.jpegData(compressionQuality: 0.5)  {
                    multipartFormData.append(datar, withName: "image", fileName: "image.jpg", mimeType: "image/jpg")
                }
            }
            
//            if let data = ImageData {
//                //multipartFormData.append(data, withName: "image", fileName: "image.\(imagetype)", mimeType: "image/\(imagetype)")
//                multipartFormData.append(data, withName: "image",fileName: "createEvent", mimeType: "image/jpeg")
//            }
            
        }, usingThreshold: UInt64.init(), to: url, method: .post) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Succesfully uploaded  = \(response)")
                    if let err = response.error{
                        print(err)
                        failure(err)
                        
                    }
                    
                    
                    guard let responseDict = response.value as? Response else{return}
                    print(" ---------- responseDict  ---------- \n",responseDict)
                    guard let item = Mapper<T>.init().map(JSON: responseDict) else{
                        if let error = response.result.error{
                            failure(error)
                        }
                        return
                    }
                    print(" ---------- MODEL  ---------- \n",item)
                    guard let statusCode = response.response?.statusCode,statusCode == 200 else{
                        if let errorMessage = responseDict["message"] as? String{
                            failure(errorMessage)
                        }
                        return
                    }
                    success(item)
                    
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                failure(error)
            }
        }
    }
}


