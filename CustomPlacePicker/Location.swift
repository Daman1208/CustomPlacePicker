//
//  Location.swift
//  BaseProject
//
//  Created by Damandeep Kaur on 10/11/17.
//  Copyright © 2017 Singh Arshdeep. All rights reserved.
//

import UIKit

class LocationModel: NSObject {

    var searchText          :   String?
    var placeId             :   String?
    var address             :   String?
    var vicinity            :   String?
    var icon                :   String?
    var latitude            :   Double?
    var longitude           :   Double?
    var name                :   String?
    var temperatureHigh     :   Double?
    var temperatureLow      :   Double?
    var time                :   Double?
    var date: Date?
    var placeType           :   String?

    init(searchText:String? = "", placeId: String? = "", name: String? = "", address:String? = "", vicinity:String? = "", icon: String? = "", placeType: String? = "", latitude:Double? = 0, longitude:Double? = 0, temperatureHigh:Double? = 0, temperatureLow:Double? = 0, time:Double? = 0, date: Any? = nil) {
        
        self.searchText         =       searchText
        self.address            =       address
        self.vicinity           =       vicinity
        self.latitude           =       latitude
        self.longitude          =       longitude
        self.name               =       name
        self.temperatureHigh    =       temperatureHigh
        self.temperatureLow     =       temperatureLow
        self.time               =       time
        self.placeId            =       placeId
        self.icon               =       icon
        self.placeType          =       placeType
    }
    
}
