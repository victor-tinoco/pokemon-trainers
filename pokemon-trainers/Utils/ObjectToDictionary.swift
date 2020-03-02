//
//  JsonToDictionary.swift
//  pokemon-trainers
//
//  Created by Victor Martins Tinoco - VTN on 19/02/20.
//  Copyright © 2020 tinoco. All rights reserved.
//

import Foundation

extension NSObject {
    func toDict() -> [String:Any] {
        var dict = [String:Any]()
        let otherSelf = Mirror(reflecting: self)
        for child in otherSelf.children {
            if let key = child.label {
                dict[key] = child.value
            }
        }
        return dict
    }
}

extension Array where Element == [String:Any] {
    func toTrainer() -> [Trainer] {
        var list: [Trainer] = []
        self.forEach { (dict) in
            list.append(Trainer(name: dict["name"] as? String ?? "",
                                pokemonType: dict["pokemonType"] as? String ?? ""))
        }
        return list
    }

    func toPokemonTypes() -> PokemonTypes {
        let types = PokemonTypes(types: self[0]["types"] as! [String])
        return types
    }
}
