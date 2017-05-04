
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
        func waterflowLayout(_ waterflowLayout: WaterFlowLayout,index:Int,itemWidth: CGFloat)-> CGFloat

        //获取列数
        @objc optional  func columnCountInWaterflowLayout(_ waterflowLayout:WaterFlowLayout) -> Int

        //获取每列之间的间距
        @objc optional  func columnMarginInWaterflowLayout(_ waterflowLayout:WaterFlowLayout ) -> CGFloat

        //每一行之间的间距
        @objc optional  func rowMarginInWaterflowLayout(_ waterflowLayout:WaterFlowLayout ) -> CGFloat

        //整个CollectionView四周边缘间距
        @objc optional func edgeInsetsInWaterflowLayout(_ waterflowLayout:WaterFlowLayout) -> UIEdgeInsets

    }

    class WaterFlowLayout: UICollectionViewLayout {

        weak var delegate : WaterflowLayoutDelegate?
        
        /** 存放所有cell的布局属性 */
        fileprivate var attrsArray = [UICollectionViewLayoutAttributes]()
        
        /** 存放所有列的当前高度 */
        fileprivate var columnHeights = [CGFloat]()
        /** 内容的高度 */
        fileprivate  var contentHeight : CGFloat?

        let Margin : CGFloat = 10.0

        fileprivate var rowInset : UIEdgeInsets {
            
            return delegate?.edgeInsetsInWaterflowLayout!(self) ?? UIEdgeInsets()

        }
        
        fileprivate var rowMagin : CGFloat{
            
            return delegate?.rowMarginInWaterflowLayout!(self) ?? Margin
        }

        fileprivate var columnMargin : CGFloat {
            
            return delegate?.columnMarginInWaterflowLayout!(self) ?? Margin
        }

        fileprivate var columnCount :Int {
            
            return delegate?.columnCountInWaterflowLayout!(self) ?? 3
        }

    //准备布局 这个方法没刷新一次就回来到这里
    override func prepare() {
        super.prepare()
        
        contentHeight = 0
        columnHeights.removeAll()
        
        for _ in 0...columnCount - 1
        {
          columnHeights.append((rowInset.top))
        }
        
        attrsArray.removeAll()
        
        //第一次来的时候获取的count为零
        let count = collectionView?.numberOfItems(inSection: 0)
        if count == 0 {return }
        
        //获取每个item的布局属性,并且对每个item进行布局
        for j in 0...count! - 1
        {
          let indexPath = IndexPath.init(item: j, section: 0)
          
          guard let atts = layoutAttributesForItem(at: indexPath) else { return }
       
          attrsArray.append(atts)
            
        }
        
    }

    //某一行的属性
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        //拿到当前cell的布局属性
        let attrs = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        
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
        
        attrs.frame = CGRect(x: x, y: y, width: w, height: h!)
        
        //更新最短那列高度
        columnHeights[desColumn] = (attrs.frame.maxY)
        
        //contentSize的高度 为最高那列的高度
        let columnHeight = columnHeights[desColumn]
        
        if self.contentHeight! < columnHeight  {
            
            self.contentHeight = columnHeight
        }
        
        return attrs
    }

    //这个方法就是需要加载没个Item的布局属性
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return attrsArray
        
    }

    //当contentSize改变的时候,就会来到这个方法
    override var collectionViewContentSize : CGSize {
        
        return CGSize(width: 0, height: contentHeight! + rowInset.bottom)
    }


    }
