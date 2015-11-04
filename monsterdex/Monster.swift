//
//  Monster.swift
//  monsterdex
//
//  Created by Leonardo Amigoni on 11/3/15.
//  Copyright © 2015 Mozzarello. All rights reserved.
//

import Foundation
import Alamofire

class Monster {
    private var _name: String!
    private var _monsterId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionText: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLevel: String!
    private var _monsterUrl: String!
    
    var name: String {
        return _name
    }
    
    var monsterId: Int {
        return _monsterId
    }
    
    var description: String {
        get {
            if _description == nil {
                return ""
            } else {
                return _description
            }
        }
    }
    
    var type: String {
        get {
            if _type == nil {
                return ""
            } else {
                return _type
            }
        }
    }
    
    var defense: String {
        get {
            if _defense == nil {
                return ""
            } else {
                return _defense
            }
        }
    }
    
    var height: String {
        get {
            if _height == nil {
                return ""
            } else {
                return _height
            }
        }
    }
    
    var weight: String {
        get {
            if _weight == nil {
                return ""
            } else {
                return _weight
            }
        }
    }
    
    var attack: String {
        get {
            if _attack == nil {
                return ""
            } else {
                return _attack
            }
        }
    }
    
    var nextEvolutionText: String{
        get {
            if _nextEvolutionText == nil {
                return ""
            } else {
                return _nextEvolutionText
            }
        }
    }
    
    var nextEvolutionId: String {
        get {
            if _nextEvolutionId == nil {
                return ""
            } else {
                return _nextEvolutionId
            }
        }
    }
    
    var nextEvolutionLevel: String {
        get {
            if _nextEvolutionLevel == nil {
                return ""
            } else {
                return _nextEvolutionLevel
            }
        }
    }
    
    var monsterUrl: String {
        get {
            if _monsterUrl == nil {
                return ""
            } else {
                return _monsterUrl
            }
        }
    }
    
    init(name: String, monsterId: Int){
        _name = name
        _monsterId = monsterId
        _monsterUrl = "\(URL_BASE)\(URL_MONSTER)\(monsterId)/"
    }
    
    func downloadMonsterDetails(completed: DownloadComplete){
        let url = NSURL(string: _monsterUrl)!
        Alamofire.request(.GET, url).responseJSON {response in
            let result = response.result
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let weight = dict["weight"] as? String{
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String{
                    self._height = height
                }
                
                if let defense = dict["defense"] as? Int{
                    self._defense = "\(defense)"
                }
                
                if let attack = dict["attack"] as? Int{
                    self._attack = "\(attack)"
                }
                
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0 {
                    
                    if let typeName = types[0]["name"] {
                        self._type = typeName.capitalizedString
                    }
                    
                    if types.count > 1 {
                        for var x = 1; x < types.count; x++ {
                            if let name = types[x]["name"] {
                                self._type! += "/\(name.capitalizedString)"
                            }
                        }
                    } else {
                        self._type = ""
                    }
                }
                
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] where descArr.count > 0 {
                    if let url = descArr[0]["resource_uri"] {
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                        print(nsurl)
                        
                        Alamofire.request(.GET, nsurl).responseJSON {response in
                            if let resultDict = response.result.value as? Dictionary<String,AnyObject> {
                                if let descText = resultDict["description"] as? String {
                                   self._description = descText
                                }
                            }
                            completed()
                        }
                    }
                } else {
                    self._description = ""
                }
                
                if let evolutionsArr = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutionsArr.count > 0 {
                    if let to = evolutionsArr[0]["to"] as? String {
                        //Can't support Mega
                        if to.rangeOfString("mega") == nil {
                            if let uri = evolutionsArr[0]["resource_uri"] as? String {
                                let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                
                                let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                
                                self._nextEvolutionId = num
                                self._nextEvolutionText = to
                                
                                if let level = evolutionsArr[0]["level"] as? Int {
                                   self._nextEvolutionLevel = "\(level)"
                                }
                                
                                print(self._nextEvolutionLevel)
                                print(self._nextEvolutionId)
                                print(self._nextEvolutionText)
                            }
                        }
                    }
                }
            }
        }
    }
    
}