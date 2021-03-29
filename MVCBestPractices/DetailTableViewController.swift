//
//  DetailTableViewController.swift
//  MVCBestPractices
//
//  Created by Julio César Fernández Muñoz on 28/3/21.
//

import UIKit

var empleadosModel = EmpleadosModel()

class DetailTableViewController: UITableViewController {
    
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var apellidos: UITextField!
    @IBOutlet weak var email: UITextField!
    
    var empleado:Empleados?
    var indexPath:IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cargaInicial()
    }

    func cargaInicial() {
        if let empleado = empleado {
            nombre.text = empleado.first_name
            apellidos.text = empleado.last_name
            email.text = empleado.email
        }
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        empleado?.first_name = nombre.text ?? ""
        empleado?.last_name = apellidos.text ?? ""
        empleado?.email = email.text ?? ""
        performSegue(withIdentifier: "updateDatos", sender: nil)
    }
}
