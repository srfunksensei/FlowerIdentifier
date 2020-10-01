//
//  ContentView.swift
//  FlowerIdentifier
//
//  Created by MB on 24/09/2020.
//  Copyright © 2020 MB. All rights reserved.
//

import SwiftUI
import Vision

struct ContentView: View {
    
    @State private var title: String = "Identify Flower"
    @State private var isSheetShown = false
    @State private var isShowingImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var image: UIImage = UIImage(named: "placeholder")!
    
    var body: some View {
        NavigationView {
            VStack {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 300, height: 300, alignment: .center)
                
                Button("Choose picture") {
                    self.isSheetShown = true
                }.padding()
                    .background(Color.green)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
                    .actionSheet(isPresented: $isSheetShown) {
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
            .navigationBarTitle(title)
        }
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePickerView(isShown: self.$isShowingImagePicker, selectedImage: self.$image, sourceType: self.sourceType)
                .onDisappear { self.detectFlower(from: self.image) }
        }
    }
    
    fileprivate func detectFlower(from image: UIImage) {
        guard let ciImage = CIImage(image: image) else {
            fatalError("Cannot convert to ciImage")
        }
        
        guard let model = try? VNCoreMLModel(for: FlowerClassifier().model) else {
            fatalError("Cannot import model")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let result = request.results?.first as? VNClassificationObservation else {
                fatalError("Could not complete classfication")
            }
            
            self.title = result.identifier.capitalized
        }
        
        let handler = VNImageRequestHandler(ciImage: ciImage)
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
