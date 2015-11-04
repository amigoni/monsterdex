//
//  ViewController.swift
//  monsterdex
//
//  Created by Leonardo Amigoni on 11/3/15.
//  Copyright © 2015 Mozzarello. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collection: UICollectionView!
    var monsters = [Monster]()
    var inSearchMode = false
    var fileteredMonsters = [Monster]()
    var musicPlayer: AVAudioPlayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.Done
        collection.delegate = self
        collection.dataSource = self
        
        parsePokemonCSV()
        initAudio()
    }
    
    func initAudio (){
        let path = NSBundle.mainBundle().pathForResource("music", ofType: "mp3")!
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOfURL: NSURL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func parsePokemonCSV (){
        //grab the file
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!
        
        //run the parser on it
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            for row in rows {
                let monsterID = Int(row["id"]!)!
                let name = row["identifier"]!
                let monster = Monster(name: name, monsterId: monsterID)
                monsters.append(monster)
            }
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MonsterCollectionViewCell", forIndexPath: indexPath) as? MonsterCollectionViewCell {
            
            let monster: Monster
            
            if inSearchMode {
                monster = fileteredMonsters[indexPath.row]
            }
            else {
                monster = monsters[indexPath.row]
            }
            
            cell.configureCell(monster)

            return cell
            
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        var monster: Monster!
        if inSearchMode {
            monster = fileteredMonsters[indexPath.row]
        } else {
            monster = monsters[indexPath.row]
        }
        
        performSegueWithIdentifier("MonsterDetailVC", sender: monster)
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode {
            return fileteredMonsters.count
        }
        
        return monsters.count
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: 105, height: 105)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MonsterDetailVC" {
            if let detailVC = segue.destinationViewController as? MonsterDetailVC {
                if let monster = sender as? Monster {
                    detailVC.monster = monster
                }
            }
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
        } else {
            inSearchMode = true
            let lower = searchBar.text!.lowercaseString
            fileteredMonsters = monsters.filter({$0.name.rangeOfString(lower) != nil})
        }
        collection.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    
    @IBAction func onMusicButtonPressed(sender: UIButton) {
        if musicPlayer.playing {
            musicPlayer.stop()
            sender.alpha = 0.2
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
}

