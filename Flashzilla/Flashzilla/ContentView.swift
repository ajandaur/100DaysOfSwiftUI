//
//  ContentView.swift
//  Flashzilla
//
//  Created by Anmol  Jandaur on 1/12/21.
//

import SwiftUI
import Foundation
import CoreHaptics

struct ContentView: View {
    
    // enum because you can only have one sheet per view
    enum ActiveSheet {
        case editCard, settings
    }

    // MARK: Challenge 2 - retryCards property
    @State private var retryCards = false
    
    // MARK: Challenge 2 - property to show activeSheet
    @State private var activeSheet = ActiveSheet.editCard
    
    // mark the correct and incorrect cards
    @State private var numberOfCards = 0
    @State private var correctCards = 0
    @State private var incorrectCards = 0

    
    // instance of haptics engine
    @State private var engine: CHHapticEngine?
    
    // prepare the haptics
    func prepare() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            self.engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    // complex failure haptic for when the time runs out
    func complexFail() {
        // make sure that the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()

        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
            events.append(event)
        }

        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1 - i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1 - i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 1 + i)
            events.append(event)
        }

        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
        
        
    }
    
    // property to show editing screen
    @State private var showingSheet = false
    
    // MARK: Challenge 1 - Make something interesting for when the timer runs out. At the very least make some text appear, but you should also try designing a custom haptic using Core Haptics.
    private var timeRanOut: Bool {
        timeRemaining == 0
    }

    // create test array of stack of cards
    @State private var cards = [Card]()
    
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    
    @Environment(\.accessibilityEnabled) var accessibilityEnabled
    
    // the timer itself, which will fire once a second
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    // timeRemaining property, from which we’ll subtract 1 every time the timer fires.
    @State private var timeRemaining = 100
    
    
    // property to store whether the app is currently active
    @State private var isActive = true
    
    // takes an index in our cards array and removes that item
    // this connects to the closure on the CardView()
    func removeCard(at index: Int) {
        // add a guard check to the start of removeCard(at:) to make sure we don’t try to remove a card that doesn’t exist.
        guard index >= 0 else { return }
        
        cards.remove(at: index)
        
        if cards.isEmpty {
            isActive = false
        }
    }
    
    // Challenge 2: If setting permits, add the wrong card back in the deck
    func repeatCard(at index: Int) {
        guard index >= 0 else { return }
        
        let card = cards[index]
        cards.remove(at: index)
        cards.insert(card, at: 0)
    }
    
    // method to run to reset the app so the user can try again
    func resetCards() {
        timeRemaining = 100
        isActive = true
        loadData()
    }
    
    // load the cards on demand
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                self.cards = decoded
                
                // Challenge 1
                if cards.count == 1 {
                    self.prepare()
                }
            }
        }
    }
    
    var body: some View {
        
        ZStack {
            
            // Around that VStack will be another ZStack, so we can place our cards and timer on top of a background.
            // VoiceOver accessibility
            Image(decorative: "background")
                .resizable()
                .scaledToFit()
                .edgesIgnoringSafeArea(.all)
            
            
            VStack {
                
                // display timer
                Text(!timeRanOut ? "Time: \(timeRemaining)" : "Time has ran out!")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(
                        Capsule()
                            .fill(Color.black)
                            .opacity(0.75)
                    )
                ZStack {
                    // Our stack of cards will be placed inside a ZStack so we can make them partially overlap with a neat 3D effect.
                    
                    ForEach(0..<cards.count, id: \.self) { index in
                        CardView(card: self.cards[index]) {
                            withAnimation {
                                self.removeCard(at: index)
                            }
                        }
                        .stacked(at: index, in: self.cards.count)
                        .allowsHitTesting(index == self.cards.count - 1)
                        .accessibility(hidden: index < self.cards.count - 1)
                        
                       
                        }
                    
                    Spacer()
                    
                    // button to trigger resetCards
                    if cards.isEmpty {
                        Button("Start Again", action: resetCards)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.black)
                            .clipShape(Capsule())
                    }
                }
            }
            HStack {
                VStack {
                    Spacer()
                    
                    Button(action: {
                        self.showingSheet = true
                        self.activeSheet = .editCard
                    }) {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                    
                    Button(action: {
                        self.showingSheet = true
                        self.activeSheet = .settings
                    }) {
                        Image(systemName: "pencil.circle")
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                    
                   
                    
                }
                
                Spacer()
            }
            .foregroundColor(.white)
            .font(.largeTitle)
            .padding()
            
            if differentiateWithoutColor || accessibilityEnabled {
                VStack {
                    Spacer()
                    // replace the images with buttons that actually remove the cards
                    
                    HStack {
                        Button(action: {
                            withAnimation {
                                self.removeCard(at: self.cards.count - 1)
                            }
                        }) {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibility(label: Text("Wrong"))
                        .accessibility(hint: Text("Mark your answer as being incorrect."))
                        Spacer()
                        
                        Button(action: {
                            withAnimation {
                                self.removeCard(at: self.cards.count - 1)
                            }
                        }) {
                            Image(systemName: "check.mark.circle")
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibility(label: Text("Correct"))
                        .accessibility(hint: Text("Mark your answer as being correct."))
                        
                    }
                    
                    
                }
                
                .allowsHitTesting(timeRemaining > 0)
            
    
            }
        }
        
        // to show sheet on-demand and call resetCards() when dismissed
        .sheet(isPresented: $showingSheet, onDismiss: resetCards) {
            if self.activeSheet == .editCard {
                EditCard()
            }
            if self.activeSheet == .settings {
                SettingsView(retryCards: self.$retryCards)
            }
        }
        
        
        // call resetCards when ContentView appears
        .onAppear(perform: resetCards)
        
        // onRecieve modifier
        .onReceive(timer) { time in
            guard self.isActive else { return }
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
                
                // MARK: Challenge 1
                if self.timeRemaining == 5 {
                    // prepare haptics
                    self.prepare()
                    // else carry out the complex failure haptic
                } else if self.timeRemaining == 0 {
                    self.complexFail() // fail failure haptic
                }
            }
            
        }
        
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            self.isActive = false
        }
        
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            if self.cards.isEmpty == false {
                self.isActive = true
            }
        }
        
    }
}

extension View {
    //  stacked() modifier that takes a position in an array along with the total size of the array, and offsets a view by some amount based on those values.
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = CGFloat(total - position)
        return self.offset(CGSize(width: 0, height: offset * 10))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
