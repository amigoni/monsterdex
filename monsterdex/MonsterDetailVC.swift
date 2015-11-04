//
//  MonsterDetailVC.swift
//  monsterdex
//
//  Created by Leonardo Amigoni on 11/3/15.
//  Copyright © 2015 Mozzarello. All rights reserved.
//

import UIKit

class MonsterDetailVC: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var monsterIdLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var baseAttackLabel: UILabel!
    @IBOutlet weak var evoLabel: UILabel!
    @IBOutlet weak var currentEvoImage: UIImageView!
    @IBOutlet weak var nextEvoImage: UIImageView!
    
    var monster: Monster!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = monster.name.capitalizedString
        let image = UIImage(named: "\(monster.monsterId)")
        mainImage.image = image
        currentEvoImage.image = image
        
        descriptionLabel.text = ""
        typeLabel.text = ""
        defenseLabel.text = ""
        heightLabel.text = ""
        monsterIdLabel.text = ""
        weightLabel.text = ""
        baseAttackLabel.text = ""
        
        
        monster.downloadMonsterDetails { () -> () in
            self.updateUI()
        }
        
    }
    
    func updateUI(){
        descriptionLabel.text = monster.description
        typeLabel.text = monster.type
        defenseLabel.text = monster.defense
        heightLabel.text = monster.height
        monsterIdLabel.text = "\(monster.monsterId)"
        weightLabel.text = monster.weight
        baseAttackLabel.text = monster.attack
       
        if monster.nextEvolutionId == "" {
            evoLabel.text = "No Evolutions"
            nextEvoImage.image = nil
            nextEvoImage.hidden = true
        } else {
            var str = "Next Evolution: \(monster.nextEvolutionText)"
            
            if monster.nextEvolutionLevel != "" {
                str += " - LVL\(monster.nextEvolutionLevel)"
            }
            evoLabel.text = str
            nextEvoImage.image = UIImage(named: monster.nextEvolutionId)
            nextEvoImage.hidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
