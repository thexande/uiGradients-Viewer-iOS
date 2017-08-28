//
//  ViewController.swift
//  ui_gradients_viewer
//
//  Created by Alexander Murphy on 8/27/17.
//  Copyright © 2017 Alexander Murphy. All rights reserved.
//

import UIKit
import GradientView
import SwiftHEXColors

struct GradientColor {
    let title: String
    let colors: [[String:UIColor]]
}

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.title = "woot"
        
        
        GradientHelper.produceGradients { [weak self] (gradients) in
            print(gradients)
            guard let strongSelf = self else { return }
            let gradientView = GradientView()
            gradientView.translatesAutoresizingMaskIntoConstraints = false
            
            guard let colors = gradients.first?.colors.map({ (colorDict) -> UIColor? in
                return colorDict.values.first
            }).flatMap({ $0 }) else { return }
            
            gradientView.colors = colors
            
            DispatchQueue.main.async {
                strongSelf.view.addSubview(gradientView)
                
                NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[grad]|", options: [], metrics: nil, views: ["grad":gradientView]))
                NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[grad]|", options: [], metrics: nil, views: ["grad":gradientView]))
            }
            
        }
    }
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

