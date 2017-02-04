//
//  Errors.swift
//  HackerBooks
//
//  Created by Jose Sanchez Rodriguez on 4/2/17.
//  Copyright © 2017 Jose Sanchez Rodriguez. All rights reserved.
//

import Foundation

// Para que se pueda usar como una "excepción" se tiene que usar el protocolo Error
enum BookError : Error {
    case wrongURLFormatForJSONResource // Formato de URL del recurso JSON erróneo
    case resourcePointedByURLNotReachable // Recurso señalado por URL no accesible
    case dataCollectionPointedByURLNotReachable // La colección de datos señalado por URL no accesible
    case wrongJSONFormat // Formato de JSON erróneo
    case nilJSONObject // Objeto JSON nulo
    case jsonParsingError // Error al parsear el JSON
    
}
