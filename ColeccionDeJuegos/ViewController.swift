//
//  ViewController.swift
//  ColeccionDeJuegos
//
//  Created by MAC31 on 17/05/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView:
    UITableView!
    var juegos : [Juego] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        //  tableView.isEditing = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
           try juegos = context.fetch(Juego.fetchRequest())
           tableView.reloadData()
        } catch {

        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return juegos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let juego = juegos[indexPath.row]
        cell.textLabel?.text = juego.titulo
        cell.imageView?.image = UIImage(data: (juego.imagen!))
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let juego = juegos[indexPath.row]
        performSegue(withIdentifier: "juegoSegue", sender: juego)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination as! JuegosViewController
        siguienteVC.juego = sender as? Juego
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                let juego = juegos[indexPath.row]
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                
                context.delete(juego) // Elimina la tarea del contexto de Core Data
                
                do {
                    try context.save() // Guarda los cambios en Core Data
                    juegos.remove(at: indexPath.row) // Elimina la tarea del arreglo local
                    tableView.deleteRows(at: [indexPath], with: .fade) // Elimina la celda de la tabla con animación
                } catch {
                    // Manejo del error al guardar o eliminar la tarea
                    print("Error al guardar o eliminar la tarea: \(error)")
                }
            } else if editingStyle == .insert {
                // Implementa la lógica para el estilo de inserción si es necesario
            }
        }
    
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let objetoMovido = self.juegos[fromIndexPath.row]
        juegos.insert(objetoMovido, at: to.row)
    }
     
    
        

}
    



