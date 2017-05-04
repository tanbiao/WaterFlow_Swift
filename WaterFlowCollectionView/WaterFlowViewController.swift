//
//  WaterFlowViewController.swift
//  WaterFlowCollectionView
//
//  Created by 西乡流水 on 16/8/16.
//  Copyright © 2016年 西乡流水. All rights reserved.
//

import UIKit

class WaterFlowViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,WaterflowLayoutDelegate {
    
    let waterCellID = "WaterFallCell"
    
    var  dataArr = [ShopModel]()
    
    var collectionView: UICollectionView?
    
    var indexC : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupInit()
        
        setupRefresh()
         
    }
    
    func setupRefresh()
    {
        weak var weakSelf = self
        collectionView?.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { 
            
            weakSelf!.loadNewData()
        })
        
        collectionView?.mj_header.beginRefreshing()
        
        collectionView?.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: { 
            
            weakSelf!.loadMoreData()
        })
        
    }
    
    func loadNewData()
    {
        weak var weakSelf = self
        
        let delayTime = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            
            let filePath = Bundle.main.path(forResource: "1.plist", ofType: nil)
            
            let arr = NSMutableArray.init(contentsOfFile: filePath!)!            
            var shops  = [ShopModel]()
            
            for dict in arr {
                
                let shopM = ShopModel.init(dict: dict as! [String : AnyObject])
                
                shops.append(shopM)
            }
            
            weakSelf!.dataArr = shops
            weakSelf!.collectionView?.reloadData()
            weakSelf!.collectionView?.mj_header.endRefreshing()
            
        }
        
    }
    
    func loadMoreData()
    {
         weak var weakSelf = self
        
        let delayTime = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime){
        
            let filePath = Bundle.main.path(forResource: "1.plist", ofType: nil)
            
            let arr = NSMutableArray.init(contentsOfFile: filePath!)!
            
            var shops = [ShopModel]()
            
            for dict in arr {
                
                let shopM = ShopModel.init(dict: dict as! [String : AnyObject])
                
                shops.append(shopM)
            }
            
            weakSelf!.dataArr.append(contentsOf: shops)
            weakSelf!.collectionView?.reloadData()
            weakSelf!.collectionView?.mj_footer.endRefreshing()
            
        }
       
    }
    
    func setupInit()
    {
        
        let layout = WaterFlowLayout()
         layout.delegate = self
        
        let collectionView = UICollectionView.init(frame: view.bounds, collectionViewLayout: layout)
        view.addSubview(collectionView)
        self.collectionView = collectionView
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        
        let nib = UINib.init(nibName: "WaterFallCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: waterCellID)
        /**
         hah
         */
        
    }
    
    deinit
    {
      collectionView?.mj_header = nil
      collectionView?.mj_footer = nil
    
    }
  
}


extension WaterFlowViewController
{
    //MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
       return dataArr.count
    }
      
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: waterCellID, for: indexPath) as! WaterFallCell
        
        let shopM = dataArr[indexPath.row] 
        
        cell.shopM = shopM
        
        return cell
          
    }
    
    //MARK:WaterflowLayoutDelegate==========必须实现
    func waterflowLayout(_ waterflowLayout: WaterFlowLayout, index: Int, itemWidth: CGFloat) -> (CGFloat) {
               
        let shopM = self.dataArr[index]
        
        return itemWidth * shopM.h / shopM.w
        
    }
    
    //MARK:WaterflowLayoutDelegate==========可选实现
    func columnCountInWaterflowLayout(_ waterflowLayout: WaterFlowLayout) -> Int {
        
        return 4
    }
    
    func columnMarginInWaterflowLayout(_ waterflowLayout: WaterFlowLayout) -> CGFloat {
        
        return 5
    }
    
    func rowMarginInWaterflowLayout(_ waterflowLayout: WaterFlowLayout) -> CGFloat {
        
        return 5
    }
    
    func edgeInsetsInWaterflowLayout(_ waterflowLayout: WaterFlowLayout) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }

}




