//
//  CoinManager.swift
//  ByteCoin
//
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinViewModelDelegate {
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinViewModel {
    
    var delegate: CoinViewModelDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "988F6C59-5F9C-4C1F-ABEE-6FD4040D25EA"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        
        /*Usa a concatenação de String para adicionar a moeda selecionada no final do baseURL.
         let urlString = baseURL + currency*/
        
        //Adiciona a moeda selecionada no final do baseURL junto com a chave API
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        // Usa ligação opcional para desempacotar a URL que é criada a partir de urlString
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default) //novo obj URLSession com config padrão.
            let task = session.dataTask(with: url) { (data, response, error) in //nova tarefa de dados para a URLSession
                if error != nil {
                    print(error!)
                    return
                }
                let dataAsString = String(data: data!, encoding: .utf8) // Formata os dados que recebemos como uma string para poder imprimi-los
                print(dataAsString!)
                
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        //Opcional: arredondar o preço para 2 casas decimais.
                        let priceString = String(format: "%.2f", bitcoinPrice)
                                            
                        //Chama o método delegado no delegado (ViewController) e passa os dados necessários.
                       self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                     }
                }
                
            }
            // Inicia a tarefa de buscar dados dos servidores do bitcoin average.
            task.resume()
        }
        
    }
    
    func parseJSON(_ data: Data) -> Double? {

            //Create a JSONDecoder
            let decoder = JSONDecoder()
            do {

                //tenta decodificar os dados usando a estrutura CoinData
                let decodedData = try decoder.decode(CoinData.self, from: data)

                //Obtém a última propriedade dos dados decodificados.
                let lastPrice = decodedData.rate
                print(lastPrice)
                            return lastPrice

                        } catch {

                            //Catch and print any errors.
                            delegate?.didFailWithError(error: error)
                            return nil
                        }
                    }


                
}
