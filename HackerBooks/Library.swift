//
//  Library.swift
//  HackerBooks
//
//  Created by Jose Sanchez Rodriguez on 4/2/17.
//  Copyright © 2017 Jose Sanchez Rodriguez. All rights reserved.
//

import Foundation

class Library {
    //MARK: - Properties
    // Multidiccionary con la clave Tag y el elemento Books
    var books = MultiDictionary<Tag, Book>()
    
    //MARK: - Computed Properties (propiedades computadas)
    // Propiedad que cuenta los Books que hay de forma única en el diccionario
    var bookCount: Int {
        get {
            return books.countUnique
        }
    }
    
    // Propiedad que recupera y ordena los Tag que se encuentran en el Diccionario
    var tags: [Tag] {
        get {
            var tags: [Tag] = []
            for tag in books.keys.sorted() {
                tags.append(tag)
            }
            return tags
        }
    }
    
    // Propiedad que retorna el número de Tag que se encuentran en el Diccionario
    var tagCount: Int {
        get {
            return books.keys.count
        }
    }
    
    //MARK: - Initialization
    init(books: [Book]) {
        for book in books {
            for tag in book.tags {
                self.books.insert(value: book, forKey: tag)
            }
        }
    }
    
    //MARK: - Data Retrieval
    // Función que retorna los Books ordenados que se encuentran en un determinado Tag
    func books(forTag tag: Tag) -> [Book]? {
        if let bookCollection = books[tag] {
            return Array(bookCollection).sorted()
        } else {
            return nil
        }
    }
    
    // Función que cuenta los Books que se encuentran en un determinado Tag
    func bookCount(forTag tag: Tag) -> Int {
        return books(forTag: tag)?.count ?? 0
    }
    
    // Función que retorna un Book determinado indicándole el Tag al que pertenece y la posición dentro del Tag
    func book(forTag tag: Tag, at: Int) -> Book? {
        if let bookCollection = books(forTag: tag) {
            return bookCollection[at]
        } else {
            return nil
        }
    }
}
