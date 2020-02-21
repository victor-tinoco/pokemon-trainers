//
//  ListViewController.swift
//  pokemon-trainers
//
//  Created by Victor Martins Tinoco - VTN on 18/02/20.
//  Copyright © 2020 tinoco. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ListViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var pickerTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    var viewModel: ListViewModelContract!

//  MARK: - TimeLine
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
//  MARK: - Methods
    static func instantiate(viewModel: ListViewModelContract) -> ListViewController {
        let vc = ListViewController(nibName: nil, bundle: nil)
        vc.viewModel = viewModel
        return vc
    }
    
    func setup() {
        navigationController?.navigationBar.topItem?.title = "Treinadores"
        
        bind()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func bind() {
        self.viewModel.didRequestTrainers()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        viewModel.trainersList.map{ $0 ?? [] }.drive(tableView.rx.items(cellIdentifier: "cell")) { index, model, cell in
            cell.textLabel?.text = model.name
        }.disposed(by: disposeBag)
        
        tableView.keyboardDismissMode = .onDrag
        
        addButton.rx.tap.bind { _ in
            guard let name = self.nameTextField.text, !name.isEmpty, let type = self.pickerTextField.text, !type.isEmpty else { return }
            self.viewModel.willMakePostTrainer(trainer: Trainer(name: name, pokemonType: type))
            
            self.viewModel.postState.drive(onNext: { (res) in
                let txt = res is Error ? "Erro ao adicionar novo treinador" : "Sucesso ao adicionar novo treinador"
                print(txt)
            }).disposed(by: self.disposeBag)
        }.disposed(by: disposeBag)
        
        let picker: UIPickerView
        picker = UIPickerView(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: 300))
        picker.backgroundColor = .systemGray
        viewModel.pokemonTypesList.map{ $0 ?? [] }.drive(picker.rx.itemTitles) { (row, el) in
            return el
        }.disposed(by: disposeBag)
        
        picker.rx.itemSelected.subscribe(onNext: { (row, component) in
            self.pickerTextField.text = self.viewModel.didRequestPokemonType(index: row)
        }).disposed(by: disposeBag)
        
        pickerTextField.inputView = picker
        
        viewModel.didRequestPokemonTypes()
    }
}
