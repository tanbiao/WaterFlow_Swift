//
//  ImagePickerCell.swift
//  WaterFlowCollectionView
//
//  Created by 西乡流水 on 17/5/5.
//  Copyright © 2017年 西乡流水. All rights reserved.
//

import UIKit

class ImagePickerCell: UICollectionViewCell,Reusable {
    
    //重写协议里面的属性
    static var nib: UINib?
        {
        return  UINib(nibName: "\(self)", bundle: nil)
    }
    
    var shop :ShopModel?
        {
        didSet {
            
            guard let url = URL(string: shop!.img) else {
                return
            }
           
            DispatchQueue.main.async {
                
                self.imageView.sd_setImage(with: url)
            }
            
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
