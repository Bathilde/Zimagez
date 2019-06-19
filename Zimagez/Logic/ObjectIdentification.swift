//
//  ObjectDetection.swift
//  Zimagez
//
//  Created by Bathilde Rocchia on 18/06/2019.
//  Copyright © 2019 Bathilde Rocchia. All rights reserved.
//

import Foundation
import Vision
import UIKit

class ObjectIdentification {

    func startDetecting(image: UIImage, _ completion: @escaping ([(Float, String)]) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            guard let model = try? VNCoreMLModel(for: MobileNetV2Int8LUT().model) else {
                fatalError("can't load MobileNet ML model")
            }
            
            let objectIdentificationRequest = VNCoreMLRequest(model: model) { (request, error) in
                
                if error != nil {
                    print("CoreML error: \(String(describing: error)).")
                }
                
                guard let imageRequest = request as? VNImageBasedRequest,
                    let results = imageRequest.results as? [VNClassificationObservation] else { return }
                DispatchQueue.main.async {
                    completion(results.filter { $0.confidence > 0.1 }.map { ($0.confidence, $0.identifier) })
                }
            }
            
            let imageRequestHandler = VNImageRequestHandler(cgImage: image.cgImage!,
                                                            options: [:])
            
            do {
                try imageRequestHandler.perform([objectIdentificationRequest])
            } catch let error as NSError {
                NSLog("Failed to perform FaceRectangleRequest: %@", error)
            }
        }
    }

}
