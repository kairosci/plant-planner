import Foundation

class Terrain: Flower {
    
    override init(id: Int = 0, greenHouseName: String = "", size: Mesure = Mesure(), type: Flowers = .defaultValue) {
        super.init(id: id, greenHouseName: greenHouseName, size: size, type: type)
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    func getGreenHouseName() -> String {
        return self.greenHouseName
    }
    
    func setGreenHouseName(_ greenHouseName: String) {
        self.greenHouseName = greenHouseName
    }
    
    func getSize() -> Mesure {
        return self.size
    }
    
    func setSize(_ size: Mesure) {
        self.size = size
    }
    
    func getType() -> Flowers {
        return self.type
    }
    
    func setType(_ type: Flowers) {
        self.type = type
    }
}
