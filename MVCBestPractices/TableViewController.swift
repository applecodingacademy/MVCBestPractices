//
//  TableViewController.swift
//  MVCBestPractices
//
//  Created by Julio César Fernández Muñoz on 28/3/21.
//

import UIKit

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.clearsSelectionOnViewWillAppear = false
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        NotificationCenter.default.addObserver(forName: .update, object: nil, queue: .main) { notification in
            guard let indexPath = notification.object as? IndexPath else {
                return
            }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        empleadosModel.numSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        empleadosModel.numEmpleadosDpto(numSeccion: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "zelda", for: indexPath)
        let empleado = empleadosModel.queryEmpleado(indexpath: indexPath)
        cell.textLabel?.text = "\(empleado.last_name), \(empleado.first_name)"
        cell.detailTextLabel?.text = "\(empleado.email)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        empleadosModel.sectionName(section: section)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            empleadosModel.deleteEmpleado(indexPath: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    @IBAction func salida(_ segue:UIStoryboardSegue) {
        guard segue.identifier == "updateDatos",
              let source = segue.source as? DetailTableViewController,
              let empleado = source.empleado,
              let indexPath = source.indexPath else {
            return
        }
        empleadosModel.updateEmpleado(empleado: empleado)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "detalleEmpleado",
              let destination = segue.destination as? DetailTableViewController,
              let cell = sender as? UITableViewCell,
              let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        let empleado = empleadosModel.queryEmpleado(indexpath: indexPath)
        destination.empleado = empleado
        destination.indexPath = indexPath
    }
}
