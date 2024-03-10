//
//  PrayerTimeModel.swift
//  AdhanNow
//
//  Created by M Yogi Satriawan on 10/03/24.
//

import Foundation

struct PrayerTime: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let time: String
}


struct PrayerTimesResponse: Decodable {
    let data: TimingsData
}

struct TimingsData: Decodable {
    let timings: [String: String]
}
