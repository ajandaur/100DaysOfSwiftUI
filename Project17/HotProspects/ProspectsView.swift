//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Anmol  Jandaur on 1/11/21.
//

import SwiftUI
import CodeScanner
import UserNotifications

struct ProspectsView: View {
    
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    // to determine which tab we are one
    let filter: FilterType
    
    // property that finds the object, attaches it to a property, and keeps it up to date over time
    @EnvironmentObject var prospects: Prospects
    
    // property to show QRScanner
    @State private var isShowingScanner = false
    
    // MARK: Challenge 1 - Add an icon to the “Everyone” screen showing whether a prospect was contacted or not.
    
    let contactedIcon = "person.crop.circle.fill.badge.checkmark"
    let unContactedIcon = "person.crop.circle.badge.xmark"
    
    // MARK: Challenge 3 - action sheet properties and testData
    var testData: String {
        let sampleData = [
            "Paul Hudson\npaul@hackingwithswift.com",
            "Thomas Daly\ndaly@hackingwithswift.com",
            "Alex Anderson\nanderson@hackingwithswift.com",
            "Larry Sanchez\nsanchez@hackingwithswift.com"
        ]
        let randomIndex = Int.random(in: 0...3)
        return sampleData[randomIndex]
    }
    
    // property to show filters
    @State private var showingFilters = false
    
    
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted people"
        case .uncontacted:
            return "Uncontacted people"
        }
    }
    
    // computed property sends back a new array that are valid for the closure provided for each case
    var filteredProspects: [Prospect] {
        switch filter {
        case .none:
            return prospects.people
        case .contacted:
            return prospects.people.filter { $0.isContacted }
        case .uncontacted:
            return prospects.people.filter { !$0.isContacted}
        }
    }
    
    // imported package for CodeScannerView
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
       // the QR codes we’re generating are a name, then a line break, then an email address, so if our scanning result comes back successfully then we can pull apart the code string into those components and use them to create a new Prospect
        switch result {
        case .success(let code):
            let details = code.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]
            
            self.prospects.add(person)
            
        case .failure(let error):
            print("Scanning failed")
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 9
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            // test code
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        // use getNotificationSettings() and requestAuthorization() together, to make sure we only schedule notifications when allowed
        center.getNotificationSettings { setting in
            if setting.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("D'oh")
                    }
                }
            }
        }
    }
    
    var body: some View {
        NavigationView {
            // create a list to loop over teh array
            // show the title and email address of each prospect using a VStack
            List {
                ForEach(filteredProspects) { prospect in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(prospect.name)
                                .font(.headline)
                            Text(prospect.emailAddress)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            Image(systemName: prospect.isContacted ? self.contactedIcon : self.unContactedIcon)
                        }
                      
                    }
                    // add context menu using ternary operator when setting button's title
                    .contextMenu {
                        Button(prospect.isContacted ? "Mark Uncontacted" : "Mark Contacted") {
                            self.prospects.toggle(prospect)
                        }
                        if !prospect.isContacted {
                            Button("Remind Me") {
                                self.addNotification(for: prospect)
                            }
                        }
                        
                    }
                }
            }
                .navigationBarTitle(title)
            .navigationBarItems(leading: Button(action: {
                self.showingFilters = true
            }) {
                Image(systemName: "arrow.up.arrow.down.circle.fill")
                Text("Sort")
            },
                trailing: Button(action: {
                    self.isShowingScanner = true
                }) {
                    Image(systemName: "qrcode.viewfinder")
                    Text("Scan")
                })
            
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: testData, completion: self.handleScan)
            }
            
            // MARK: Challenge 3 - Use an action sheet to customize the way users are sorted in each screen – by name or by most recent.
            .actionSheet(isPresented: $showingFilters) {
                ActionSheet(title: Text("Sort Contacts By"), buttons: [.default(Text("Name"), action: {
                    self.prospects.sortUsername()
                }),
                .cancel()])
            }
            .animation(.easeOut)
        }
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
    }
}
