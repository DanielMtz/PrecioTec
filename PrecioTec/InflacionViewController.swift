//
//  InflacionViewController.swift
//  
//
//  Created by Hector Escobar on 5/15/19.
//

import UIKit

class InflacionViewController: UIViewController {
    
    @IBOutlet weak var tfInflacion: UITextField!
    @IBOutlet weak var btSave: UIBarButtonItem!
    
    var inflacion : Double = 0.0
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let btn = sender as! UIBarButtonItem
        
        if (btn == btSave) {
            let metasVC = segue.destination as! DetailViewController
            metasVC.inflacion = Double(tfInflacion.text!)!
        }
        defaults.setValue(tfInflacion.text, forKey: "inflacion")
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
