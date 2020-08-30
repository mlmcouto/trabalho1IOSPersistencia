//
//  ConsoleTableViewCell.swift
//  MyGames
//
//  Created by aluno on 29/08/20.
//  Copyright © 2020 CESAR School. All rights reserved.
//

import UIKit

class ConsoleTableViewCell: UITableViewCell {

    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var lbpicture: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    func prepare(with console: Console) {
        lbTitle.text = console.name ?? ""
        //lbConsole.text = console.console?.name ?? ""
        if let image = console.picture as? UIImage {
            lbpicture.image = image
        } else {
            lbpicture.image = UIImage(named: "noCover")
        }
    }
    
    
    
    
}
