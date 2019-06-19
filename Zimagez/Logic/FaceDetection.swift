//
//  FaceDetection.swift
//  Zimagez
//
//  Created by Bathilde Rocchia on 18/06/2019.
//  Copyright © 2019 Bathilde Rocchia. All rights reserved.
//

import Foundation
import Vision
import UIKit

class FaceDetection {

    func startDetecting(image: UIImage, _ completion: @escaping ([(Float, CGRect)]) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            let faceDetectionRequest = VNDetectFaceRectanglesRequest(completionHandler: { (request, error) in

                if error != nil {
                    print("FaceDetection error: \(String(describing: error)).")
                }

                guard let faceDetectionRequest = request as? VNDetectFaceRectanglesRequest,
                    let results = faceDetectionRequest.results as? [VNFaceObservation] else {
                        return
                }
                DispatchQueue.main.async {
                    completion(results.compactMap( { ($0.confidence, $0.boundingBox) } ))
                }
            })

            let imageRequestHandler = VNImageRequestHandler(cgImage: image.cgImage!,
                                                            options: [:])

            do {
                try imageRequestHandler.perform([faceDetectionRequest])
            } catch let error as NSError {
                NSLog("Failed to perform FaceRectangleRequest: %@", error)
            }
        }
    }

}
