




//
//  WaterFlowLayout.swift
//  WaterFlowCollectionView
//
//  Created by 西乡流水 on 16/8/16.
//  Copyright © 2016年 西乡流水. All rights reserved.
//

import UIKit

  @objc  protocol WaterflowLayoutDelegate : NSObjectProtocol
    {
        //这个代理方法必须实现
        func waterflowLayout(waterflowLayout: WaterFlowLayout,index:Int,itemWidth: CGFloat)-> CGFloat

        //获取列数
        optional  func columnCountInWaterflowLayout(waterflowLayout:WaterFlowLayout) -> Int

        //获取每列之间的间距
        optional  func columnMarginInWaterflowLayout(waterflowLayout:WaterFlowLayout ) -> CGFloat

        //每一行之间的间距
        optional  func rowMarginInWaterflowLayout(waterflowLayout:WaterFlowLayout ) -> CGFloat

        //整个CollectionView四周边缘间距
        optional func edgeInsetsInWaterflowLayout(waterflowLayout:WaterFlowLayout) -> UIEdgeInsets

    }

    class WaterFlowLayout: UICollectionViewLayout {

        weak var delegate : WaterflowLayoutDelegate?
        
        /** 存放所有cell的布局属性 */
        private var attrsArray = [UICollectionViewLayoutAttributes]()
        
        /** 存放所有列的当前高度 */
        private var columnHeights = [CGFloat]()
        /** 内容的高度 */
        private  var contentHeight : CGFloat?

        let Margin : CGFloat = 10.0

        private var rowInset : UIEdgeInsets{
            
            let  flag = delegate?.respondsToSelector(#selector(WaterflowLayoutDelegate.edgeInsetsInWaterflowLayout(_:)))
            
            if flag == true {
                
              return (delegate?.edgeInsetsInWaterflowLayout!(self))!
                
            }
            
            return UIEdgeInsetsMake(Margin, Margin, Margin, Margin)
            
        }
        
        private var rowMagin : CGFloat{
        
            let flag = delegate?.respondsToSelector(#selector(WaterflowLayoutDelegate.rowMarginInWaterflowLayout(_:)))
            
            if flag == true {
                
                return (delegate?.rowMarginInWaterflowLayout!(self))!
            }
            
            return Margin
          
        }

        private var columnMargin : CGFloat {
         
            let flag = delegate?.respondsToSelector(#selector(WaterflowLayoutDelegate.columnMarginInWaterflowLayout(_:)))
            
            if flag == true {
                
                return (delegate?.columnMarginInWaterflowLayout!(self))!
            }
            
            return Margin
        
        }

        private var columnCount :Int {
            
            let flag = delegate?.respondsToSelector(#selector(WaterflowLayoutDelegate.columnCountInWaterflowLayout(_:)))
            
            if  flag == true {
                
                return (delegate?.columnCountInWaterflowLayout!(self))!
            }
         
            return 3
        
        }

    //准备布局 这个方法没刷新一次就回来到这里
    override func prepareLayout() {
        super.prepareLayout()
        
        contentHeight = 0
        columnHeights.removeAll()
        
        for _ in 0...columnCount - 1
        {
          columnHeights.append((rowInset.top))
        }
        
        attrsArray.removeAll()
        
        let count = collectionView?.numberOfItemsInSection(0)
        
        //第一次来的时候获取的count为零
        if count == 0 {
            
            return
        }
        
        //获取每个item的布局属性,并且对每个item进行布局
        for j in 0...count! - 1
        {
          let indexPath = NSIndexPath.init(forItem: j, inSection: 0)
          
          let atts = layoutAttributesForItemAtIndexPath(indexPath)
            
            if atts == nil {
                
                return
            }
        attrsArray.append((atts)!)
            
        }
        
    }

    //某一行的属性
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        //拿到当前cell的布局属性
        let attrs = UICollectionViewLayoutAttributes.init(forCellWithIndexPath: indexPath)
        
        let collectionViewW = collectionView?.frame.size.width
        
        let allMargin = CGFloat(columnCount - 1) * columnMargin
        let  w = (collectionViewW! - rowInset.left - rowInset.right - allMargin) / CGFloat(columnCount)
        
        //获取索引为indexPath.row 的高度
        let  h = delegate?.waterflowLayout(self, index: indexPath.row, itemWidth: w)
        
        var desColumn:Int = 0
        
        var  minColumnHeight = columnHeights[0]
        
        //找出那一列是最短的,并且记录索引
        for i in 0...(columnCount - 1)
        {
            let columnHeight = columnHeights[i]
            
            if minColumnHeight > columnHeight {
                
                minColumnHeight = columnHeight
                
                desColumn = i
            }
            
        }
        
        let x = rowInset.left + CGFloat(desColumn) * (w + columnMargin)
        
        var y = minColumnHeight
        //不等于第一行的时候
        if y != rowInset.top {
            
            y += rowMagin
        }
        
        attrs.frame = CGRectMake(x, y, w, h!)
        
        //更新最短那列高度
        columnHeights[desColumn] = (CGRectGetMaxY(attrs.frame))
        
        //contentSize的高度 为最高那列的高度
        let columnHeight = columnHeights[desColumn]
        
        if self.contentHeight < columnHeight  {
            
            self.contentHeight = columnHeight
        }
        
        return attrs
    }

    //这个方法就是需要加载没个Item的布局属性
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return attrsArray
        
    }

    //当contentSize改变的时候,就会来到这个方法
    override func collectionViewContentSize() -> CGSize {
        
        return CGSizeMake(0, contentHeight! + rowInset.bottom)
    }


    }
