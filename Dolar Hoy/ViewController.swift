//
//  ViewController.swift
//  Dolar Hoy
//
//  Created by Arif De Sousa on 4/25/15.
//  Copyright (c) 2015 Arif De Sousa. All rights reserved.
//

import UIKit



class ViewController: UIViewController, JBLineChartViewDataSource, JBLineChartViewDelegate{
    @IBOutlet weak var precioSLabel: LTMorphingLabel!
    @IBOutlet weak var precioDTLabel: LTMorphingLabel!
    @IBOutlet weak var lineChartView: JBLineChartView!
    
    var precioHistory:[[String:AnyObject]]!
        
    private var isDollar = true
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let dataDT = DolarToday()
        
        /*precioDTLabel.morphingEffect = .Fall
        precioSLabel.morphingEffect = .Fall*/
        
        self.precioDTLabel.text = "$\(dataDT.dolarToday)"
        self.precioSLabel.text  = "$\(dataDT.simadi)"
        self.precioHistory = dataDT.history
        
        dataDT.refresh{
            
            self.precioDTLabel.text = "$\(dataDT.dolarToday)"
            self.precioSLabel.text  = "$\(dataDT.simadi)"
            self.precioHistory = dataDT.history
            self.lineChartView.reloadData()
        }
        
        lineChartView.dataSource = self;
        lineChartView.delegate = self;
        
        let porcent = 5.0
        let divide = CGFloat(porcent/100.0)
        
        lineChartView.minimumValue -= lineChartView.minimumValue*divide
        lineChartView.maximumValue += lineChartView.maximumValue*divide
        
        
        
        lineChartView.frame.size.width = lineChartView.superview!.frame.size.width

        lineChartView.reloadData()
        

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        LARSAdController.sharedManager().addAdContainerToViewInViewController(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tappedView(sender: UITapGestureRecognizer) {
        
        let dataDT = DolarToday()
        
        if !isDollar
        {
            self.precioDTLabel.text = "$\(dataDT.dolarToday)"
            self.precioSLabel.text  = "$\(dataDT.simadi)"
            isDollar = true
        }
        else
        {
            self.precioDTLabel.text = NSString(format: "€%.2f", dataDT.dolarToday*dataDT.rate) as String
            self.precioSLabel.text  = NSString(format: "€%.2f", dataDT.simadi*dataDT.rate) as String
            isDollar = false
        }
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        
        return .LightContent
    }
    func numberOfLinesInLineChartView(lineChartView: JBLineChartView!) -> UInt {
        return 1
    }
    
    func lineChartView(lineChartView: JBLineChartView!, numberOfVerticalValuesAtLineIndex lineIndex: UInt) -> UInt {
        return precioHistory != nil ? UInt(precioHistory.count) : 0
    }
    
    func lineChartView(lineChartView: JBLineChartView!, verticalValueForHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        
        let index = Int(horizontalIndex)
        let precio = self.precioHistory[index]["precio"] as! Double
        
        return CGFloat(precio)
    }
    
    func lineChartView(lineChartView: JBLineChartView!, colorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        return UIColor(rgba: "#43A047")
    }

    func lineChartView(lineChartView: JBLineChartView!, widthForLineAtLineIndex lineIndex: UInt) -> CGFloat {
        return 2
    }
    

}

