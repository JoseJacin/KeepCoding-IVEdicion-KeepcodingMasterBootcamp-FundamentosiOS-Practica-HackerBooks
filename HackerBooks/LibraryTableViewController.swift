//
//  LibraryTableViewController.swift
//  HackerBooks
//
//  Created by Jose Sanchez Rodriguez on 4/2/17.
//  Copyright © 2017 Jose Sanchez Rodriguez. All rights reserved.
//

import UIKit

class LibraryTableViewController: UITableViewController {
    
    //MARK: - Constants
    let navigationTitle : String = "Hacker Books"
    let bookIcon : String = "HackerBooks-BookIcon.png"
    let cellId : String = "BookCell"
    
    //MARK: - Properties
    var library : Library
    weak var delegate: LibraryTableViewControllerDelegate? = nil
    
    //MARK: - Computed Properties
    // Propiedad que recupera la URL a la imagen por defecto de la portada del Book
    var defaultBookImageData: Data {
        get {
            let defaultImageUrl = Bundle.main.url(forResource: bookIcon)!
            return try! Data(contentsOf: defaultImageUrl)
        }
    }
    
    //MARK: - Initialization
    init(library: Library) {
        self.library = library
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = navigationTitle
    }

    // MARK: - Table view data source
    // Función que establece el número de secciones que tendrá la LibraryTableViewController
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Se recupera el número de tags que se encuentran en la Librería
        return library.tagCount
    }
    
    // Función que establece el número de celdas que tendrá cada sección de la LibraryTableViewController
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Se recupera el número de Books que tiene cada Tag
        return library.bookCount(forTag: tag(inSection: section))
    }
    
    // Función que establece el nombre de cada sección de la LibraryTableViewController
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Se recupera el tag de la sección y se pone en mayúscula la letra capital
        return tag(inSection: section).description.capitalized as String
        //return tagContent.capitalized
    }
    
    // Función que inicializa las celdas de la LibraryTableViewController
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Se averigua cuál es el Book iterado
        let book = library.book(forTag: tag(inSection: indexPath.section), at: indexPath.row)
        // Se crea la celda. Si ya existe la celda, se reutiliza, sino, se crea desde cero
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        
        // Se configura la celda recién creada
        cell.imageView?.image = UIImage(named: bookIcon) // Se establece la imagen por defecto de la celda
        cell.textLabel?.text = book?.title // Se establece el título de la celda con el título del Book
        cell.detailTextLabel?.text = book?.authorsDescription // Se establece el detalle de la celda con la descripción de los Authors del Book
        
        // Se retorna la celda recién configurada
        return cell
    }
    
    // Función que se ejecuta cuando se ha pulsado en una celda
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedBook = library.book(forTag: tag(inSection: indexPath.section), at: indexPath.row) else {
            return
        }
        delegate?.libraryTableViewController(self, didSelectBook: selectedBook)
    }
    
    //MARK: - Utils
    // Función que recupera el Tag de la sección
    func tag(inSection section: Int) -> Tag {
        return library.tags[section]
    }
}

//MARK: - Protocols
// Protocolo de Delegado - LibraryTableViewControllerDelegate
protocol LibraryTableViewControllerDelegate: class {
    func libraryTableViewController(_ sender: LibraryTableViewController, didSelectBook book: Book)
}

//MARK: - Delegates
//MARK: LibraryTableViewControllerDelegate
// Función que se ejecuta cuando en LibraryTableViewController se ha seleccionado una celda
extension LibraryTableViewController: LibraryTableViewControllerDelegate {
    func libraryTableViewController(_ sender: LibraryTableViewController, didSelectBook book: Book) {
        let bookController = BookViewController(book: book)
        bookController.delegate = self
        navigationController?.pushViewController(bookController, animated: true)
    }
}

//MARK: - BookViewControllerDelegate
// Función que se ejecuta cuando en BookViewController se ha marcado/desmarcado un Book como Favorito
extension LibraryTableViewController: BookViewControllerDelegate {
    func bookDidToggleFavoriteState(book: Book, isNowFavorite: Bool) {
        // Se comprueba si se ha marcado o desmarcado el Book como Favorito
        if (isNowFavorite) {
            // Se añade el Book al Tag Favoritos
            library.addBookToFavorites(book)
        } else {
            // Se elimina el Book del Tag Favoritos
            library.removeBookFromFavorites(book)
        }
        
        // Se recarga la información de la tabla para que se actualice la sección Favorites
        self.tableView.reloadData()
    }
}
