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
    var tiempo = Date()
    
    
    init(id: String, meta: String, cantidad: Double, tiempo:Date){
        self.id = id
        self.meta = meta
        self.cantidad = cantidad
        self.tiempo = tiempo
    }
    
}
