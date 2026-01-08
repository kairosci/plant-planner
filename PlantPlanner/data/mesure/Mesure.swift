import Foundation

class Mesure: Coordinate {
    var dimension: Double
    var unit: String
    
    init(latitude: Double = 0.0, longitude: Double = 0.0, dimension: Double = 0.0, unit: String = "M") {
        self.dimension = dimension
        self.unit = unit
        super.init(latitude: latitude, longitude: longitude)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dimension = try container.decode(Double.self, forKey: .dimension)
        self.unit = try container.decode(String.self, forKey: .unit)
        
        try super.init(from: decoder)
    }
    
    private enum CodingKeys: String, CodingKey {
        case dimension
        case unit
    }
}
