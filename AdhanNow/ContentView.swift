//
//  ContentView.swift
//  AdhanNow
//
//  Created by M Yogi Satriawan on 05/03/24.
//

import SwiftUI
import RealityKit
import RealityKitContent
import SwiftUI
import CoreLocation


struct ContentView:View {
    var body: some View {
        ScrollView{
            PrayerTimeView()
        }

    }
}


#Preview(windowStyle: .automatic) {
    ContentView()
}
