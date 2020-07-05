//
//  ContentView.swift
//  BetterRest-26th-DaySwift
//
//  Created by Jhon Khan on 04/07/2020.
//

import SwiftUI

struct ContentView: View {
    @State private var sleepAmount = 8.0
    @State private var wakeUp     = defaultWakeTime
    @State private var coffeeAmount = 0
    
    
    var body: some View {
        
        NavigationView {
            
            Form {
                
                Section(header:Text("When to do you want to wake up?")) {
                    DatePicker("Select Date", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                
                Section(header:  Text("Desired Amount of Sleep?")) {
                    Picker(coffeeAmount == 0 ? "1 cup" : "\(coffeeAmount) cups", selection: $coffeeAmount) {
                        ForEach(1..<21) {number in
                           Text("\(number) cups")
                        }
                    }
                }
                
                Section(header:  Text("Desired Amount of Sleep?")) {
                    Stepper(value: $sleepAmount, in: 4...12,step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                        
                    }
                }
                
                Section(header: Text("Your Idea bed Time:")) {
                    Text("\(calculatSleep)")
                        .font(.largeTitle)
                }
            }
            .navigationTitle("Better Rest")
        }
    }
    
    
     var calculatSleep : String {
        
        let model = SleepCalculator()
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        var msg    = ""
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            msg = formatter.string(from: sleepTime)
            
        } catch {
            msg = "Sorry, there was a problem calculating your bedtime."
        }
        return msg
    }
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
