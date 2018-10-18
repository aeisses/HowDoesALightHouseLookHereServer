import Vapor
import Fluent

struct WorldMapController: RouteCollection {
    func boot(router: Router) throws {
        let worldMapRoute = router.grouped("api", "worldmap")
        worldMapRoute.post(use: createHandler)
        worldMapRoute.get(use: getAllHander)
        router.get("api", "worldmap", "search", use: searchHandler)
        worldMapRoute.delete(WorldMap.parameter, use: deleteHandler)
    }
    
    func createHandler(_ req: Request) throws -> Future<WorldMap> {
        return try req.content
                      .decode(WorldMap.self)
                      .flatMap(to: WorldMap.self) { worldmap in
            return worldmap.save(on: req)
        }
    }
    
    func getAllHander(_ req: Request) throws -> Future<[WorldMap]> {
        return WorldMap.query(on: req).all()
    }
    
    func searchHandler(_ req: Request) throws -> Future<[WorldMap]> {
        guard let longitude = req.query[Double.self, at: "longitude"] else {
            throw Abort(.badRequest)
        }
        
        guard let latitude = req.query[Double.self, at: "latitude"] else {
            throw Abort(.badRequest)
        }
        
        return WorldMap.query(on: req).filter(\.longitude <= longitude+0.01).filter(\.longitude >= longitude-0.01).filter(\.latitude <= latitude+0.01).filter(\.latitude >= latitude-0.01).all()
    }
    
    func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
        let worldmap = try req.parameters.next(WorldMap.self)
        return worldmap.delete(on: req).transform(to: .noContent)
    }
}


extension WorldMap: Parameter {}
