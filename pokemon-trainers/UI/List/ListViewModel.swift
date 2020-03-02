//
//  ListViewModel.swift
//  pokemon-trainers
//
//  Created by Victor Martins Tinoco - VTN on 18/02/20.
//  Copyright © 2020 tinoco. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol ListViewModelContract {
    var postState: Driver<Result<Void, Error>?> { get }
    var trainersList: Driver<[Trainer]?> { get }
    var pokemonTypesList: Driver<[String]?> { get }
    
    func willMakePostTrainer(trainer: Trainer)
    func didRequestTrainers()
    func didRequestPokemonTypes()
    func didRequestPokemonType(index: Int) -> String
}

class ListViewModel: ListViewModelContract {
    private let TRAINERS_COLLECTION_KEY = "trainers"
    private let POKEMON_TYPES_COLLECTION_KEY = "pokemonTypes"
    
    private let _postStateRelay: BehaviorRelay<Result<Void, Error>?> = BehaviorRelay(value: nil)
    private let _trainersListRelay: BehaviorRelay<[Trainer]?> = BehaviorRelay(value: nil)
    private let _pokemonTypesListRelay: BehaviorRelay<[String]?> = BehaviorRelay(value: nil)
    private let _disposeBag = DisposeBag()
    
    private let _service = FirebaseService()
    
    var postState: Driver<Result<Void, Error>?> { return _postStateRelay.asDriver(onErrorJustReturn: nil) }
    var trainersList: Driver<[Trainer]?> { return _trainersListRelay.asDriver(onErrorJustReturn: nil) }
    var pokemonTypesList: Driver<[String]?> { return _pokemonTypesListRelay.asDriver(onErrorJustReturn: nil) }
    
    func willMakePostTrainer(trainer: Trainer) {
        _service.post(collection: TRAINERS_COLLECTION_KEY, dictionary: trainer.toDict()).subscribe(onSuccess: { (res) in
            self._postStateRelay.accept(res)
        }).disposed(by: _disposeBag)
    }
    
    func didRequestTrainers() {
        _service.get(collection: TRAINERS_COLLECTION_KEY).subscribe(onNext: { (dict) in
            let trainers = dict.toTrainer()
            self._trainersListRelay.accept(trainers)
        }).disposed(by: _disposeBag)
    }
    
    func didRequestPokemonTypes() {
        _service.get(collection: POKEMON_TYPES_COLLECTION_KEY).subscribe(onNext: { (objWithTypes) in
            let types = objWithTypes.toPokemonTypes().types
            self._pokemonTypesListRelay.accept(types)
        }).disposed(by: _disposeBag)
    }
    
    func didRequestPokemonType(index: Int) -> String {
        return _pokemonTypesListRelay.value?[index] ?? ""
    }
}
