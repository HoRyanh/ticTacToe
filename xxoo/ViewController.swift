//
//  ViewController.swift
//  xxoo
//
//  Created by Ryanh He on 5/30/16.
//  Copyright © 2016 Ryanh He. All rights reserved.
//
import UIKit

class ViewController: UIViewController {

    @IBOutlet var img1: UIImageView!
    @IBOutlet var img2: UIImageView!
    @IBOutlet var img3: UIImageView!
    @IBOutlet var img4: UIImageView!
    @IBOutlet var img5: UIImageView!
    @IBOutlet var img6: UIImageView!
    @IBOutlet var img7: UIImageView!
    @IBOutlet var img8: UIImageView!
    @IBOutlet var img9: UIImageView!
    
    @IBOutlet var btn1: UIButton!
    @IBOutlet var btn2: UIButton!
    @IBOutlet var btn3: UIButton!
    @IBOutlet var btn4: UIButton!
    @IBOutlet var btn5: UIButton!
    @IBOutlet var btn6: UIButton!
    @IBOutlet var btn7: UIButton!
    @IBOutlet var btn8: UIButton!
    @IBOutlet var btn9: UIButton!
    
    @IBOutlet var resetBtn: UIButton!
    @IBOutlet var userMsg: UILabel!
    
    var plays = Dictionary<Int, Int>()
    var done : Bool = false
    var aiDeciding: Bool = false
    var countWin : Int = 0
    
    @IBAction func uiButtonClicked(sender: UIButton){
        userMsg.hidden = true
        if (plays[sender.tag]==nil && !aiDeciding && !done){
            setImgForSpot(sender.tag, player:1)
        }
        checkForWin()
        aiTurn()
        
    }
    
    @IBAction func resetBtnClicked (sender: UIButton){
        done=false
        resetBtn.hidden=true
        userMsg.hidden=true
        reset()
    
    }
    func reset(){
        plays=[:]
        img1.image=nil
        img2.image=nil
        img3.image=nil
        img4.image=nil
        img5.image=nil
        img6.image=nil
        img7.image=nil
        img8.image=nil
        img9.image=nil
    }
    
    
    func setImgForSpot(spot:Int, player:Int){
        let playerMark = player == 1 ? "x" :"o"
        plays[spot]=player
        
        switch spot{
        case 1: img1.image = UIImage(named: playerMark)
        case 2: img2.image = UIImage(named: playerMark)
        case 3: img3.image = UIImage(named: playerMark)
        case 4: img4.image = UIImage(named: playerMark)
        case 5: img5.image = UIImage(named: playerMark)
        case 6: img6.image = UIImage(named: playerMark)
        case 7: img7.image = UIImage(named: playerMark)
        case 8: img8.image = UIImage(named: playerMark)
        case 9: img9.image = UIImage(named: playerMark)
        default: break
        }
    
    }
    
    func checkForWin(){
        let whoWon = ["I":0,"you":1]
        for(key,value)in whoWon{
            if((plays[1]==value && plays[2]==value && plays[3]==value)||(plays[4]==value && plays[5]==value && plays[6]==value)||(plays[7]==value && plays[8]==value && plays[9]==value)||(plays[1]==value && plays[5]==value && plays[9]==value)||(plays[3]==value && plays[5]==value && plays[7]==value)||(plays[1]==value && plays[4]==value && plays[7]==value)||(plays[2]==value && plays[5]==value && plays[8]==value)||(plays[3]==value && plays[6]==value && plays[9]==value)){
                if value == 1 { countWin+=1 }
                userMsg.hidden = false
                if (countWin <= 1 && value == 1) {
                    userMsg.text = "Yo, not bad huh, you won this. But this gonna be your last win."
                }
                else if(countWin >= 1 && value == 0){
                    userMsg.text = "See, told you, man. try me, sucker~"
                }
                else {
                    userMsg.text = countWin <= 1 && value == 0 ?"Try me, sucker~":"纳尼 unbelievable"
                }
                resetBtn.hidden=false
                done = true

            }
        }
    }
    
    func bottom(value: Int)->(location: String, patten: String){
        return ("bottom", checkFor(value, inList:[7,8,9]))
    }
    func top(value: Int)->(location: String, patten: String){
        return ("top", checkFor(value, inList:[1,2,3]))
    }
    func mid(value: Int)->(location: String, patten: String){
        return ("mid", checkFor(value, inList:[4,5,6]))
    }
    func right(value: Int)->(location: String, patten: String){
        return ("right", checkFor(value, inList:[3,6,9]))
    }
    func left(value: Int)->(location: String, patten: String){
        return ("left", checkFor(value, inList:[1,4,7]))
    }
    func midAcros(value: Int)->(location: String, patten: String){
        return ("midAcros", checkFor(value, inList:[2,5,8]))
    }
    func leftToRight(value: Int)->(location: String, patten: String){
        return ("leftToRight", checkFor(value, inList:[1,5,9]))
    }
    func rightToLeft(value: Int)->(location: String, patten: String){
        return ("rightToLeft", checkFor(value, inList:[3,5,7]))
    }
    
    
    func checkFor(value: Int, inList:[Int])-> String{
        var conclusion = ""
        for cell in inList{
            plays[cell] == value ? (conclusion += "1") : (conclusion += "0")
        }
        return conclusion
    }
    
    func rowCheck(value: Int)->(location: String, patten: String)?{
        let acceptableFinds=["011","101","110"]
        var findFuncs=[top, bottom, mid, right, left, midAcros, leftToRight, rightToLeft]
        for algorthm in findFuncs{
            var algResults = algorthm(value)
            if acceptableFinds.contains(algResults.patten){
                return algResults
            }
        }
        return nil
    }
    
    func isOccupied(whereToPlayResult: Int)->Bool{
        return ((plays[whereToPlayResult] != nil))
    }
    
    
    func aiTurn(){
        if done { return}
        
        aiDeciding = true
        
        if countWin >= 1 {
            if let result = rowCheck(1){
                var whereToPlayResult = whereToPlay(result.location, pattan: result.patten)
                if !isOccupied(whereToPlayResult){
                    setImgForSpot(whereToPlayResult, player: 0)
                    //aiDeciding = false
                    checkForWin()
                    //return
                }
            }

        }
        
        if let result = rowCheck(1){
            var whereToPlayResult = whereToPlay(result.location, pattan: result.patten)
            if !isOccupied(whereToPlayResult){
                setImgForSpot(whereToPlayResult, player: 0)
                aiDeciding = false
                checkForWin()
                return
            }
        }
        
        if let result = rowCheck(0){
            var whereToPlayResult = whereToPlay(result.location, pattan: result.patten)
            if !isOccupied(whereToPlayResult){
                setImgForSpot(whereToPlayResult, player: 0)
                aiDeciding = false
                checkForWin()
                return
            }
        }
        
        if !isOccupied(5){
            setImgForSpot(5, player: 0)
            aiDeciding = false
            checkForWin()
            return
        }
        
        func firstAvailable(isCorner: Bool)-> Int?{
            var spots = isCorner ? [1,3,7,9]:[2,4,6,8]
            for spot in spots{
                if !isOccupied(spot){
                    return spot
                }
            }
            return nil
        }
        
        if let cornerAvailable = firstAvailable(true){
            setImgForSpot(cornerAvailable, player: 0)
            aiDeciding = false
            checkForWin()
            return
        }
        
        if let sideAvailable = firstAvailable(false){
            setImgForSpot(sideAvailable, player: 0)
            aiDeciding = false
            checkForWin()
            return
        }
        
        userMsg.hidden = false
        userMsg.text = countWin >= 1 ? "See, told you, man" : "Unbelievable, we got even!"
        resetBtn.hidden=false
        done = true
        aiDeciding = false
    }
    
    func whereToPlay(location: String, pattan:String)->Int{
        let leftP = "011"
        let rightP = "110"
        let midP = "101"
        
        switch location {
            case "top":
                if pattan == leftP {return 1}
                else if pattan == rightP {return 3}
                else{return 2}
            case "bottom":
                if pattan == leftP {return 7}
                else if pattan == rightP {return 9}
                else{return 8}
            case "mid":
                if pattan == leftP {return 4}
                else if pattan == rightP {return 6}
                else{return 5}
            case "right":
                if pattan == leftP {return 3}
                else if pattan == rightP {return 9}
                else{return 6}
            case "left":
                if pattan == leftP {return 1}
                else if pattan == rightP {return 7}
                else{return 4}
            case "midAcros":
                if pattan == leftP {return 2}
                else if pattan == rightP {return 8}
                else{return 5}
            case "leftToRight":
                if pattan == leftP {return 1}
                else if pattan == rightP {return 9}
                else{return 5}
            case "rightToLeft":
                if pattan == leftP {return 3}
                else if pattan == rightP {return 7}
                else{return 5}
            default: return 1
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

