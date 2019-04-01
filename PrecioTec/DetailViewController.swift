//
//  ViewController.swift
//  PrecioTec
//
//  Created by Alumno on 3/26/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var metasArray = [Metas]()
    
    
    @IBOutlet weak var tvMetas: UITableView!
    
    var id : String = ""
    var meta : String = ""
    var cantidad : Double = 0
    var tiempo = Date()
    var currentRow : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        RetrieveNewGoals()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return metasArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "metasCell", for: indexPath) as! TableViewCell
        let formateador = DateFormatter()
        formateador.dateStyle = DateFormatter.Style.short
        //Configure the cell
        cell.lbMeta.text = metasArray[indexPath.row].meta
        cell.lbCantidad.text = String(metasArray[indexPath.row].cantidad)
        cell.lbTiempo.text = formateador.string(from: metasArray[indexPath.row].tiempo)
        print("ID:\(metasArray[indexPath.row].id)")
        
        return cell
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Delete the row from the data source
            
            id = metasArray[indexPath.row].id
            let metasDB = Database.database().reference().child("Metas")
            metasDB.child(id).setValue(nil)
            metasArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentRow = indexPath.row
        performSegue(withIdentifier: "editSegue", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let EditVC = segue.destination as! EditViewController
        let indexPath = tvMetas.indexPathForSelectedRow
        if segue.identifier == "editSegue" {
            EditVC.meta = metasArray[indexPath!.row].meta
            EditVC.cantidad = metasArray[indexPath!.row].cantidad
            EditVC.tiempo = metasArray[indexPath!.row].tiempo
        }else {
            EditVC.meta = ""
            EditVC.cantidad = 0
            EditVC.tiempo = Date()
        }
    }
    
    func RetrieveNewGoals() {
        SVProgressHUD.show()
        let metasDB = Database.database().reference().child("Metas")
        metasDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String, Any>
            let task = Metas(id: snapshotValue["id"] as! String,
                            meta: snapshotValue["meta"] as! String,
                            cantidad: snapshotValue["cantidad"] as! Double,
                            tiempo:  snapshotValue["tiempo"] as! Date)
            self.metasArray.append(task)
            self.tvMetas.reloadData()
        }
        SVProgressHUD.dismiss()
    }
}

