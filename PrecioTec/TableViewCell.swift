//
//  TableViewCell.swift
//  PrecioTec
//
//  Created by Víctor Martínez on 3/31/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbMeta: UILabel!
    @IBOutlet weak var lbTiempo: UILabel!
    @IBOutlet weak var lbCantidad: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
