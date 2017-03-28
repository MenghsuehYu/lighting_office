//
//  TableViewCellForBleDevice.swift
//  LightingOfficeBleController
//
//  Created by lighting on 2017/3/27.
//  Copyright © 2017年 ROE. All rights reserved.
//

import UIKit

class TableViewCellForBleDevice: UITableViewCell {

    @IBOutlet weak var mText: UILabel!
    @IBOutlet weak var mActivityIndicator: UIActivityIndicatorView!
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
