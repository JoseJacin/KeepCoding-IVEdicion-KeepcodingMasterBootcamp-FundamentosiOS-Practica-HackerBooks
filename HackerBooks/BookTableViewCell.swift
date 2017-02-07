//
//  BookTableViewCell.swift
//  HackerBooks
//
//  Created by Jose Sanchez Rodriguez on 7/2/17.
//  Copyright © 2017 Jose Sanchez Rodriguez. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    //MARK: - Computed Properties
    // Propiedad que retorna el identificador de la celda
    static var cellId: String {
        get {
            return "BookTableViewCell"
        }
    }
    
    // Propiedad que retorna el alto de la celda
    static var cellHeight: CGFloat {
        get {
            return 80
        }
    }
    
    //MARK: - Properties
    var ImageViewData: AsyncData? = nil
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookAuthorsLabel: UILabel!
    @IBOutlet weak var BookTagsLabel: UILabel!
}

//MARK: - AsyncDataDelegate
// Función que se ejecuta cuando se ha finalizado la descarga de la imagen
extension BookTableViewCell: AsyncDataDelegate {
    // Función que actualiza la imagen del Book (Portada) cuando ha terminado su descarga
    func asyncData(_ sender: AsyncData, didEndLoadingFrom url: URL) {
        // Se actualiza la imagen del Book (Portada)
        UIView.transition(with: bookImageView,
                          duration: 0.7,
                          options: [.transitionCrossDissolve],
                          animations: {
                            self.bookImageView.image = UIImage(data: sender.data)
                            
        }, completion: nil)
    }
    
    //MARK: Utils
    func setCoverViewData(with data: AsyncData) {
        ImageViewData = data
        ImageViewData!.delegate = self
        bookImageView.image = UIImage(data: ImageViewData!.data)
    }
}
