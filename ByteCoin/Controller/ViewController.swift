//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    @IBAction func tappedShowAlert(_ sender: UIButton) {
        
        let alert: UIAlertController = UIAlertController(title: "My Alert", message: "Alerta!! ;)", preferredStyle: .alert)
        
        //ações que o usuário pode executar em resposta ao alerta
        let action1: UIAlertAction = UIAlertAction(title: "Default", style: .default) { (action) in
        } //button default
        
        let action2: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }//button Cancel
        
        alert.addAction(action1)
        alert.addAction(action2)
        
        self.present(alert, animated: true, completion: nil)
    }

    

    
    @IBOutlet weak var biticoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinViewModel = CoinViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinViewModel.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }
    
}
    
//MARK: - CoinManagerDelegate

extension ViewController: CoinViewModelDelegate {
    
    func didUpdatePrice(price: String, currency: String) {
        
        DispatchQueue.main.async { //gerenciador de filas
            self.biticoinLabel.text = price
            self.currencyLabel.text = currency
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - UIPickerView DataSource & Delegate

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //fornecer os dados e adicionar a implementação para o primeiro método numberOfComponents(in:) para determinar quantas colunas queremos em nosso seletor
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //contar o número de moedas que precisamos exibir
        return coinViewModel.currencyArray.count
        //vamos atualizar o PickerView com alguns títulos e detectar quando ele interage
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent: Int) -> String? {
        return coinViewModel.currencyArray[row]
    }
    
    /*Isso será chamado toda vez que o usuário rolar o seletor. Quando isso acontecer, ele registrará o número da linha que foi selecionada.*/
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //make a selection
        //print(coinManager.currencyArray[row])
        let selectedCurrency = coinViewModel.currencyArray[row]
        coinViewModel.getCoinPrice(for: selectedCurrency)

        
    }
}

//        let alert = UIAlertController(title: "My Alert", message: "Alerta!! ;)", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
//            //alert.addAction executa o bloco do objeto de ação
//        NSLog("The \"OK\" alert occured.")
//        }))
//        self.present(alert, animated: true, completion: nil)
