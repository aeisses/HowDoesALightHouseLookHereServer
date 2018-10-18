import FluentSQLite
import Vapor

final class WorldMap: Codable {
    var id: Int?
    var latitude: Double
    var longitude: Double
    var worldMap: String
    
    init(latitude: Double, longitude: Double, worldMap: String) {
        self.latitude = latitude;
        self.longitude = longitude;
        self.worldMap = worldMap;
    }
}

extension WorldMap: SQLiteModel {}
extension WorldMap: Content {}
extension WorldMap: Migration {}
