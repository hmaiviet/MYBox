//
//  BasicCell.swift
//  myBox
//
//  Created by VietHung on 8/10/16.
//  Copyright © 2016 VietHung. All rights reserved.
//

import UIKit

class BasicCell: UITableViewCell {

    var fileType: UIImageView!
    var fileName: UILabel!
    var fileDate: UILabel!
    var fileSize: UILabel!
    
    @IBOutlet weak var imgFileType: UIImageView!
    @IBOutlet weak var lblFileName: UILabel!
    @IBOutlet weak var lblFileDate: UILabel!
    @IBOutlet weak var labelFileSize: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
