//
//  LocationRoute.swift
//  BaseProject
//
//  Created by Damandeep Kaur on 10/11/17.
//  Copyright © 2017 Singh Arshdeep. All rights reserved.
//

import UIKit

class LocationRoute: NSObject {

    // Used in get route api only
    var source:LocationModel?
    var destination: LocationModel?
    
    var summary: String?
    var distance: Int?
    var duration: Int?
    var polyLinePoints: String?
    var distanceStr: String{
        let kms = Int((distance ?? 0)/1000)
        return kms > 0 ?  "\(kms) KMS" : "\((distance ?? 0)) M"
    }
    var durationStr: String{
        
        func secondsToHoursMinutesSeconds (_ seconds : Int) -> (Int, Int, Int) {
            return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
        }
        let (h,m,_ ) = secondsToHoursMinutesSeconds(duration ?? 0)
        //4 hours 16 mins
        let hourSuffix = h > 1 ? "hours" : "hour"
        let minsSuffix = m > 1 ? "mins" : "min"
        if h > 0 && m > 0{
            return "\(h) \(hourSuffix) \(m) \(minsSuffix)"
        }
        else if h > 0{
            return "\(h) \(hourSuffix)"
        }
        else if m > 0{
            return "\(m) \(minsSuffix)"
        }
        return ""
    }
    
    init(source:LocationModel? = nil, destination:LocationModel? = nil, summary:String? = "", distance:Int? = 0, duration:Int? = 0, polyLinePoints:String? = "") {
        self.source = source
        self.destination = destination
        self.summary = summary
        self.distance = distance
        self.duration = duration
        self.polyLinePoints = polyLinePoints
    }
}
