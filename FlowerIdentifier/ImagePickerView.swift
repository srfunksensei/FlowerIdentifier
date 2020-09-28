//
//  ImagePickerView.swift
//  FlowerIdentifier
//
//  Created by MB on 28/09/2020.
//  Copyright © 2020 MB. All rights reserved.
//

import Foundation
import SwiftUI

struct ImagePickerView: UIViewControllerRepresentable {

    typealias UIViewControllerType = UIImagePickerController
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        let parent: ImagePickerView
        init(parent: ImagePickerView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImageFromPicker = info[.originalImage] as? UIImage {
                self.parent.selectedImage = selectedImageFromPicker
            }
            self.parent.isShown = false
        }
    }
    
    @Binding var isShown: Bool
    @Binding var selectedImage: UIImage
    
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    func makeCoordinator() -> ImagePickerView.Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
}


