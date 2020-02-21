//
//  Trainer.swift
//  pokemon-trainers
//
//  Created by Victor Martins Tinoco - VTN on 18/02/20.
//  Copyright © 2020 tinoco. All rights reserved.
//

import Foundation

class Trainer: NSObject {
    let name: String
    let pokemonType: String

    init(name: String, pokemonType: String) {
        self.name = name
        self.pokemonType = pokemonType
    }
}
