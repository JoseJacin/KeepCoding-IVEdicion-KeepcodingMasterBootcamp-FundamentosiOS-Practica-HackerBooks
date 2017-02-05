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
    let cellId : String = "BookCell"
    let bookIcon : String = "HackerBooks-BookIcon"
    
    //MARK: - Properties
    var library : Library
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedBook = library.book(forTag: tag(inSection: indexPath.section), at: indexPath.row) else {
            return
        }
        let bookController = BookViewController(book: selectedBook)
        self.navigationController?.pushViewController(bookController, animated: true)
    }
    
    
    //MARK: - Utils
    // Función que recupera el Tag de la sección
    func tag(inSection section: Int) -> Tag {
        return library.tags[section]
    }
}
