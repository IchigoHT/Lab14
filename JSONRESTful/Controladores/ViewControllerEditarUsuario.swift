//
//  ViewControllerEditarUsuario.swift
//  JSONRESTful
//
//  Created by Eduardo Honores on 11/25/21.
//  Copyright © 2021 empresa. All rights reserved.
//

import UIKit

class ViewControllerEditarUsuario: UIViewController {

    
    //Outlets
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //Funciones
    func metodoPUTusuario (ruta:String, datos:[String:Any]) {
              let url : URL = URL(string: ruta)!
              var request = URLRequest(url: url)
              let session = URLSession.shared
              request.httpMethod = "PUT"
              // this is your input parameter dictionary
              let params = datos
              do{
                  request.httpBody = try JSONSerialization.data(withJSONObject: params, options:
                  JSONSerialization.WritingOptions.prettyPrinted)
              }
              catch{
              // catch any exception here
              }
              request.addValue("application/json", forHTTPHeaderField: "Content-Type")
              request.addValue("application/json", forHTTPHeaderField: "Accept")
              
              let task = session.dataTask (with: request, completionHandler: {(data, response, error)
                  in
                  if (data != nil)
                  {
                      do{
                          let dict = try JSONSerialization.jsonObject(with: data!, options:
                              JSONSerialization.ReadingOptions.mutableLeaves)
                          print(dict);
                      }
                      catch
                      {
                          // catch any exception here
                      }
                  }
              })
              task.resume ()
          }
    
    
    //Actions
    
    @IBAction func btnEditarUsuario(_ sender: Any) {
        let nombre = txtNombre.text!
               let email = txtEmail.text!
               let password = txtPassword.text!
               let datos = ["nombre": "\(nombre)", "email": "\(email)", "clave":
                   "\(password)"] as Dictionary<String, Any>
               
               let ruta = "http://localhost:3000/usuarios/1"
               metodoPUTusuario(ruta: ruta, datos: datos)
               navigationController?.popViewController(animated: true)
        
    }
    
}
