import Foundation

extension Int {
    static func random(from range: Range<Int>) -> Int {
        let lowerBound = range.lowerBound
        let upperBound = range.upperBound
        return lowerBound + Int(arc4random_uniform(UInt32(upperBound - lowerBound)))
    }
}
