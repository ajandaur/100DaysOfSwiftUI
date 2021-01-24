//
//  HistoryView.swift
//  DiceRoll
//
//  Created by Anmol  Jandaur on 1/20/21.
//

import SwiftUI

struct HistoryView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(entity: CoreDataRoll.entity(), sortDescriptors: []) var rolls: FetchedResults<CoreDataRoll>
    
    
    var body: some View {

        VStack {
            List {
                    ForEach(rolls, id: \.self)  { roll in
                        Text("\(roll.date!)")
                    }
                
            }
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
