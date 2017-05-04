//
//  ShopModel.swift
//  WaterFlowCollectionView
//
//  Created by 西乡流水 on 16/8/16.
//  Copyright © 2016年 西乡流水. All rights reserved.
//

import UIKit

class ShopModel: NSObject {
    
    var w : CGFloat = 0.0
    
    var h : CGFloat = 0.0
    
    var img : NSString = ""
    
    var price : NSString = ""
    
    
    init(dict:[String : AnyObject])
    {
     super.init()
        
     setValuesForKeys(dict)
    
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String)
    {
        
    }
    
 
}
