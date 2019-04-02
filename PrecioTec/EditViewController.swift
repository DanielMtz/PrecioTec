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
    @IBOutlet weak var btSave: UIBarButtonItem!
    
    
    var meta : String = ""
    var cantidad : Double!
    var tiempo = Date()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tfMeta.text = meta
        tfCantidad.text = String(cantidad)
        //tfTiempo.text = String(tiempo)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(RemoveKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func RemoveKeyboard() {
        view.endEditing(true)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let btn = sender as! UIBarButtonItem
        
        if (btn == btSave) {
            let metasVC = segue.destination as! DetailViewController
            metasVC.meta = tfMeta.text!
            metasVC.cantidad = Double(tfCantidad.text!)
            //metasVC.tiempo = Date(tfTiempo.text!)
        }
    }

}
