//
//  Peliculas.swift
//  JSONRESTful
//
//  Created by Eduardo Honores on 11/23/21.
//  Copyright © 2021 empresa. All rights reserved.
//

import Foundation

struct  Peliculas:Decodable {
    let usuarioId:Int
    let id:Int
    let nombre:String
    let genero:String
    let duracion:String
}
