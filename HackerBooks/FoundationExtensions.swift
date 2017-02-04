//
//  FoundationExtensions.swift
//  HackerBooks
//
//  Created by Jose Sanchez Rodriguez on 4/2/17.
//  Copyright © 2017 Jose Sanchez Rodriguez. All rights reserved.
//

import Foundation

// Extensión sobre Bundle
extension Bundle {
    // Función "url" extendida que recibe una cadena con el nombre del fichero (nombre.ext) y retorna la URL completa con
    // la ubicación del archivo
    func url(forResource name: String) -> URL? {
        // Se parte el nombre por el punto (.)
        let tokens = name.components(separatedBy: ".")
        
        // Si sale bien, Se crea la url
        return url(forResource: tokens[0], withExtension: tokens[1])
    }
}
