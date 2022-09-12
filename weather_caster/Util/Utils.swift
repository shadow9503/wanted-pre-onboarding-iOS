//
//  Utils.swift
//  weather_caster
//
//  Created by 유영훈 on 2022/09/12.
//

import Foundation
import UIKit

class Utils {
    
    struct UserDefaultsManager {
        @UserDefaultWrapper(key: "reports", defaultValue: nil)
        static var reports: [OpenWeatherMap.report]?
    }
    
    @propertyWrapper
    struct UserDefaultWrapper<T: Codable> {
        private let key: String
        private let defaultValue: T?

        init(key: String, defaultValue: T?) {
            self.key = key
            self.defaultValue = defaultValue
        }
        
        var wrappedValue: T? {
            get {
                if let savedData = UserDefaults.standard.object(forKey: key) as? Data {
                    let decoder = JSONDecoder()
                    if let lodedObejct = try? decoder.decode(T.self, from: savedData) {
                        return lodedObejct
                    }
                }
                return defaultValue
            }
            set {
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(newValue) {
                    UserDefaults.standard.setValue(encoded, forKey: key)
                }
            }
        }
    }
}

public let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func loadImage(from urlString: String) -> URLSessionDataTask? {
        guard let url = URL(string: urlString) else { return nil }
        
        image = nil
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            print(cachedImage)
            self.image = cachedImage
            return nil
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil { return }
            
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                print("now cached")
                guard let img = UIImage(data: data) else { return }
                imageCache.setObject(img, forKey: urlString as NSString)
                self.image = img
            }
        }
        task.resume()
        
        return task
    }
  
}
