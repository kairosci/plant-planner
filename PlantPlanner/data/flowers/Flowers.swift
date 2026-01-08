import Foundation

class Flower: Mesure {
    enum Flowers: String, CaseIterable, Codable {
        case carnation = "Garofano"
        case chrysanthemum = "Crisantemo"
        case gerbera = "Gerbera"
        case greenTrick = "Green Trick"
        case peonie = "Peonia"
        case rose = "Rosa"
        case statice = "Statice"
        case sunflower = "Girasole"
        case tulip = "Tulipano"
        case wallflower = "Violaciocca"
        case defaultValue = ""
    }
    
    var id: Int
    var greenHouseName: String
    var size: Mesure
    var type: Flowers
    
    init(id: Int = 0, greenHouseName: String = "", size: Mesure = Mesure(), type: Flowers = .defaultValue) {
        self.id = id
        self.greenHouseName = greenHouseName
        self.size = size
        self.type = type
        super.init(latitude: size.latitude, longitude: size.longitude, dimension: size.dimension, unit: size.unit)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.greenHouseName = try container.decode(String.self, forKey: .greenHouseName)
        
        self.size = try container.decode(Mesure.self, forKey: .size)
        
        self.type = try container.decode(Flowers.self, forKey: .type)
        
        try super.init(from: decoder)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case greenHouseName
        case size
        case type
    }
}
