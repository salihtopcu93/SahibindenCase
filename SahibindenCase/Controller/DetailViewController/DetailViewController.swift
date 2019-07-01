//
//  DetailViewController.swift
//  SahibindenCase
//
//  Created by salih topcu on 22.06.2019.
//  Copyright © 2019 salih topcu. All rights reserved.
//

import UIKit

protocol DeleteCellDelegate {
    func deleteCell()
}

class DetailViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var detailImageView: ImageLoader!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var kindNameLabel: UILabel!
    @IBOutlet weak var trackNameLabel: UILabel!

    //MARK: - Properties
    var result: Media!
    var selectCell: [Int] = []
    var delegate : DeleteCellDelegate?

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    //MARK: - Actions
    @IBAction func deleteButton(_ sender: Any) {
        showAlert()
    }
    
    //MARK: - Functions
    func setView(){
        detailImageView.layer.borderWidth = 2
        detailImageView.layer.borderColor = UIColor.yellow.cgColor
        artistNameLabel.text = result.artistName
        trackNameLabel.text = result.trackName
        kindNameLabel.text = result.kind
        guard let imageUrl = URL(string: result.artworkUrl100 ?? "") else {return}
        detailImageView.loadImageWithUrl(imageUrl)
        selectedCell()
        labelAutomaticFont()
    }
    
    func labelAutomaticFont(){
        artistNameLabel.adjustsFontSizeToFitWidth = true
        kindNameLabel.adjustsFontSizeToFitWidth = true
        trackNameLabel.adjustsFontSizeToFitWidth = true
    }

    func selectedCell() {
        selectCell = UserDefaults.standard.array(forKey: "selectedCell") as? [Int] ?? [0]
        guard let selectedId = result.trackId else {return}
        selectCell.append(selectedId)
        UserDefaults.standard.set(selectCell, forKey: "selectedCell")
    }
    
    func showAlert(){
        let alertController = UIAlertController(title: "Attention", message: "Are you sure you want to delete?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: { action in
            self.delegate?.deleteCell()
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
}
