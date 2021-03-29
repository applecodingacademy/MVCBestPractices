//
//  Model.swift
//  MVCBestPractices
//
//  Created by Julio César Fernández Muñoz on 28/3/21.
//

import UIKit

extension Notification.Name {
    static let update = Notification.Name("UPDATE")
}

struct Empleados:Codable, Identifiable, Hashable {
    let id:Int
    var first_name:String
    var last_name:String
    var email:String
    var gender:Gender
    var company:String
    var department:Departament
    var jobtitle:String
    var longitude:Double
    var latitude:Double
    var address:String
    var username:String
    var avatar:URL
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum Gender:String, Codable, CaseIterable {
    case agender = "Agender"
    case bigender = "Bigender"
    case female = "Female"
    case genderfluid = "Genderfluid"
    case genderqueer = "Genderqueer"
    case male = "Male"
    case nonBinary = "Non-binary"
    case polygender = "Polygender"
}

enum Departament:String, Codable, CaseIterable {
    case accounting = "Accounting"
    case businessDevelopment = "Business Development"
    case engineering = "Engineering"
    case humanResources = "Human Resources"
    case legal = "Legal"
    case marketing = "Marketing"
    case productManagement = "Product Management"
    case researchAndDevelopment = "Research and Development"
    case sales = "Sales"
    case services = "Services"
    case support = "Support"
    case training = "Training"
}

struct EmpleadosModel {
    var empleados:[Empleados] {
        didSet {
            save()
        }
    }
    
    var numSections:Int {
        Departament.allCases.count
    }
    
    init() {
        guard var url = Bundle.main.url(forResource: "EMPLEADOS", withExtension: "json"),
              let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            empleados = []
            return
        }
        let fichero = documents.appendingPathComponent("EMPLEADOS").appendingPathExtension("json")
        if FileManager.default.fileExists(atPath: fichero.path) {
            url = fichero
        }
        do {
            let json = try Data(contentsOf: url)
            empleados = try JSONDecoder().decode([Empleados].self, from: json)
        } catch {
            print("Error en la carga \(error)")
            empleados = []
        }
    }
    
    func numEmpleadosDpto(numSeccion:Int) -> Int {
        let departmento = Departament.allCases[numSeccion]
        return empleados.filter { $0.department == departmento }.count
    }
    
    func empleadosDpto(departmento:Departament) -> [Empleados] {
        empleados.filter { $0.department == departmento }
    }
    
    func queryEmpleado(indexpath:IndexPath) -> Empleados {
        let departmento = Departament.allCases[indexpath.section]
        let empleados = empleadosDpto(departmento: departmento)
        return empleados[indexpath.row]
    }
    
    func sectionName(section:Int) -> String {
        Departament.allCases[section].rawValue
    }
    
    mutating func deleteEmpleado(indexPath:IndexPath) {
        let empleado = queryEmpleado(indexpath: indexPath)
        empleados.removeAll(where: { $0.id == empleado.id })
    }
    
    mutating func updateEmpleado(empleado:Empleados) {
        guard let index = empleados.firstIndex(where: { $0.id == empleado.id }) else {
            return
        }
        empleados[index] = empleado
    }
    
    func save() {
        guard let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let fichero = documents.appendingPathComponent("EMPLEADOS").appendingPathExtension("json")
        DispatchQueue.global(qos: .background).async {
            do {
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                let jsonData = try encoder.encode(empleados)
                try jsonData.write(to: fichero, options: [.atomicWrite, .completeFileProtection])
            } catch {
                print("Error en la grabación \(error)")
            }
        }
    }
}
