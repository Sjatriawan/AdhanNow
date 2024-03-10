//
//  PrayerTimeView.swift
//  AdhanNow
//
//  Created by M Yogi Satriawan on 10/03/24.
//

import SwiftUI


struct PrayerTimeView: View {
    @StateObject private var viewModel = PrayerTimeViewModel()
    @State private var selectedPrayerTime: PrayerTime?
    
    
    var body: some View {
        ZStack{
                VStack {
                    HStack{
                        TextField("Masukkan nama kota", text: $viewModel.cityName)
                            .padding()
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        Button("Cari") {
                            viewModel.fetchPrayerTimes()
                        }
                        .padding()
                    }
                    
                    if let selectedPrayerTime = selectedPrayerTime {
                        HStack{
                            Text(selectedPrayerTime.name)
                                .font(.system(size: 50))
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                            Button(action: {}, label: {
                                Image(systemName: "bell.and.waves.left.and.right.fill")
                            })
                        }
                        
                                       Text(selectedPrayerTime.time)
                                           .font(.system(size: 150))
                                           .foregroundColor(.white)
                                           .multilineTextAlignment(.center)
                                           .fontWeight(.bold)
                                      
                                   } else {
                                       Text(nearestPrayerTime())
                                           .font(.system(size: 24))
                                           .foregroundColor(.white)
                                   }
                   
            
                    Text("Dosaku sangat membebaniku. Tetapi ketika aku mengukurnya dengan rahmat-Mu, Ya Allah, ampunan-Mu lebih besar. \n-Imam Syafii")
                        .font(.system(size: 30, design: .serif))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .font(.title)
                        .italic()
                 
                    Spacer().frame(height: 100)
                    HStack {
                        ForEach(viewModel.prayerTimes.sorted { $0.time < $1.time }, id: \.name) { prayerTime in
                            PrayerTimeRow(prayerTime: prayerTime, isSelected: selectedPrayerTime == prayerTime)
                                .onTapGesture {
                                    selectedPrayerTime = prayerTime
                                }
                        }
                    }
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
                   
            
        }.background(backgroundImage.blur(radius: 20)).ignoresSafeArea()
        
    }
    
    private func nearestPrayerTime() -> String {
          guard let currentTime = Calendar.current.dateComponents([.hour, .minute], from: Date()).date else {
              return "Waktu tidak ditemukan"
          }
          
          // Sort prayer times by closest to current time
          let sortedPrayerTimes = viewModel.prayerTimes.sorted {
              let time1 = $0.time.components(separatedBy: ":").compactMap { Int($0) }
              let time2 = $1.time.components(separatedBy: ":").compactMap { Int($0) }
              let date1 = Calendar.current.date(bySettingHour: time1[0], minute: time1[1], second: 0, of: currentTime)!
              let date2 = Calendar.current.date(bySettingHour: time2[0], minute: time2[1], second: 0, of: currentTime)!
              return abs(date1.timeIntervalSince(currentTime)) < abs(date2.timeIntervalSince(currentTime))
          }
          
          return sortedPrayerTimes.first?.name ?? "Waktu tidak ditemukan"
      }
    
    private var backgroundImage: Image {
        if let selectedPrayerTime = selectedPrayerTime {
        
            switch selectedPrayerTime.name {
            case "Fajr":
                return Image("fajr")
            case "Dhuhr":
                return Image("dhuhr")
            case "Asr":
                return Image("asr")
            case "Maghrib":
                return Image("maghrib")
            case "Isha":
                return Image("isha")
            default:
                return Image("defaultBackground")
            }
        } else {
            return Image("defaultBackground")
        }
    }
}
#Preview {
    PrayerTimeView()
}
