//
//  ListViewModel.swift
//  SahibindenCase
//
//  Created by salih topcu on 22.06.2019.
//  Copyright © 2019 salih topcu. All rights reserved.
//

import Foundation
import UIKit

protocol ListViewDelegate: class {
    func updatedList()
}

class ListViewModel {
    var result : Search!
    var pickerData: [String] = ["all", "movie", "podcast", "music"]
    var delegate : ListViewDelegate?
    
    func getList(value: String){
        setLoading(true)
        
        let baseURL = "https://itunes.apple.com/search?parameterkeyvalue&"
        
        guard let url = URL(string: "\(baseURL)term=\(value)&limit=100") else { return }
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)

                    let result = try JSONDecoder().decode(Search.self, from: data)
                    self.result = result
                    self.deleteItems(result: result)
                    self.delegate?.updatedList()
                }catch {
                    print(error)
                }
            }
            if let response = response {
                print(response)
            }
            if let error = error {
                print(error)
            }
        }.resume()
        setLoading(false)
    }
    
    private func deleteItems(result: Search) {
        var res = result
        guard let remove = UserDefaults.standard.array(forKey: "removeCell") as? [Int] else {return}

        for (i, element) in res.results.enumerated() {
            if remove.contains(element.trackId ?? 0) {
                let removeIndex = result.results.count - res.results.count
                res.results.remove(at: i - removeIndex)
            }
        }
        self.result = res
        self.delegate?.updatedList()
    }
    
    private func setLoading (_  isLoading : Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
    }
}



