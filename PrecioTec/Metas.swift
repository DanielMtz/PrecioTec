//
//  Metas.swift
//  PrecioTec
//
//  Created by Víctor Martínez on 3/31/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//

import UIKit

class Metas: NSObject {

    var id: String = ""
    var meta: String = ""
    var cantidad: Double = 0
    var tiempo : String = ""
    var fecha : String  = ""
    
    
    init(id: String, meta: String, cantidad: Double , tiempo:String, fecha:String){
        self.id = id
        self.meta = meta
        self.cantidad = cantidad
        self.tiempo = tiempo
        self.fecha = fecha
    }
    
}
