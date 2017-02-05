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
    weak var delegate: BookViewControllerDelegate? = nil
    
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
    
    //MARK: - Sync model -> View
    // Función que sincroniza la vista con el modelo, es decir, saca datos del modelo y los mete en la vista
    func syncViewWithBook() {
        // Se muestra una imagen por defecto como portada mientras se descarga la original
        syncBookImageData()
        // Se actualiza el icono de Favorito dependiento de si el Book está marcado como Favorito o no
        syncFavoriteIcon()
        // Se establece el título
        title = book.title
    }
    
    // Función que modifica el icono de Favorito (Activado/Desactivado) dependiendo de si el Book está marcado como Favorito o no
    func syncFavoriteIcon() {
        favorite.image = book.isFavorite ? UIImage(named: "ic_favorite.png") : UIImage(named: "ic_favorite_border.png")
    }
    
    //MARK: - Actions
    // Función que muestra el fichero PDF asociado al Book
    @IBAction func openPdf(_ sender: UIBarButtonItem) {
    }
    
    // Función palanca que activa/desactiva la propiedad Favorite del Book
    @IBAction func toggleFavorite(_ sender: UIBarButtonItem) {
        // Se cambia la palanca de Favorito. Si no es Favorito se marca como Favorito y viceversa
        book.toggleFavoriteState()
        // Se actualiza el icono de Favorito dependiendo de si el Book está marcado como Favorito o no
        syncFavoriteIcon()
        // Se añade el Book al Tag de Favoritos
        delegate?.bookDidToggleFavoriteState(book: book, isNowFavorite: book.isFavorite)
        // Se almacena la opción de Favorito en NSUserDefauls con la clave HASH del Book
        persistBookFavoriteState()
        
    }
    
    //MARK: - Favorite Handling
    // Función que almacena en NSUserDefaults la información de los Favoritos para que se pueda recuperar si se vuelve a lanzar la App
    func persistBookFavoriteState() {
        UserDefaults.standard.set(book.isFavorite, forKey: String(book.hashValue))
    }
    
    //MARK: - AsyncData Handling
    // Función que se encarga de establecer una imagen de portada por defecto mientras se realiza la descarga de la imagen original
    func syncBookImageData() {
        // Se descarga en segundo plano la Portada del Book. Mientras tanto, se indica una imagen por defecto
        bookImageData = AsyncData(url: book.imageUrl, defaultData: try! Data(contentsOf: BookViewController.defaultImage))
        // Se establece a sí mismo como delegado
        bookImageData.delegate = self
        // Se modifica la imagen del Book con la imagen determinada. En un primer momento es la imagen por defecto
        bookImage.image = UIImage(data: bookImageData.data)
    }
}

//MARK: - Protocols
// Protocolo de Delegado - BookViewControllerDelegate
protocol BookViewControllerDelegate: class {
    func bookDidToggleFavoriteState(book: Book, isNowFavorite: Bool)
}

//MARK: - Delegates
//MARK: LibraryViewControllerDelegate
// Función que se ejecuta cuando en LibraryTableViewController se ha seleccionado una celda
extension BookViewController: LibraryTableViewControllerDelegate {
    func libraryTableViewController(_ sender: LibraryTableViewController, didSelectBook book: Book) {
        self.book = book
        // Se sincroniza la vista de Book para mostrar los datos del Book nuevo
        syncViewWithBook()
    }
}

//MARK: AsyncDataDelegate
// Función que se ejecuta cuando se ha finalizado la descarga de la imagen
extension BookViewController: AsyncDataDelegate {
    func asyncData(_ sender: AsyncData, didEndLoadingFrom url: URL) {
        // Se actualiza la imagen del Book (Portada)
        UIView.transition(with: bookImage,
                          duration: 0.7,
                          options: [.transitionCrossDissolve],
                          animations: {
                            self.bookImage.image = UIImage(data: sender.data)
        }, completion: nil)
    }
}
