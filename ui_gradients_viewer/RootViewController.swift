//
//  ViewController.swift
//  ui_gradients_viewer
//
//  Created by Alexander Murphy on 8/27/17.
//  Copyright © 2017 Alexander Murphy. All rights reserved.
//

import UIKit


extension UIColor {
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = hexString.substring(from: start)
            
            if hexColor.characters.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}

struct GradientColor {
    let title: String
    let hexOne: String
    let hexTwo: String
    let colorOne: UIColor
    let colorTwo: UIColor
}

class RootViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.title = "woot"
        
        
        makeGetCall()
        
        
        
    }

    
    func makeGetCall() {
        // Set up the URL request
        let todoEndpoint: String = "https://raw.githubusercontent.com/Ghosh/uiGradients/master/gradients.json"
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        
        let urlRequest = URLRequest(url: url)
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
            if let data = data {
                print(String(data: data, encoding: .utf8) ?? "NO DATA")
            }
            
            if let response = response {
                print(response)
            }
            
            // check for any errors
            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            // parse the result as JSON, since that's what the API provides
            do {
                guard let gradients = try JSONSerialization.jsonObject(with: responseData, options: []) as? [[String: Any]] else {
                    print("error trying to convert data to JSON")
                    return
                }
                
                for grad in gradients {
                    guard let gradName = grad["name"] as? String else { return }
                    guard let colors = grad["colors"] as? [String] else { return }
                    print("name here \(gradName)")
                    print("colors here \(colors)")
                    
                    
                }
                
//                print("The todo is: " + todo.description)
                
                // the todo object is a dictionary
                // so we just access the title using the "title" key
                // so check for a title and print it if we have one
//                guard let todoTitle = todo["name"] as? String else {
//                    print("Could not get todo title from JSON")
//                    return
//                }
//                print("The title is: " + todoTitle)
            } catch  {
                print("failed to serialize data to JSON")
                return
            }
        }
        
        task.resume()
    }
}

