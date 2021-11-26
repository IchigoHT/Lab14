//
//  ViewControllerBuscar.swift
//  JSONRESTful
//
//  Created by Eduardo Honores on 11/23/21.
//  Copyright © 2021 empresa. All rights reserved.
//

import UIKit

class ViewControllerBuscar: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Variables
    var peliculas = [Peliculas]()
    
    //Outlets
    @IBOutlet weak var txtBuscar: UITextField!
    
    @IBOutlet weak var tablaPeliculas: UITableView!
    
    
    //Override
    override func viewDidLoad() {
        super.viewDidLoad()
        tablaPeliculas.delegate = self
        tablaPeliculas.dataSource = self
        self.tablaPeliculas.isEditing = true
        setEditing(true, animated: true)
        
        let ruta = "http://localhost:3000/peliculas/"
        cargarPeliculas(ruta: ruta){
            self.tablaPeliculas.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
         let ruta = "http://localhost:3000/peliculas/"
         cargarPeliculas(ruta: ruta) {
             self.tablaPeliculas.reloadData()
         }
     }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueEditar"{
            let siguienteVC = segue.destination as! ViewControllerAgregar
            siguienteVC.pelicula = sender as? Peliculas
        }
    }
    
    //Funciones
    func cargarPeliculas(ruta:String, completed: @escaping () -> ()){
    let url = URL (string: ruta)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
         if error == nil{
             do{
                self.peliculas = try JSONDecoder().decode([Peliculas].self, from: data!)
                 DispatchQueue.main.async {
                       completed ()
                }
             }catch{
                 print ("Error en JSON")
                }
            }
         }.resume ()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peliculas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = "\(peliculas[indexPath.row].nombre)"
        
        cell.detailTextLabel?.text = "Genero:\(peliculas[indexPath.row].genero)Duracion:\(peliculas[indexPath.row].duracion)"
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pelicula = peliculas[indexPath.row]
        performSegue(withIdentifier: "segueEditar", sender: pelicula)
    }
    //Mostrar alerta
    func mostrarAlerta(titulo: String, mensaje: String, accion: String) {
    let alerta = UIAlertController(title: titulo, message: mensaje,
        preferredStyle: .alert)
    let btnOK = UIAlertAction (title: accion, style: .default, handler: nil)
    alerta.addAction(btnOK)
    present (alerta, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
              if editingStyle == .delete {
                  // Delete the row from the data source
                  //tableView.deleteRows(at: [indexPath], with: .fade)
               
               let alerta = UIAlertController(title: "Seguro que quiere eliminar", message:
                   "Eliminar la pelicula \(peliculas[indexPath.row].nombre)",preferredStyle:.alert)
               let Si = UIAlertAction (title: "Si", style: .default, handler:{ (UIAlertAction) in
               
                   self.peliculas.remove(at: indexPath.row)
                   self.tablaPeliculas.reloadData()
                   
               })
               
               let No = UIAlertAction (title: "No", style: .cancel, handler:{ (UIAlertAction) in
                   print("Se cancelo la elimacion de la pelicula")})
               
               alerta.addAction(Si)
               alerta.addAction(No)
               self.present (alerta, animated: true, completion: nil)
               
              } else if editingStyle == .insert {
                  // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
              }
       
          }
    
    
    //Actions
    @IBAction func btnBuscar(_ sender: Any) {
        
        let ruta = "http://localhost:3000/peliculas?"
        let nombre = txtBuscar.text!
        let url = ruta + "nombre_like=\(nombre)"
        let crearURL = url.replacingOccurrences(of:"", with: "%20")
        
        if nombre.isEmpty{
            let ruta = "http://localhost:3000/peliculas/"
            self.cargarPeliculas (ruta: ruta) {
                self.tablaPeliculas.reloadData()
            }
            
        }else{
            cargarPeliculas(ruta: crearURL) {
                if self.peliculas.count <= 0{
                    self.mostrarAlerta(titulo: "Error", mensaje: "No se encontraron coincidencias para : \(nombre)", accion:"cancel")
                }else{
                    self.tablaPeliculas.reloadData()
                }
            }
        }
    }
    
    
    @IBAction func btnSalir(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
}
