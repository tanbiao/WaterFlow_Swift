//
//  ViewController.swift
//  WaterFlowCollectionView
//
//  Created by 西乡流水 on 16/8/16.
//  Copyright © 2016年 西乡流水. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //git test
    }
    
    
    @IBAction func btnClick(_ sender: AnyObject) {
        
        let waterVC = WaterFlowViewController()
        
        navigationController?.pushViewController(waterVC, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

