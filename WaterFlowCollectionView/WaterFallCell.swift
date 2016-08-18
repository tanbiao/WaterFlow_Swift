//
//  WaterFallCell.swift
//  collectionView的错位布局
//
//  Created by 西乡流水 on 16/8/15.
//  Copyright © 2016年 西乡流水. All rights reserved.
//

import UIKit

class WaterFallCell: UICollectionViewCell {
    
    @IBOutlet weak var shopImageView: UIImageView!
    
    var shopM : ShopModel?
    {
        didSet{
         
          let url = NSURL.init(string: (shopM?.img)! as String)
            
           dispatch_async(dispatch_get_main_queue()) { 
            
              self.shopImageView.sd_setImageWithURL(url)
            
            }
                
        }
   
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

}
