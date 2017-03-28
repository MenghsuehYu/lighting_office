//
//  TableViewCellForScene.swift
//  LightingOfficeBleController
//
//  Created by lighting on 2017/3/21.
//  Copyright © 2017年 ROE. All rights reserved.
//

import UIKit

class TableViewCellForScene: UITableViewCell {
    
    @IBOutlet weak var mSwitch: UISwitch!
    @IBOutlet weak var mTitle: UILabel!
    @IBOutlet weak var mIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
