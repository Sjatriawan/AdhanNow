//
//  CardView.swift
//  AdhanNow
//
//  Created by M Yogi Satriawan on 10/03/24.
//

import SwiftUI


struct PrayerTimeRow: View {
    let prayerTime: PrayerTime
    let isSelected: Bool
    
    var body: some View {
        HStack {
            HStack(spacing: 10) {
                HStack{
                    Text(prayerTime.name)
                        .font(.headline)
                    Spacer()
                      Text(prayerTime.time)
                          .font(.subheadline)
                    
                }
               
            }
            .frame(width: 130, alignment: .leading)
            .padding()
            .background(isSelected ? Color.green.opacity(0.5) : Color.gray.opacity(0.5))
            .cornerRadius(10)
    
        }
    }
}

