//
//  HistoryView.swift
//  DiceRoll
//
//  Created by Anmol  Jandaur on 1/20/21.
//

import SwiftUI

struct HistoryView: View {
    
    
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(entity: Result.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Result.totalResult, ascending: false)]) var results: FetchedResults<Result>
    
    @FetchRequest(entity: CoreDataRoll.entity(), sortDescriptors: []) var dices: FetchedResults<Result>
    
    //  Use onDelete(perform:) modifier to ForEach, but rather than just removing items from an array we instead need to find the requested object in our fetch request then use it to call delete() on our managed object context.
    func deleteRolls(at offsets: IndexSet) {
        for offset in offsets {
            // find the roll in fetch request
            let result = results[offset]
        
                // delete it from the context
                moc.delete(result)
                
                // save! 
                do {
                    try moc.save()
                } catch {
                    print("error with save after delete")
                }
   
            
        }
    }
    
    
    func findDiceIndex(at result: Result) -> Int {
        guard let index = results.firstIndex(of: result) else {
            return 0 }
        return index
    }
    
    @State private var countOfDie = 1
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(results, id: \.wrappedId)  { result in
                        HStack {
                            HStack {
                                ForEach(result.diceArray, id: \.totalSum) { newDie in
                                    DieView(die: newDie.wrappedTotalSum, width: 54, height: 54, cornerRadius: 4, backgroundColor: .green)
                                }
                            }
                            Spacer()
                            
                            VStack(alignment: .leading) {
                                Text("Results: \(result.wrappedTotalResult)")
                                    .font(Font.system(size: CGFloat(16), weight: .heavy, design: .default))
                                    .foregroundColor(Color.red)
                                
                                Text("Date: \(result.wrappedDate)")
                                    .font(Font.system(size: CGFloat(16), weight: .heavy, design: .default))
                                    .foregroundColor(Color.purple)
                                
                                Text("Time: \(result.wrappedTime)")
                                    .font(Font.system(size: CGFloat(16), weight: .heavy, design: .default))
                                    .foregroundColor(Color.primary)
                            }
                            
                        }
                        
                    }
                    
                    .onDelete(perform: deleteRolls)
                    
                }
                
            }
            
            .navigationBarTitle(Text("Die Roll Results"))
            .navigationBarItems(trailing: EditButton())
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
    
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
