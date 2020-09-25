//
//  ContentView.swift
//  FlowerIdentifier
//
//  Created by MB on 24/09/2020.
//  Copyright © 2020 MB. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                Image("placeholder")
                    .resizable()
                    .frame(width: 300, height: 300, alignment: .center)
                
                Button("Choose picture") {
                    self.showSheet = true
                }.padding()
                    .background(Color.green)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
                    .actionSheet(isPresented: $showSheet) {
                        ActionSheet(title: Text("Select photo"), message: nil, buttons: [
                            .default(Text("Photo library")) {
                                
                            },
                            .default(Text("Camera")) {
                                
                            },
                            .cancel()
                        ])
                }
            }
        }
        .navigationBarTitle("Identify Flower")
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
