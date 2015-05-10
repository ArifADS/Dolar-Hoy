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
    var dolarToday:Double!
        {
        get{
            let ud = NSUserDefaults.standardUserDefaults()
            return ud.valueForKey("precioDolarToday") as? Double
        }
        
        set{
            let ud = NSUserDefaults.standardUserDefaults()
            ud.setValue(newValue, forKey: "precioDolarToday")
        }
    }
    
    var simadi:Double!
        {
        get{
            let ud = NSUserDefaults.standardUserDefaults()
            return ud.valueForKey("precioSIMADI") as? Double
        }
        
        set{
            let ud = NSUserDefaults.standardUserDefaults()
            ud.setValue(newValue, forKey: "precioSIMADI")
        }
    }
    
    var rate:Double!
        {
        get{
            let ud = NSUserDefaults.standardUserDefaults()
            return ud.valueForKey("rate") as? Double
        }
        
        set{
            let ud = NSUserDefaults.standardUserDefaults()
            ud.setValue(newValue, forKey: "rate")
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
    
    func refresh(completion:() -> Void)
    {
        NSOperationQueue().addOperationWithBlock
            {
                let url = NSURL(string: "http://arifads.me/dolarhoy/dolarhoy.php")!
                let preciosData = NSData(contentsOfURL: url)
                
                let urlHistory = NSURL(string: "http://arifads.me/dolarhoy/getHistory.php")!
                let preciosHistory = NSString(contentsOfURL: urlHistory, encoding: 4, error: nil)
                
                let ud = NSUserDefaults.standardUserDefaults()
                ud.setValue(preciosHistory, forKey: "precioHistory")
                
                
                let json = NSJSONSerialization.JSONObjectWithData(preciosData!, options: nil, error: nil) as! [String:AnyObject]
                
                self.rate = json["rate"] as! Double
                
                let precios = json["precios"] as! [[String:AnyObject]]
                
                
                self.dolarToday = precios[0]["precio"] as! Double
                self.simadi     = precios[1]["precio"] as! Double
                
                NSOperationQueue.mainQueue().addOperationWithBlock(completion)
        }
    }
}
