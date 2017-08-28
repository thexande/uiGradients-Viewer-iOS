//
//  GradientHelper.swift
//  ui_gradients_viewer
//
//  Created by Alexander Murphy on 8/27/17.
//  Copyright © 2017 Alexander Murphy. All rights reserved.
//

import Foundation
import SwiftHEXColors

struct GradientColor {
    let title: String
    let colors: [[String:UIColor]]
}

class GradientHelper {
    static func produceGradients(_ completion: @escaping([GradientColor]) -> Void) {
        GradientHelper.fetchGradientData { (gradientData) in
            let gradientStructs: [GradientColor] = gradientData.map({ (grad) -> GradientColor? in
                guard let gradName = grad["name"] as? String, let colors = grad["colors"] as? [String] else { return nil }
                
                let colorDicts = colors.map({ (colorHexString) -> [String:UIColor]? in
                    guard let color = UIColor(hexString: colorHexString) else { return nil }
                    return [colorHexString:color]
                }).flatMap({ $0 })
                
                return GradientColor(title: gradName, colors: colorDicts)
            }).flatMap({$0})
            
            completion(gradientStructs)
        }
    }
    
    static func fetchGradientData(_ completion: @escaping([[String:Any]]) -> Void) {
        // Set up the URL request
        let todoEndpoint: String = "https://raw.githubusercontent.com/Ghosh/uiGradients/master/gradients.json"
        guard let url = URL(string: todoEndpoint) else { return }
        
        let urlRequest = URLRequest(url: url)
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let responseData = data, error == nil else {
                completion([])
                return
            }
            do {
                guard let gradientData = try JSONSerialization.jsonObject(with: responseData, options: []) as? [[String: Any]] else {
                    print("error trying to convert data to JSON")
                    return
                }
                completion(gradientData)
            } catch  {
                print("failed to serialize data to JSON")
                return
            }
        }
        task.resume()
    }
}

