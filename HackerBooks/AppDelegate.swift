//
//  AppDelegate.swift
//  HackerBooks
//
//  Created by Jose Sanchez Rodriguez on 3/2/17.
//  Copyright © 2017 Jose Sanchez Rodriguez. All rights reserved.
//

import UIKit
import CoreData


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    // Función que se ejecuta cuando la aplicación se ha abierto 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        do {
            // UITableViewController
            // Se cargan los libros y se crea el modelo de datos
            let library = try Library(books: loadJSONFromSandBox())
            // Se crea un controlador UITableViewController (libraryTableViewController)
            let libraryTableViewController = LibraryTableViewController(library: library)
            // Se mete el controlador libraryTableViewController dentro de un UINavigationController (libraryNavigationController)
            let libraryNavigationController = UINavigationController(rootViewController: libraryTableViewController)
            
            // UIViewController
            // Se carga el primer elemento del primer tag de la librería
            let firstBook = initBook(library: library)
            // Se crea un controlador UITableViewController (bookViewController)
            let bookViewController = BookViewController(book: firstBook)
            // Se mete el controlador libraryTableViewController dentro de un UINavigationController (libraryNavigationController)
            let bookNavigationController = UINavigationController(rootViewController: bookViewController)
            
            //UISplitViewController
            // Se crea un controlador UISplitViewController
            let splitViewController = UISplitViewController()
            // Se añaden los dos UINavigationController
            splitViewController.viewControllers = [libraryNavigationController, bookNavigationController]
            
            // Se establecen los delegados dependiendo del dispositivo en el que se ejecute la App
            switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                // Caso en el que el dispositivo es un iPhone
                // MARK: - TODO
                // Se tiene que implementar la funcionalidad para que detecte la orientación del dispositivo.
                // Actualmente está configurado para el modo portait. Para el modo landscape
                libraryTableViewController.delegate = bookViewController // Comentar para modo portait. Descomentar para modo landscape
                bookViewController.delegate = libraryTableViewController
                //libraryTableViewController.delegate = libraryTableViewController // Desomentar para modo portait. Comentar para modo landscape
            case .pad:
                // Caso en el que el dispositivo es un iPad
                libraryTableViewController.delegate = bookViewController
                bookViewController.delegate = libraryTableViewController
            default:
                fatalError("Failed to boot to an unsupported device")
            }
            
            // Se indica a Window cuál es el NavigationController que tiene que mostrar
            self.window?.rootViewController = splitViewController
            // Se muestra la window y se hace que tenga el foco
            self.window?.makeKeyAndVisible()
            return true
        } catch {
            fatalError("Error in book collection")
        }
    }

    //MARK: - Utils
    func initBook(library: Library) -> Book {
        return library.book(forTag: library.tags.first!, at: 0)!
    }
}

