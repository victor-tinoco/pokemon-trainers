//
//  TrainerService.swift
//  pokemon-trainers
//
//  Created by Victor Martins Tinoco - VTN on 18/02/20.
//  Copyright © 2020 tinoco. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Firebase

class FirebaseService {
    var db: Firestore!
    
    init() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
    }

    func post(collection: String, dictionary: [String:Any]) -> Single<Result<Void, Error>> {
        return Single<Result<Void, Error>>.create { (single) -> Disposable in
            var ref: DocumentReference? = nil
            ref = self.db.collection(collection).addDocument(data: dictionary) { err in
                if let err = err {
                    single(.error(err))
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                    single(.success(.success(())))
                }
            }
            return Disposables.create()
        }
    }
    
    func get(collection: String) -> Observable<[[String:Any]]> {
        return Observable.create { (observable) -> Disposable in
            self.db.collection(collection)
                .addSnapshotListener { (collSnapshot, err) in
                    guard let collection = collSnapshot?.documents else {
                        observable.onNext([])
                        return
                    }
                    observable.onNext(collection.map { $0.data() })
            }
            return Disposables.create()
        }
    }
}
