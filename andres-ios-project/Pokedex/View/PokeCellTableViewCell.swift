//
//  PokeCellTableViewCell.swift
//  andres-ios-project
//
//  Created by andres.amavizca on 23/06/25.
//

import UIKit

class PokeCellTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
