import Foundation

// DataSource Protocols

protocol PromptDataSource {
    func randomizePrompt() -> Prompt?
}

class PromptDataSourceImpl: PromptDataSource {
    var prompts: [Prompt] = []
    
    init() {
        // TODO: use data fetching / reading from json
        prompts = [ Prompt(promptDescription: "Question: where in the body does a poem come from?", id: "1"),
                    Prompt(promptDescription: "Write a dream poem set in all pink", id: "2"),
                    Prompt(promptDescription: "Write a shoreline poem. Then remove all the water.", id: "3"),
                    Prompt(promptDescription: "You roll up to the Word Bank. Like, the literally Word Bank. What's in your account? Are you depositing? What's the teller like? Where's the bank located? What's a word for a roll of quarters?", id: "4"),
                    Prompt(promptDescription: "Test5", id: "5"),
                    Prompt(promptDescription: "Test6", id: "6"),
                    Prompt(promptDescription: "Test7", id: "7"),
                    Prompt(promptDescription: "Test8", id: "8"),
                    Prompt(promptDescription: "Test9", id: "9"),
                    Prompt(promptDescription: "Test10", id: "10")]
    }
    
    func randomizePrompt() -> Prompt? {
        return prompts.randomElement()
    }
}
// Data Model

public class Prompt {
    var promptDescription: String
    var id: String
    
    init(promptDescription: String, id: String) {
        self.promptDescription = promptDescription
        self.id = id
    }
}

// UseCase Protocols

public protocol RandomizePromptUseCase {
    func getRandomPrompt(request: PromptRequest) -> Prompt?
}

// UseCase Implementation

public class PromptInteractor: RandomizePromptUseCase, FavoriteUseCase {
    let dataSource: PromptDataSource
    let favDataSource: FavoritesDataSource
    
    init(dataSource: PromptDataSource,
         favDataSource: FavoritesDataSource) {
        self.dataSource = dataSource
        self.favDataSource = favDataSource
    }
    
    //RandomizePromptUseCase
    public func getRandomPrompt(request: PromptRequest) -> Prompt? {
        let randomPrompt = dataSource.randomizePrompt()
        
        guard let promptId = request.currentPromptId, let generatedPrompt = randomPrompt else { return randomPrompt }
        
        if generatedPrompt.id != promptId {
            return randomPrompt
        } else {
            return getRandomPrompt(request: request)
        }
    }
    
    //FavoriteUseCase
    public func save(thing: String) {
        favDataSource.save(thing: thing)
    }
    
    public func delete(thing: String) {
        favDataSource.delete(thing: thing)
    }
    
    public func getFavorites() -> [String]? {
        return favDataSource.favorites()
    }
    
}

// Entities

// Request Objects

public struct PromptRequest {
    var currentPromptId: String?
}

// Response Objects
