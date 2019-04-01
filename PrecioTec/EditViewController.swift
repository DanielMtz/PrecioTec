//
//  EditViewController.swift
//  PrecioTec
//
//  Created by Alumno on 3/29/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
    
    @IBOutlet weak var tfMeta: UITextField!
    @IBOutlet weak var tfCantidad: UITextField!
    @IBOutlet weak var tfTiempo: UITextField!
    
    var meta : String = ""
    var cantidad : Double = 0
    var tiempo = Date()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
