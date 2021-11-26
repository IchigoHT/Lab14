//
//  Users.swift
//  JSONRESTful
//
//  Created by Eduardo Honores on 11/17/21.
//  Copyright © 2021 empresa. All rights reserved.
//

import Foundation

struct Users:Decodable{
    let id:Int
    let nombre:String
    let clave:String
    let email:String
}
