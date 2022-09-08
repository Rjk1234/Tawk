//
//  Extensions.swift
//  TawkAssignment
//
//  Created by Rajveer Kaur on 05/09/22.
//

import Foundation
import UIKit


extension UIView{
    func MakeShadow(){
        self.backgroundColor = UIColor(named: "TawkColorCard")
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 4.0
    }
}

extension UIImageView {
    func inverseImage() {
        if let image = image {
            let coreImage = UIKit.CIImage(image: image)
            guard let filter = CIFilter(name: "CIColorInvert") else { return }
            filter.setValue(coreImage, forKey: kCIInputImageKey)
            guard let result = filter.value(forKey: kCIOutputImageKey) as? UIKit.CIImage else { return }
            self.image = UIImage(cgImage: CIContext(options: nil).createCGImage(result, from: result.extent)!)
        }
    }
}

extension UIViewController {
    func showAlertWith(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
       
        alertController.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

extension UIImageView {
    
    func loadcacheImageUsingCacheWithURLString(_ URLString: String, placeHolder: UIImage?, inverse: Bool = false) {
        guard let imageUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(URLString).appendingPathExtension("png") else {
            return
        }
        self.image = nil
        if FileManager.default.fileExists(atPath: imageUrl.path) {
            if let imageData = try? Data(contentsOf: imageUrl), let image = UIImage(data: imageData) {
                self.image = image
                if inverse{
                self.inverseImage()
                }
            }
        }
        if let url = URL(string: URLString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    print("ERROR LOADING IMAGES FROM URL: \(String(describing: error))")
                    DispatchQueue.main.async {
                        self.image = placeHolder
                        if inverse{
                        self.inverseImage()
                        }
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            do{
                            try data.write(to: imageUrl)
                            }catch{}
                            self.image = downloadedImage
                            if inverse{
                            self.inverseImage()
                            }
                        }
                    }
                }
            }).resume()
        }
    }
}


extension Notification.Name {
    static let didReceiveConnection = Notification.Name("didReceiveConnection")
}


