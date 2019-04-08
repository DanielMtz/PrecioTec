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
import SwiftyJSON
import Alamofire


class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var lbTotal: UILabel!
    @IBOutlet weak var tvMetas: UITableView!
    @IBOutlet weak var sgPesosADolares: UISegmentedControl!
    
    var metasArray = [Metas]()
    var id : String = ""
    var meta : String = ""
    var cantidad : Double!
    var tiempo = Date()
    var currentRow : Int = 0
    var mode : String = ""
    
    let URLFixer = "http://data.fixer.io/api/latest?access_key="
    let keyFixer = "3781356276a8798f7c577f21c96aaaf8"
    let convertFixer = "&symbols=MXN,USD"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        RetrieveNewGoals()
        assignbackground()
        // Do any additional setup after loading the view.
    }
    
    func assignbackground(){
        let background = UIImage(named: "background")
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sumarTotal()
        return metasArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "metasCell", for: indexPath) as! TableViewCell
        //Configure the cell
        cell.lbMeta.text = metasArray[indexPath.row].meta
        cell.lbCantidad.text = String(metasArray[indexPath.row].cantidad)
        cell.lbTiempo.text = metasArray[indexPath.row].tiempo
        print("ID:\(metasArray[indexPath.row].id)")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Delete the row from the data source
            
            id = metasArray[indexPath.row].id
            let metasDB = Database.database().reference().child("Metas")
            metasDB.child(id).setValue(nil)
            metasArray.remove(at: indexPath.row)
            tvMetas.deleteRows(at: [indexPath], with: .fade)
            
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
        let formateador = DateFormatter()
        formateador.dateStyle = DateFormatter.Style.medium
        formateador.timeStyle = DateFormatter.Style.none
        if segue.identifier == "editSegue" {
            mode = "edit"
            EditVC.meta = metasArray[indexPath!.row].meta
            EditVC.cantidad = metasArray[indexPath!.row].cantidad
            EditVC.tiempo = formateador.date(from: metasArray[indexPath!.row].tiempo)!
        }else {
            mode = "add"
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
            let metas = Metas(id: snapshotValue["id"] as! String,
                            meta: snapshotValue["meta"] as! String,
                            cantidad: snapshotValue["cantidad"] as! Double,
                            tiempo: snapshotValue["tiempo"] as! String)
            self.metasArray.append(metas)
            self.tvMetas.reloadData()
        }
        SVProgressHUD.dismiss()
    }
    
    func sumarTotal() {
        var total : Double = 0
        var i : Int = 0
        print(metasArray.count)
        while i < metasArray.count {
            total += metasArray[i].cantidad
            i += 1
        }
        lbTotal.text = String(total)
    }
    
    
    @IBAction func SaveUnwind(unwind : UIStoryboardSegue) {
        let formatter = DateFormatter ( )
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.none
        let metasDB = Database.database().reference().child("Metas")
        if  mode == "add" {
            id = metasDB.childByAutoId().key!
            let metasDirectory =
                ["id": id,
                 "meta": meta,
                 "cantidad": cantidad,
                 "tiempo": formatter.string(from: tiempo)] as [String : Any]
            metasDB.child(id).setValue(metasDirectory)
        } else {
            id = metasArray[currentRow].id
            let metasDirectory =
                ["id": id,
                 "meta": meta,
                 "cantidad": cantidad,
                 "tiempo": formatter.string(from: tiempo)] as [String : Any]
            metasDB.child(id).setValue(metasDirectory)
            metasArray[currentRow].meta = meta
            metasArray[currentRow].cantidad = cantidad
            metasArray[currentRow].tiempo = formatter.string(from: tiempo)
            
            tvMetas.reloadData()
        }
    }
    
    @IBAction func CancelUnwind(unwind : UIStoryboardSegue) {
    }
    
    @IBAction func cambioPesosDolares(_ sender: Any) {
        if sgPesosADolares.selectedSegmentIndex == 0 {
            if let dolares = Double(lbTotal.text!) {
                //          var dolares : Double = pesos / tipoDeCambio
                let finalURL = "\(URLFixer)\(keyFixer)\(convertFixer)"
                print(finalURL)
                Alamofire.request(finalURL, method: .get)
                    .responseJSON { response in
                        //print(finalURL)
                        if response.result.isSuccess {
                            print("Success! Get the conversion")
                            let convertJSON : JSON = JSON(response.result.value!)
                            print(convertJSON)
                            let amountJSON = convertJSON["rates"].dictionaryValue
                            print("hola")
                            print(amountJSON)
                            var fromAmount : Double = 0
                            var toAmount : Double = 0
                            for(key,value) in amountJSON {
                                if key == "USD" {
                                    fromAmount = value.double!
                                } else if key == "MXN" {
                                    toAmount = value.double!
                                }
                            }
                            print(dolares,fromAmount, toAmount)
                            let amountConverted = dolares / fromAmount * toAmount
                            self.lbTotal.text = String(format: "%.2f", amountConverted)
                        } else {
                            print("API not available")
                        }
                }
                //            lbDolares.text = "$ \(dolares) dólares"
            }
            
        }
        else {
            if let pesos = Double(lbTotal.text!) {
                //          var dolares : Double = pesos / tipoDeCambio
                let finalURL = "\(URLFixer)\(keyFixer)\(convertFixer)"
                print(finalURL)
                Alamofire.request(finalURL, method: .get)
                    .responseJSON { response in
                        //print(finalURL)
                        if response.result.isSuccess {
                            print("Success! Get the conversion")
                            let convertJSON : JSON = JSON(response.result.value!)
                            print(convertJSON)
                            let amountJSON = convertJSON["rates"].dictionaryValue
                            print("hola")
                            print(amountJSON)
                            var fromAmount : Double = 0
                            var toAmount : Double = 0
                            for(key,value) in amountJSON {
                                if key == "MXN" {
                                    fromAmount = value.double!
                                } else if key == "USD" {
                                    toAmount = value.double!
                                }
                            }
                            print(pesos,fromAmount, toAmount)
                            let amountConverted = pesos / fromAmount * toAmount
                            self.lbTotal.text = String(format: "%.2f", amountConverted)
                        } else {
                            print("API not available")
                        }
                }
                //            lbDolares.text = "$ \(dolares) dólares"
            }
        }
    }
    
    
}

