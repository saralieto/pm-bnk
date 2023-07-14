import Foundation

public protocol FavoritesDataSource {
    func save(thing: String)
    func delete(thing: String)
    func favorites() -> [String]?
}

public class FavoritesDataSourceImpl: FavoritesDataSource {
    static let favorites = "Favorites"
    
    init() {
        let favs: [String] = []
        let localFavs = UserDefaults.standard.object(forKey: FavoritesDataSourceImpl.favorites) as? [String]

        if localFavs == nil {
            UserDefaults.standard.set(favs, forKey: FavoritesDataSourceImpl.favorites)
        }
    }
    
    public func save(thing: String) {
        guard var favs = UserDefaults.standard.object(forKey: FavoritesDataSourceImpl.favorites) as? [String] else { return }
        
        favs.append(thing)
    }
    
    public func delete(thing: String) {
        guard var favs = UserDefaults.standard.object(forKey: FavoritesDataSourceImpl.favorites) as? [String] else { return }
        
        guard let index = favs.firstIndex(of: thing) else { return }
        
        favs.remove(at: index)
        UserDefaults.standard.set(favs, forKey: FavoritesDataSourceImpl.favorites)
    }
    
    public func favorites() -> [String]? {
        return UserDefaults.standard.object(forKey: FavoritesDataSourceImpl.favorites) as? [String]
    }
    
    public func clearAll() {
        UserDefaults.standard.set([], forKey: FavoritesDataSourceImpl.favorites)
    }
}

public protocol FavoriteUseCase {
    func save(thing: String)
    func delete(thing: String)
    func getFavorites() -> [String]?
}
