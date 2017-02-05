//
//  JSONProcessing.swift
//  HackerBooks
//
//  Created by Jose Sanchez Rodriguez on 4/2/17.
//  Copyright © 2017 Jose Sanchez Rodriguez. All rights reserved.
//

import UIKit
import Foundation

// Se "pega" un elemento del JSON para una mejor interpretación de los campos del mismo. Se ha seleccionado un elemento en el que se encuentra
// authors y git con varios elementos cada uno
/*
{
 "authors": "Scott Chacon, Ben Straub",
 "image_url": "http://hackershelf.com/media/cache/b4/24/b42409de128aa7f1c9abbbfa549914de.jpg",
 "pdf_url": "https://progit2.s3.amazonaws.com/en/2015-03-06-439c2/progit-en.376.pdf",
 "tags": "version control, git",
 "title": "Pro Git"
}
*/

//MARK: - Constants
let urlFileJSON : String = "https://t.co/K9ziV0z3SJ"
let nameFileJSON = "books_readable.json"
let bookJSONDataKey = "BookJSONDataKey"

//MARK: - Aliases
// El protocolo AnyObject representa cualquier objeto que sea compatible con Objective C.
typealias JSONObject        = AnyObject;
typealias JSONDictionary    = [String: JSONObject]
typealias JSONArray         = [JSONDictionary]

//MARK: - Decodification
// Función que decodifica un diccionario JSON en un objeto del tipo Books
func decode(book json: JSONDictionary) throws -> Book {
    // Se valida el diccionario
    // Se comprueba el campo authors
    guard let authorsString = json["authors"] as? String else {
        // Erorr. El campo authors es nil
        throw BookError.nilJSONObject
    }
    
    // Se comprueba el campo image_url
    guard let imageURLString = json["image_url"] as? String,
          let imageUrl = URL(string: imageURLString) else {
          // Error. El recurso apuntado por el campo image_url no está accesible
            throw BookError.resourcePointedByURLNotReachable
    }
    
    // Se comprueba el campo pdf_url
    guard let pdfURLString = json["pdf_url"] as? String,
          let pdfUrl = URL(string: pdfURLString) else {
            // Error. El recurso apuntado por el campo image_url no está accesible
            throw BookError.resourcePointedByURLNotReachable
    }
    
    // Se comprueba el campo tag
    guard let tagsString = json["tags"] as? String else {
        // Erorr. El campo tags es nil
        throw BookError.nilJSONObject
    }
    
    // Se comprueba el campo title
    guard let title = json["title"] as? String else {
        // Erorr. El campo title es nil
        throw BookError.nilJSONObject
    }
    
    // Se ha recuperado todo correctamente
    // Se separan los valores de authors y tags en varios elementos.
    let authors = authorsString.components(separatedBy: ", ").flatMap({ $0 as Author })
    let tags = tagsString.components(separatedBy: ", ").flatMap({ $0 as Tag })
    
    // Se retorna el Book
    return Book(title: title,
                authors: authors,
                tags: tags,
                imageUrl: imageUrl,
                pdfUrl: pdfUrl)
}

// Función que decodifica un diccionario opcional JSON en un objeto del tipo Books
func decode(book json: JSONDictionary?) throws -> Book {
    // Se valida que
    guard let json = json else {
        throw BookError.nilJSONObject
    }
    return try decode(book: json)
}

//MARK: - FileManager
// Función que retorna la URL del path Documents
func getMyDocumentsURL() -> URL {
    let sourcePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return sourcePath[0]
}

//MARK: - Download JSON
// Función que descarga el fichero JSON (si aplica) y lo guarda en Local en el path de Documents
func downloadAndSaveJSONFile() throws -> Data {
    // Se comprueba si la aplicación se ha ejecutado anteriormente en algún momento mediante la carga del fichero desde NSUserDefaults
    guard let bookJSONData = UserDefaults.standard.data(forKey: bookJSONDataKey) else {
        // No se ha podido obtener el fichero JSON, por lo que se procede a su descarga
        // Se recupera la URL del JSON
        guard let jsonUrl = URL(string: urlFileJSON) else {
            throw BookError.wrongURLFormatForJSONResource
        }
        
        // Se recupera el JSON referenciado por la URL
        guard let jsonDownloadedData = try? Data(contentsOf: jsonUrl) else {
            throw BookError.dataCollectionPointedByURLNotReachable
        }
        
        // Se almacena el fichero JSON en NSUserDefaults
        UserDefaults.standard.set(jsonDownloadedData, forKey: bookJSONDataKey)
        
        // Se retorna el fichero JSON
        return jsonDownloadedData
    }
    
    // Se ha podido obtener el fichero desde NSUserDefaults
    return bookJSONData
}

//MARK: - Loading JSON from local file (SandBox)
// Función que carga un fichero en local y retorna un array de JSON
func loadJSONFromSandBox() throws -> [Book] {
    do {
        // Se carga el fichero desde NSUserDefauls
        let jsonData = try downloadAndSaveJSONFile()
        
        // Se descarga la información del fichero JSON y se parsea a un array de JSON
        if let maybeArray = try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableLeaves) as? [[String: String]],
            let array = maybeArray {
            // Se ha descargado correctamente el fichero a local y se ha transformado el diccionario JSON a Books
            return array.flatMap({ (dict: [String : String]) -> Book? in
                guard let title: String = dict["title"],
                    let authorsString: String = dict["authors"],
                    let tagsString: String = dict["tags"],
                    let imageUrlString: String = dict["image_url"],
                    let pdfUrlString: String = dict["pdf_url"] else {
                        return nil
                }
                
                // Se ha recuperado todo correctamente
                return Book(title: title,
                            authors: authorsString,
                            tags: tagsString,
                            imageUrlString: imageUrlString,
                            pdfUrlString: pdfUrlString)
            })
        } else {
            // Error. Parseado del fichero JSON
            throw BookError.jsonParsingError
        }
    } catch {
        throw BookError.dataCollectionPointedByURLNotReachable
    }
}
