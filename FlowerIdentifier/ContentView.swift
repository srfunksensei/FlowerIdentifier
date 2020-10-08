//
//  ContentView.swift
//  FlowerIdentifier
//
//  Created by MB on 24/09/2020.
//  Copyright © 2020 MB. All rights reserved.
//

import SwiftUI
import Vision
import Alamofire
import SwiftyJSON

struct ContentView: View {
    
    fileprivate let wikipediaURl = "https://en.wikipedia.org/w/api.php"
    
    @State private var title: String = "Identify Flower"
    @State private var description: String = ""
    @State private var isSheetShown = false
    @State private var isShowingImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var image: UIImage = UIImage(named: "placeholder")!
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(showsIndicators: false) {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 300, height: 300, alignment: .center)
                    
                    Text(description)
                        .font(.body)
                        .padding()
                }
                
                ZStack(alignment: .bottom) {
                    Button(action: {
                        self.isSheetShown = true
                    }) {
                        HStack {
                            Image(systemName: "photo")
                            Text("Choose picture")
                                .font(.callout)
                                .fontWeight(.medium)
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(Color.white)
                    .cornerRadius(40)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
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
            
            self.requestInfo(flowerName: result.identifier)
        }
        
        let handler = VNImageRequestHandler(ciImage: ciImage)
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
    }
    
    fileprivate func requestInfo(flowerName: String) {
        let parameters : [String:String] = [
            "format" : "json",
            "action" : "query",
            "prop" : "extracts",
            "exintro" : "",
            "explaintext" : "",
            "titles" : flowerName,
            "redirects" : "1",
            "indexpageids" : ""
        ]
        
        Alamofire.request(wikipediaURl, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                let flowerJSON: JSON = JSON(response.result.value!)
                
                let pageid = flowerJSON["query"]["pageids"][0].stringValue
                let flowerDescription = flowerJSON["query"]["pages"][pageid]["extract"].stringValue
                
                self.title = flowerName.capitalized
                self.description = flowerDescription
            }
            else {
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
