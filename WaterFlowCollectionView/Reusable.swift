//
//  Reusable.swift
//  Swift面向协议开发
//
//  Created by 西乡流水 on 17/4/18.
//  Copyright © 2017年 西乡流水. All rights reserved.
//

import UIKit

protocol Reusable
{
    static var reusableIdentifier : String { get }
    static var nib :UINib? { get }
}

extension Reusable
{
    static var reusableIdentifier : String
    {
         return "K" + "\(self)"
    }
    
    static var nib : UINib?
    {
         return nil
    }
}

extension UITableView
{
    /*T.Type : 就是指的类,因为在扩展里面必须这样写*/
    func registerCell<T : UITableViewCell>(_ cell :T.Type) where T :Reusable
    {
        if let nib = T.nib
        {
            register(nib, forCellReuseIdentifier: T.reusableIdentifier)
        }
        else
        {
            register(cell, forCellReuseIdentifier: T.reusableIdentifier)
        }
    }
    
    func dequeuResuableCell<T : Reusable>(_ indexPath :IndexPath) -> T
    {
       return dequeueReusableCell(withIdentifier: T.reusableIdentifier, for: indexPath) as! T
    }

}

/*collectionView 同上*/
extension UICollectionView
{
    func registerCell<T :UICollectionViewCell >(_ cell :T.Type) where T :Reusable
    {
        //如果是nib创建的请在xib里面重写nib属性
        if let nib = T.nib
        {
            register(nib, forCellWithReuseIdentifier: T.reusableIdentifier)
        }
        else
        {
            register(cell, forCellWithReuseIdentifier: T.reusableIdentifier)
        }
    }
 
    func dequeuResuableCell<T : Reusable>(_ indexPath :IndexPath) -> T
    {
        return dequeueReusableCell(withReuseIdentifier: T.reusableIdentifier, for: indexPath) as! T
    }

}
