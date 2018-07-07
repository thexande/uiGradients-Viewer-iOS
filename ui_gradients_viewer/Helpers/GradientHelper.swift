import Foundation
import SwiftHEXColors
import GradientView

struct GradientColor: Equatable {
    enum Format {
        case horizontal
        case vertical
        case radial
    }
    
    struct Color: Equatable {
        var hex: String
        var color: UIColor
        let identifier: UUID
        var isSelected: Bool
    }
    
    var title: String
    var colors: [Color]
    var format: Format
    var position: Float
}

class GradientHelper {
    static func produceGradientView(_ gradient: GradientColor) -> GradientView {
        let gradientView = GradientView()
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        
        let colors: [UIColor] = gradient.colors.map({ $0.color })
        
        gradientView.colors = colors
        return gradientView
    }
    
    static func produceGradients(_ completion: @escaping([GradientColor]) -> Void) {
        GradientHelper.fetchGradientData { (gradientData) in
            let gradientStructs: [GradientColor] = gradientData.map({ (grad) -> GradientColor? in
                guard let gradName = grad["name"] as? String, let colors = grad["colors"] as? [String] else { return nil }
                
                var colorDicts = colors.map({ (colorHexString) -> GradientColor.Color? in
                    guard let color = UIColor(hexString: colorHexString) else { return nil }
                    return GradientColor.Color(hex: colorHexString, color: color, identifier: UUID(), isSelected: false)
                }).compactMap({ $0 })
                
                // Select first gradient color
                
                colorDicts[0].isSelected = true
                
                return GradientColor(title: gradName, colors: colorDicts, format: .vertical, position: 0.5)
            }).compactMap({$0})
            
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

