//
//  ImagePIckerViewController.swift
//  WaterFlowCollectionView
//
//  Created by 西乡流水 on 17/5/5.
//  Copyright © 2017年 西乡流水. All rights reserved.
//

import UIKit

class ImagePickerViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var shops = [ShopModel]()
    
    var indexPath = IndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       setupInit()
    }

    @IBAction func closeBtnClick(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }

}

extension ImagePickerViewController
{
    fileprivate func setupInit()
    {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerCell(ImagePickerCell.self)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }

}

extension ImagePickerViewController : UICollectionViewDataSource,UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return shops.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeuResuableCell(indexPath) as ImagePickerCell
        
        cell.shop = shops[indexPath.row]
        
        return cell
    }
    
}



