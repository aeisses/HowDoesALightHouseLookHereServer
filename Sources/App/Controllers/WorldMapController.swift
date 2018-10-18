import Vapor

struct WorldMapController: RouteCollection {
    func boot(router: Router) throws {
        let worldMapRoute = router.grouped("api", "worldmap")
        worldMapRoute.post(use: createHandler)
        worldMapRoute.get(use: getAllHander)
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
}
