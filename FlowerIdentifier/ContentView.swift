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
    @State private var isShowingImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var image: UIImage = UIImage(named: "placeholder")!
    
    var body: some View {
        NavigationView {
            VStack {
                Image(uiImage: image)
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
                                self.isShowingImagePicker = true
                                self.sourceType = .photoLibrary
                            },
                            .default(Text("Camera")) {
                                self.isShowingImagePicker = true
                                self.sourceType = .camera
                            },
                            .cancel()
                        ])
                }
            }
            .navigationBarTitle("Identify Flower")
        }
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePickerView(isShown: self.$isShowingImagePicker, selectedImage: self.$image)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
