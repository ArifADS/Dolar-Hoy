//
//  TodayViewController.swift
//  DolarHoy
//
//  Created by Arif De Sousa on 4/25/15.
//  Copyright (c) 2015 Arif De Sousa. All rights reserved.
//

import UIKit
import NotificationCenter


class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var precioSLabel: UILabel!
    @IBOutlet weak var precioDTLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let dataDT = DolarToday()
        {
            self.precioDTLabel.text = "$\(dataDT.dolarToday)"
            self.precioSLabel.text  = "$\(dataDT.simadi)"
        }
        
        
        
        DolarToday.refresh{
            
            if let dataDT = DolarToday()
            {
                self.precioDTLabel.text = "$\(dataDT.dolarToday)"
                self.precioSLabel.text  = "$\(dataDT.simadi)"
            }
        }
    }

    
    func widgetMarginInsetsForProposedMarginInsets
        (defaultMarginInsets: UIEdgeInsets) -> (UIEdgeInsets) {
            return UIEdgeInsetsZero
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
}
