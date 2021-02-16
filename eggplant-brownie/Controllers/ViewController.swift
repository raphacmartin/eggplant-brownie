//
//  ViewController.swift
//  eggplant-brownie
//
//  Created by Raphael Martin on 26/01/21.
//

import UIKit

protocol AdicionaRefeicaoDelegate {
    func add(_ refeicao: Refeicao)
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AdicionaItensDelegate {
    
    // MARK: - IBOutlet
    @IBOutlet weak var itensTableView: UITableView?
    
    // MARK: - Atributos
    
    var delegate: AdicionaRefeicaoDelegate?
    var itens = [
        Item(nome:"Molho de tomate", calorias: 10.0),
        Item(nome:"Queijo", calorias: 10.0),
        Item(nome:"Molho apimentado", calorias: 10.0),
        Item(nome:"Manjericão", calorias: 10.0)
    ]
    var itensSelecionados = [Item]()
    
    // MARK: - IBOutlets
    @IBOutlet var nomeTextField: UITextField!
    @IBOutlet var felicidadeTextField: UITextField!
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        let botaoAdicionarItem = UIBarButtonItem(title: "Adicionar", style: .plain, target: self, action: #selector(self.adicionarItens))
        navigationItem.rightBarButtonItem = botaoAdicionarItem
        recuperaItens()
    }
    
    func recuperaItens() {
        itens = ItemDao().recupera()
    }
    
    @objc func adicionarItens() {
        let adicionarItensViewController = AdicionarItensViewController(delegate: self)
        navigationController?.pushViewController(adicionarItensViewController, animated: true)
    }
    
    func add(_ item: Item) {
        itens.append(item)
        ItemDao().save(itens)
        if let tableView = itensTableView {
            tableView.reloadData()
        } else {
            Alerta(controller: self).exibe(mensagem: "Não foi possível atualizar a tabela")
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itens.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        let linhaDaTabela = indexPath.row
        let item = itens[linhaDaTabela]
        
        celula.textLabel?.text = item.nome
        
        return celula
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let celula = tableView.cellForRow(at: indexPath) else { return }
        
        if celula.accessoryType == .none {
            celula.accessoryType = .checkmark
            let linhaDaTabela = indexPath.row
            itensSelecionados.append(itens[linhaDaTabela])
        } else {
            celula.accessoryType = .none
            
            let item = itens[indexPath.row]
            if let position = itensSelecionados.firstIndex(of: item) {
                itensSelecionados.remove(at: position)
            }
        }
    }
    
    func recuperaRefeicaoFormulario() -> Refeicao? {
        guard let nome = nomeTextField.text else { return nil }
        guard let felicidadeText = felicidadeTextField.text, let felicidade = Int(felicidadeText) else { return nil }
        
        return Refeicao(nome: nome, felicidade: felicidade, itens: itensSelecionados)
    }
    
    // MARK: - IBActions
    @IBAction func adicionar(_ sender: Any) {
        if let refeicao = recuperaRefeicaoFormulario() {
            delegate?.add(refeicao)
            navigationController?.popViewController(animated: true)
        } else {
            Alerta(controller: self).exibe(mensagem: "Formulário inválido")
        }
    }
}

