//
//  ListViewControllerExtention.swift
//  SahibindenCase
//
//  Created by salih topcu on 22.06.2019.
//  Copyright © 2019 salih topcu. All rights reserved.
//

import UIKit

// MARK: - CollectionViewDataDelegate, CollectionViewDelegate

extension ListViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.result?.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var selectedCell: [Int] = []
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ListCollectionViewCell
        
        let title = viewModel.result?.results[indexPath.row].artistName
        let trackName = viewModel.result.results[indexPath.row].trackName
        let imageUrl = viewModel.result.results[indexPath.row].artworkUrl100
        let trackId = viewModel.result.results[indexPath.row].trackId
        
        if let strUrl = imageUrl, let _ = URL(string: strUrl) {
            cell.setView(imageUrl: strUrl, title: title ?? "", trackName: trackName ?? "")
            selectedCell = UserDefaults.standard.array(forKey: "selectedCell") as? [Int] ?? [0]
            
            for i in selectedCell {
                let select = i
                if trackId == select {
                    cell.contentView.backgroundColor = UIColor.yellow.withAlphaComponent(0.3)
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailViewController = storyBoard.instantiateViewController(withIdentifier: "detailVC") as! DetailViewController
        detailViewController.result = viewModel.result.results[indexPath.row]
        detailViewController.delegate = self
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// MARK: - PickerViewDelegate,PickerViewDataSource

extension ListViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if CheckInternet.Connection() {
            switch row {
            case Filter.all.rawValue:
                viewModel.getList(value: Type.all.rawValue)
                navigationItem.title = Type.all.rawValue
            case Filter.movie.rawValue:
                viewModel.getList(value: Type.movie.rawValue)
                navigationItem.title = Type.movie.rawValue
            case Filter.podcast.rawValue:
                viewModel.getList(value: Type.podcast.rawValue)
                navigationItem.title = Type.podcast.rawValue
            case Filter.music.rawValue:
                viewModel.getList(value: Type.music.rawValue)
                navigationItem.title = Type.music.rawValue
            default:
                break
            }
        } else {
            self.CheckInternetAlert()
        }
        enum Filter: Int {
            case all = 0
            case movie = 1
            case podcast = 2
            case music = 3
        }
        
        enum Type : String {
            case all
            case movie
            case podcast
            case music
        }
    }
}

// MARK: - SearchBarDelegate

extension ListViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.isEmpty {
            viewModel.getList(value: "all")
        } else {
            viewModel.getList(value: searchBar.text!)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
}

extension ListViewController : ListViewDelegate {
    func updatedList() {
        DispatchQueue.main.async {
            self.colllectionView.reloadData()
        }
    }
}

// MARK: - ListViewController DeleteCellDelegate

extension ListViewController : DeleteCellDelegate {
    func deleteCell(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            var removeCell : [Int] = []
            guard let remove = self.viewModel.result.results[self.selectedIndexPath.row].trackId else {return}
            self.viewModel.result.results.remove(at: self.selectedIndexPath.row)
            removeCell = UserDefaults.standard.array(forKey: "removeCell") as? [Int] ?? []
            removeCell.append(remove)
            UserDefaults.standard.set(removeCell, forKey: "removeCell")
            self.colllectionView.reloadData()
        }
    }
}

// MARK: - ListViewController TextFieldDelegate

extension ListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        filterTextfield.resignFirstResponder()
        return true
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func addToolBar(textField: UITextField){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(donePressed))
        doneButton.tintColor = UIColor.gray
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    
    @objc func donePressed(){
        navigationController?.navigationBar.endEditing(true)
    }
}


