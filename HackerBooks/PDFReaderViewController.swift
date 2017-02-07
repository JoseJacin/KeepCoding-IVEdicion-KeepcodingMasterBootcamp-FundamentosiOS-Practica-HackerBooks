//
//  PDFReaderViewController.swift
//  HackerBooks
//
//  Created by Jose Sanchez Rodriguez on 7/2/17.
//  Copyright © 2017 Jose Sanchez Rodriguez. All rights reserved.
//

import UIKit

class PDFReaderViewController: UIViewController {
    //MARK: - Constants
    static let PdfMimetype: String = "application/pdf"
    private static let pdfDefault : String = "HackerBooks-PdfDefault.pdf"
    private static let defaultPdfUrl = Bundle.main.url(forResource: pdfDefault)!
    
    //MARK: - Properties
    var bookPdfData: AsyncData // Propiedad AsyncData para el pdf del Book
    
    @IBOutlet weak var pdfReader: UIWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    //MARK: - Initialization
    init(bookPdfUrl: URL) {
        bookPdfData = AsyncData(url: bookPdfUrl, defaultData: try! Data(contentsOf: PDFReaderViewController.defaultPdfUrl))
        super.init(nibName: nil, bundle: nil)
        
        bookPdfData.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    // Función que se ejecuta cuando la vista se va a mostrar.
    // En el ciclo de vida de la vista, esta función puede ejecutarse varias veces
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Se da de alta de las notificaciones
        subscribe()
        
        requestPdf()
        // Se inicia el movimiento del Spinner
        startSpinner()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Se da de baja de las notificaciones
        unsubscribe()
    }
    
    //MARK: - Request Handling
    // Función que recupera
    func requestPdf() {
        pdfReader.load(bookPdfData.data, mimeType: PDFReaderViewController.PdfMimetype, textEncodingName: "", baseURL: Bundle.main.bundleURL)
    }
    
    //MARK: - Activity Indicator Handling
    // Método que se ejecuta cuando el WebViewController va a cargar una URLRequest
    func startSpinner() {
        // Se muestra el spinner
        spinner.isHidden = false
        // Espinearlo (Hacer que se mueva)
        spinner.startAnimating()
    }
    
    // Método que se ejecuta cuando el WebViewController a finalizado la carga de una URLRequest
    func stopSpinner() {
        // Se oculta el spinner
        spinner.isHidden = true
        // Se despinea (Se para la animación)
        spinner.stopAnimating()
    }
    
    //MARK: - AsyncData Handling
    func syncPdfData(bookPdfUrl: URL) {
        bookPdfData = AsyncData(url: bookPdfUrl, defaultData: try! Data(contentsOf: PDFReaderViewController.defaultPdfUrl))
        bookPdfData.delegate = self
        requestPdf()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: - AsyncData Delegate
extension PDFReaderViewController: AsyncDataDelegate {
    func asyncData(_ sender: AsyncData, didEndLoadingFrom url: URL) {
        requestPdf()
        stopSpinner()
    }
}

//MARK: - Notifications
extension PDFReaderViewController {
    func subscribe() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: LibraryTableViewController.notificationName, object: nil, queue: OperationQueue.main, using: { self.bookDidChange($0) })
    }
    
    func unsubscribe() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
    
    func bookDidChange(_ notification: Notification) {
        let newBook = notification.userInfo?[LibraryTableViewController.bookKey] as! Book
        syncPdfData(bookPdfUrl: newBook.pdfUrl)
    }
}
