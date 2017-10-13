//
//  Helpers.swift
//  instacarro
//
//  Created by Eury Perez Beltre on 12/21/16.
//  Copyright © 2016 Eury Perez Beltre. All rights reserved.
//

import UIKit

func calculateDistance(lat1:Float?, lon1:Float?,lat2:Float?,lon2:Float?, unit:MeasurementUnit) -> Double{
    let theta = lon1! - lon2!
    var dist = sin(deg2rad(deg: lat1)) * sin(deg2rad(deg: lat2)) + cos(deg2rad(deg: lat1)) * cos(deg2rad(deg: lat2)) * cos(deg2rad(deg: theta))
    dist = acos(dist)
    dist = rad2deg(rad: Float(dist))
    dist = dist * 60 * 1.1515
    switch unit {
    case .Km:
        dist = dist * 1.609344;
        break
    case .N:
        dist = dist * 0.8684;
        break
    }
    return dist
}

/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*::  This function converts decimal degrees to radians             :*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
func deg2rad(deg:Float?) -> Double{
    return (Double(deg!) * Double.pi / 180.0)
}

/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*::  This function converts radians to decimal degrees             :*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
func rad2deg(rad:Float?) -> Double{
    return (Double(rad!) * 180.0 / Double.pi)
}

enum MeasurementUnit {
    case Km
    case N
}

struct URLs {
    
    static let register = "\(Constants.BASE_URL)\(Constants.SELLERS_PREFIX)/register"
    
    static func slots(slug: String, venueId:String, startDate:Date, endDate:Date) -> String{
        return "\(Constants.BASE_URL)\(Constants.SELLERS_PREFIX)/venues/\(venueId)/slots?startDate=\(startDate.format(format: Date.Format.slots))&endDate=\(endDate.format(format: Date.Format.slots))&slug=\(slug)"
    }
    
    static func inspectionComment(vehicleId:String, questionId:String) -> String{
        return "\(Constants.BASE_URL)/mechanics/vehicleSellRequests/\(vehicleId)/inspection/answers/\(questionId)/upsert-comment"
    }
}
