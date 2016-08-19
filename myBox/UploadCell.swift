//
//  UploadCell.swift
//  myBox
//
//  Created by VietHung on 8/13/16.
//  Copyright © 2016 VietHung. All rights reserved.
//

import UIKit

class UploadCell: UITableViewCell {

    var fileSelected: Bool = false
    
    @IBOutlet weak var selection: UIButton!
    @IBOutlet weak var lblFileDate: UILabel!
    @IBOutlet weak var lblFileSize: UILabel!
    @IBOutlet weak var lblFileName: UILabel!
    @IBOutlet weak var imgFileType: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func btnSelect(sender: UIButton) {
        if(fileSelected == false){
            fileSelected = true
            selection.setImage(UIImage(named: "confirm.png"), forState: .Normal)
            print(fileSelected)
        }
        else{
            fileSelected = false
            selection.setImage(UIImage(named: "unconfirm.png"), forState: .Normal)
            print(fileSelected)
        }
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
