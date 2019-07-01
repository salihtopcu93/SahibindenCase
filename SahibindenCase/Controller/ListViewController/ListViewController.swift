//
//  ListViewController.swift
//  SahibindenCase
//
//  Created by salih topcu on 21.06.2019.
//  Copyright © 2019 salih topcu. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterTextfield: UITextField!
    @IBOutlet weak var colllectionView: UICollectionView!
    
    //MARK: - Properties
    var viewModel = ListViewModel()
    var selectedIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupSearchBar()
        getRequest()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        colllectionView.reloadData()
    }
    
    //MARK: - Actions
    
    @IBAction func filterTextField(_ sender: UITextField) {
        pickerView(sender: sender, PickerSelected: false)
    }
    
    //MARK: - Functions
    private func pickerView(sender : UITextField, PickerSelected : Bool) {
        let pv = UIPickerView()
        pv.dataSource = self
        pv.delegate = self
        addToolBar(textField: sender)
        sender.inputView = pv
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
    }
    
    private func getRequest() {
        
        if CheckInternet.Connection() {
            viewModel.getList(value: "all")
        } else {
            self.CheckInternetAlert()
        }
    }
    
    func CheckInternetAlert() {
        let alertController = UIAlertController(title: "Attention", message: "Check your internet connection.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: { action in
            self.navigationController?.popViewController(animated: true)
            self.getRequest()
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
}

