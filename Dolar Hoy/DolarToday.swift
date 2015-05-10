//
//  DolarToday.swift
//  Dolar Hoy
//
//  Created by Arif De Sousa on 4/28/15.
//  Copyright (c) 2015 Arif De Sousa. All rights reserved.
//

import Foundation

class DolarToday
{
    var dolarToday:Double!{
        get{
            let ud = NSUserDefaults.standardUserDefaults()
            
            if let price = ud.valueForKey("currentPrices") as? NSData,
               let json = NSJSONSerialization.JSONObjectWithData(price, options: nil, error: nil) as? [String:AnyObject]
            {
                if let precios = json["precios"] as? [[String:AnyObject]]{
                    return precios[0]["precio"] as? Double
                }
            }
            return nil
        }
    }
    
    var simadi:Double!
        {
        get{
            let ud = NSUserDefaults.standardUserDefaults()
            
            if let price = ud.valueForKey("currentPrices") as? NSData,
                let json = NSJSONSerialization.JSONObjectWithData(price, options: nil, error: nil) as? [String:AnyObject]
            {
                if let precios = json["precios"] as? [[String:AnyObject]]{
                    return precios[1]["precio"] as? Double
                }
            }
            return nil
        }
    }
    
    var rate:Double!
        {
        get{
            let ud = NSUserDefaults.standardUserDefaults()
            
            if let price = ud.valueForKey("currentPrices") as? NSData,
                let json = NSJSONSerialization.JSONObjectWithData(price, options: nil, error: nil) as? [String:AnyObject]
            {
                return json["rate"] as? Double
            }
            return nil
        }
    }
    
    var history:[[String:AnyObject]]!{
        
        get{
            let ud = NSUserDefaults.standardUserDefaults()
            if let jsonStr  = ud.valueForKey("precioHistory") as? String,
               let jsonData = jsonStr.dataUsingEncoding(4, allowLossyConversion: true) {
                
                let json = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: nil) as! [[String:AnyObject]]
                
                return json
                
            }
            return nil
        }
        
        
        
    }
    
    init?()
    {
        let ud = NSUserDefaults.standardUserDefaults()
        if let check1 = ud.valueForKey("precioHistory") as? String,
           let check2 = ud.valueForKey("currentPrices") as? NSData
        {
        }
        else
        {
            return nil
        }
        
    }
    
    class func refresh(completion:() -> Void)
    {
        NSOperationQueue().addOperationWithBlock
            {
                let url = NSURL(string: "http://arifads.me/dolarhoy/dolarhoy.php")!
                
                if let preciosData = NSData(contentsOfURL: url)
                {
                    self.saveCurrentPrice(preciosData)
                    let json = NSJSONSerialization.JSONObjectWithData(preciosData, options: nil, error: nil) as! [String:AnyObject]
                }
                
                
                let urlHistory = NSURL(string: "http://arifads.me/dolarhoy/getHistory.php")!
                if let preciosHistory = NSString(contentsOfURL: urlHistory, encoding: 4, error: nil){
                    
                    self.savePriceHistory(preciosHistory as! String)
                }

                NSOperationQueue.mainQueue().addOperationWithBlock(completion)
        }
    }
    
    private class func saveCurrentPrice(newValue:NSData){
        
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setValue(newValue, forKey: "currentPrices")
        
    }
    
    private class func savePriceHistory(newValue:String)
    {
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setValue(newValue, forKey: "precioHistory")
    }
}
