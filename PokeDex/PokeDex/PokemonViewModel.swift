//
//  PokemonManager.swift
//  PokeDex
//
//  Created by Walter A Ramirez on 9/19/21.
//

import SwiftUI

enum FetchError: Error {
    case badURL
    case badResponse
    case badData
}

class PokemonViewModel: ObservableObject {
    @Published var pokemon = [Pokemon]()
    init() {
        async {
           pokemon = try await getPokemon()
        }
    }
    func getPokemon() async throws -> [Pokemon] {
    guard let url = URL(string: "https://pokedex-bb36f.firebaseio.com/pokemon.json")
        else {
            throw FetchError.badURL
        }
        
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.badResponse }
        guard let data = data.removeNullsFromString(string: "null,") else { throw FetchError.badData}
        
        let maybePokemonData = try JSONDecoder().decode([Pokemon].self, from: data)
        return maybePokemonData
        }
    let MOCK_POKEMON = Pokemon(id: 0, name: "Bulbasaur", imageURL: "https://firebasestorage.googleapis.co...", type: "poison", description: "This is a test example of what the text in the description would look like for the given pokemon. This is a test example of what the text in the description would look like for the given pokemon.", attack: 49, defense: 52, height: 10, weight: 98)
    }

extension Data {
    func removeNullsFromString(string: String) -> Data? {
        let dataAsString = String(data: self, encoding: .utf8)
        let parsedDataString = dataAsString?.replacingOccurrences(of: string, with: "")
        guard let data = parsedDataString?.data(using: .utf8) else { return nil }
        return data
    }
}
