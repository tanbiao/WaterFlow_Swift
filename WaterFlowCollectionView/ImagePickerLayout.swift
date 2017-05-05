//
//  ImagePickerLayout.swift
//  WaterFlowCollectionView
//
//  Created by 西乡流水 on 17/5/5.
//  Copyright © 2017年 西乡流水. All rights reserved.
//

import UIKit

class ImagePickerLayout: UICollectionViewFlowLayout
{
    let screenW  = UIApplication.shared.keyWindow?.bounds.width
    
    let screenH = UIApplication.shared.keyWindow?.bounds.height
    
    override init() {
        super.init()
       
        setUpInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUpInit()
        
    }
    
    fileprivate func setUpInit ()
    {
        itemSize = CGSize(width: screenW!, height: screenH!)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
    }


}
