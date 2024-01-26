//
//  ContentView.swift
//  mobile
//
//  Created by riat felix on 11/12/2023.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isFirstConnection") var isNotFirstConnection = false
    @State var checkFirstConenction: Bool = false
    
    var body: some View {
        VStack {
            if checkFirstConenction {
                MapView()
            } else {
                NewUserView()
            }
        }
        .onAppear {
            checkFirstConenction = isNotFirstConnection
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
