//
//  AdicionarItensViewController.swift
//  eggplant-brownie
//
//  Created by Raphael Martin on 04/02/21.
//

import UIKit

protocol AdicionaItensDelegate {
    func add(_ item: Item)
}

class AdicionarItensViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var nomeTextField: UITextField!
    @IBOutlet weak var caloriasTextField: UITextField!
    
    // MARK: - Atributos
    var delegate: AdicionaItensDelegate
    
    init(delegate: AdicionaItensDelegate) {
        self.delegate = delegate
        super.init(nibName: "AdicionarItensViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("🔥")
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - IBAction
    @IBAction func adicionarItem(_ sender: Any) {
        guard let nome = nomeTextField.text else { return }
        guard let caloriasText = caloriasTextField.text, let calorias = Double(caloriasText) else { return }
        
        let item = Item(nome: nome, calorias: calorias)
        delegate.add(item)
        navigationController?.popViewController(animated: true)
    }
    
}
