//
//  MonsterCollectionViewCell.swift
//  monsterdex
//
//  Created by Leonardo Amigoni on 11/3/15.
//  Copyright © 2015 Mozzarello. All rights reserved.
//

import UIKit

class MonsterCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var monster: Monster!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
    }
    
    func configureCell(monster: Monster){
        self.monster = monster
        
        nameLabel.text = monster.name.capitalizedString
        thumb.image = UIImage(named: "\(self.monster.monsterId)")
    }
}
