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
typealias Author = [String] // Se crea un alias para Author ya que puede darse el caso de que haya varios autores para el mismo libro
typealias Tag = [String] // Se crea un alias para Tag ya que puede darse el caso de que haya varios tag para el mismo libro

class Book {
    //MARK: - Stored properties (propiedades de instancia)
    let title       :   String
    let authors     :   Author
    let tags        :   Tag
    let image_url   :   URL
    let pdf_url     :   URL
    
    //MARK: - Computed Properties
    // Actualmente no se han detectado propiedades computadas
    
    //MARK: - Initialization
    // Inicializador designado (Si no se indica que es el de conveniencia, es el designado)
    init(title: String,
         authors: Author,
         tags: Tag,
         image_url: URL,
         pdf_url: URL) {
        
        //Siempre que la variable de instancia se llame igual que el parámetro del Init, se tiene que usar self para diferenciarlos
        self.title = title
        self.authors = authors
        self.tags = tags
        self.image_url = image_url
        self.pdf_url = pdf_url
    }
    
    //MARK: - Proxies
    // Proxy para igualdad
    func proxyForEquiality() -> String {
        return "\(title)\(authors)\(tags)\(image_url)\(pdf_url)"
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
