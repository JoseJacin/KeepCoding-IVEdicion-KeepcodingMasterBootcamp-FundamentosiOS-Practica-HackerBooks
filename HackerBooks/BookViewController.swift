//
//  BookViewController.swift
//  HackerBooks
//
//  Created by Jose Sanchez Rodriguez on 5/2/17.
//  Copyright © 2017 Jose Sanchez Rodriguez. All rights reserved.
//

import UIKit

class BookViewController: UIViewController {
    //MARK: - Constants
    
    //MARK: - Static properties
    private static let bookIcon : String = "HackerBooks-BookIcon.png"
    private static let defaultImage = Bundle.main.url(forResource: bookIcon)!
    
    //MARK: - Properties
    var book : Book // Propiedad Book (Libro)
    fileprivate var bookImageData: AsyncData // Propiedad AsyncData para la imagen del Book
    
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var favorite: UIBarButtonItem!
    
    
    //MARK: - Initialization
    // Inicializador designado (Si no se indica que es el de conveniencia, es el designado)
    init(book: Book) {
        self.book = book
        // Se descarga en segundo plano la Portada del Book. Mientras tanto, se indica una imagen por defecto
        bookImageData = AsyncData(url: book.imageUrl, defaultData: try! Data(contentsOf: BookViewController.defaultImage))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    // Función que se ejecuta cuando la vista se va a estar visible.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Se llama a la función que sincroniza la vista con el modelo
        syncViewWithBook()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Sync model -> View
    // Función que sincroniza la vista con el modelo, es decir, saca datos del modelo y los mete en la vista
    func syncViewWithBook() {
        // Se llama a la función que
        //photoView.image = // En espera de implementar la parte de AsyncData
        title = book.title
    }
    
    //MARK: - Actions
    // Función que muestra el fichero PDF asociado al Book
    @IBAction func openPdf(_ sender: UIBarButtonItem) {
    }
    
    // Función palanca que activa/desactiva la propiedad Favorite del Book
    @IBAction func toggleFavorite(_ sender: UIBarButtonItem) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: - Protocols

//MARK: - LibraryViewControllerDelegate
