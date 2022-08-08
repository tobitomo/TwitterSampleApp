//
//  CusttomTableViewCell.swift
//  TwitterSampleApp
//
//  Created by Tomoko Tobita on 2022/08/05.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var recordDate: UILabel!
    @IBOutlet weak var message: UILabel!
    
    
    //storyboardまたはnidファイルからダウンロードした時に呼ばれる
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //選択・通常状態のアニメーション処理をする
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
