//
//  Tag.swift
//  HackerBooks
//
//  Created by Jose Sanchez Rodriguez on 5/2/17.
//  Copyright © 2017 Jose Sanchez Rodriguez. All rights reserved.
//

import Foundation

// Estructura Tag.
struct Tag {
    //MARK: - Static Properties
    private static var favoriteValue: String = "Favorites"
    private static var favoriteInstance: Tag?
    
    // Propiedad que instancia el Tag Favorito
    static var favoriteTag: Tag {
        get {
            // Se comprueba si el Tag se encuentra instanciado
            if (favoriteInstance == nil) {
                // El Tag no se encuentra instanciado se instancia
                favoriteInstance = Tag(rawValue: favoriteValue)
            }
            // Se retorna el Tag ya instanciado
            return favoriteInstance ?? Tag(rawValue: favoriteValue)
        }
    }
    
    //MARK: - Properties
    var rawValue: String
    
    // Propiedad que indica si el Tag iterado es el de Favorito
    var isFavoriteTag: Bool {
        get {
            return rawValue == Tag.favoriteValue
        }
    }
    
    //MARK: - Initialization
    // Inicializador designado (Si no se indica que es el de conveniencia, es el designado)
    init(rawValue: String) {
        self.rawValue = rawValue
    }
}

//MARK: - Protocols
// Protocolo de igualdad
extension Tag: Equatable {
    static func ==(lhs: Tag, rhs: Tag) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

// Protocolo de comparación
extension Tag: Comparable {
    static func <(lhs: Tag, rhs: Tag) -> Bool {
        // Se comprueba si alguno de los Tag pasados es el de Favorito. En ese caso, se no se realiza la comparación y se retorna true/false
        // para que el Favorito siempre sea el menor, y en la ordenación siempre aparezca como el primer elemento
        
        // Se comprueba si el Tag de la "izquierda" es el de Favorito
        if lhs.isFavoriteTag  {
            return true
        }
        
        // Se comprueba si el Tag de la "derecha" es el de Favorito
        if rhs.isFavoriteTag {
            return false
        }
        
        return lhs.rawValue < rhs.rawValue
    }
}

// Protocolo de representación textual de la instancia
extension Tag: CustomStringConvertible {
    var description: String {
        get {
            return rawValue
        }
    }
}

//
extension Tag: Hashable {
    var hashValue: Int {
        get {
            return rawValue.hashValue
        }
    }
}
