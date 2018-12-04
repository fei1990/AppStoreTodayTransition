//
//  TableViewCell.swift
//  TodayTransition
//
//  Created by wf on 2018/11/30.
//  Copyright © 2018 sohu. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    lazy var imgView: UIImageView = {
        let img = UIImageView()
        img.tag = 999
        return img
    }()
    
    var imgUrl: String! {
        willSet(value) {
            imgView.image = UIImage(named: value)
            imgView.contentMode = .scaleAspectFill
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        addSubview(imgView)
        
        imgView.layer.masksToBounds = true
        imgView.layer.cornerRadius = 10
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imgView.frame = CGRect(x: 20, y: 20, width: frame.width - 40, height: frame.height - 40)
    }
    
    

}
