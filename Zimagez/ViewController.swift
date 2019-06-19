//
//  ViewController.swift
//  Zimagez
//
//  Created by Bathilde Rocchia on 18/06/2019.
//  Copyright © 2019 Bathilde Rocchia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var picture: UIImageView!

    @IBOutlet weak var resultLabel: UILabel!

    let errorMissingPictureMsg = "This is not the picture you are looking for. Please pick a picture first"
    let errorMissingFaces = "Where are you? The picture is missing human face"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func didTouchPickImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        imagePicker.delegate = self

        self.present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func didTouchCoreML(_ sender: Any) {
        guard let image = picture.image else {
            resultLabel.text = errorMissingPictureMsg
            return
        }

        ObjectIdentification().startDetecting(image: image) { (results) in
            self.resultLabel.text = results.map { "\($0.0) recognized: \($0.1)" }.joined(separator: "\n")
        }
    }

    @IBAction func didTouchObservation(_ sender: Any) {
        guard let image = picture.image else {
            resultLabel.text = errorMissingPictureMsg
            return
        }
        FaceDetection().startDetecting(image: image) { (results) in
            self.resultLabel.text = results.isEmpty ? self.errorMissingFaces : results.map { "\($0.0) square: \($0.1)" }.joined(separator: "\n")
        }
    }

}

extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.picture.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
