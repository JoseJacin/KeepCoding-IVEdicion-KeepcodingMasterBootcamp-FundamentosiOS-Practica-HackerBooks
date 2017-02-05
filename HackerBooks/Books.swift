//
//  Books.swift
//  HackerBooks
//
//  Created by Jose Sanchez Rodriguez on 4/2/17.
//  Copyright © 2017 Jose Sanchez Rodriguez. All rights reserved.
//

import UIKit
import Foundation

//MARK: - Aliases
typealias Author = String // Se crea un alias para Author ya que puede darse el caso de que haya varios autores para el mismo libro

class Book {
    //MARK: - Stored properties (propiedades de instancia)
    let title       :   String
    let authors     :   [Author]
    let tags        :   [Tag]
    let imageUrl    :   URL
    let pdfUrl      :   URL
    private var favorite : Bool = false
    
    //MARK: - Computed Properties (propiedades computadas)
    // Dado que pueden llegar varios elementos tanto de authors como de tags, se unen los elementos en un único string
    var authorsDescription: String {
        get {
            return authors.map({ $0 as String }).joined(separator: ", ")
        }
    }
    
    var tagsDescription: String {
        get {
            return tags.map({ $0.description as String }).joined(separator: ", ")
        }
    }
    
    // Propiedad que retorna si el Book es Favorite o no
    var isFavorite: Bool {
        get {
            return favorite
        }
    }
    
    //MARK: - Initialization
    // Inicializador designado (Si no se indica que es el de conveniencia, es el designado)
    init(title: String,
         authors: [Author],
         tags: [Tag],
         imageUrl: URL,
         pdfUrl: URL,
         isFavorite: Bool) {
        
        //Siempre que la variable de instancia se llame igual que el parámetro del Init, se tiene que usar self para diferenciarlos
        self.title = title
        self.authors = authors
        self.tags = tags
        self.imageUrl = imageUrl
        self.pdfUrl = pdfUrl
        self.favorite = isFavorite
    }
    
    // Inicializador de conveniencia.
    // Se utiliza para:
    // Inicializar el Book con la propiedad de isFavorite a False
    convenience init(title: String,
                     authors: [Author],
                     tags: [Tag],
                     imageUrl: URL,
                     pdfUrl: URL) {
        // Se revisa al inicializador designado
        self.init(title: title,
                  authors: authors,
                  tags: tags,
                  imageUrl: imageUrl,
                  pdfUrl: pdfUrl,
                  isFavorite: false)
    }
    
    // Inicializador de conveniencia.
    // Se utiliza para:
    // Separar en elementos los valores que llegan para authors y tags
    // Obtener la URL desde un String para la imagen y pdf
    convenience init(title: String,
                     authors: String,
                     tags: String,
                     imageUrlString: String,
                     pdfUrlString: String) {
        
        // Se parsea la URL de la imagen del Book
        guard let imageUrl = URL(string: imageUrlString) else {
            // Error al parsear la URL
            fatalError("Error while parsing URL: \(imageUrlString)")
        }
        
        // Se parsea la URL del pdf del Book
        guard let pdfUrl = URL(string: pdfUrlString) else {
            // Error al parsear la URL
            fatalError("Error while parsing URL: \(pdfUrlString)")
        }
        
        // Se revisa al inicializador de conveniencia
        self.init(title: title,
                  authors: authors.components(separatedBy: ", ").flatMap({ $0 as Author }),
                  tags: tags.components(separatedBy: ", ").flatMap({ Tag(rawValue: $0.capitalized) }),
                  imageUrl: imageUrl,
                  pdfUrl: pdfUrl
        )
    }
    
    //MARK: - Utils
    // Función palanca que activa/desactiva la propiedad Favorite del Book
    func toggleFavoriteState() {
        favorite = !favorite
    }
    
    //MARK: - Proxies
    // Proxy para igualdad
    func proxyForEquiality() -> String {
        return "\(title)\(authors)\(tags)\(imageUrl)\(pdfUrl)"
    }
    
    // Proxy para comparación
    func proxyForComparision() -> String {
        return proxyForEquiality()
    }

}

//MARK: - Protocols
// Protocolo de igualdad
extension Book: Equatable {
    public static func ==(lhs: Book, rhs: Book) -> Bool {
        return (lhs.proxyForEquiality() == rhs.proxyForEquiality())
    }
}

// Protocolo de comparación
extension Book: Comparable {
    public static func <(lhs: Book, rhs: Book) -> Bool {
        return (lhs.proxyForComparision() < rhs.proxyForComparision())
    }
}

// Protocolo de representación textual de la instancia
extension Book: CustomStringConvertible {
    public var description: String {
        get {
            return "<Book title:\(title) authors:\(authors) tags:\(tags) coverImageUrl:\(imageUrl) pdfUrl:\(pdfUrl)>"
        }
    }
}

// 
extension Book: Hashable {
    var hashValue: Int {
        get{
            return proxyForEquiality().hashValue
        }
    }
}
