//
//  CustomCollectionLayout.swift
//  InstagramApp
//
//  Created by Cubastion on 13/04/23.
//  Copyright © 2023 Abhishek Biswas. All rights reserved.
//

import Foundation
import UIKit

class CustomCollectionLayout : UICollectionViewLayout {
    fileprivate var numberOfColumns : Int = 3
    fileprivate var cellPadding : Int = 3
    fileprivate var cache : [UICollectionViewLayoutAttributes] = []
    fileprivate var collectionWidth : CGFloat {
        guard let collection = collectionView else{
            return 0
        }
        
        let insetEdge = collection.contentInset
        return collection.bounds.width - (insetEdge.left + insetEdge.right) - (CGFloat(numberOfColumns) - 1)
    }
    
    fileprivate var collectionHeight : CGFloat = 0.0
    fileprivate var CollectionContentSize : CGSize {
        return CGSize(width: collectionWidth, height: collectionHeight)
    }
    
    override func prepare() {
        guard cache.isEmpty == true, let collection = collectionView else {
            return
        }
        
        let itemsPerRows : Int = 3
        let columnWidth : CGFloat = collectionWidth / CGFloat(itemsPerRows)
        let columnHeight : CGFloat = columnWidth
        let featureColumnWidth : CGFloat = (columnWidth * 2) + CGFloat(cellPadding)
        let featureColumHeight = featureColumnWidth
        var xOffset : [CGFloat] = []
        for item in 0..<6 {
            let multiplier = item % 3
            let xPosition = CGFloat(multiplier) * (columnWidth + CGFloat(cellPadding))
            xOffset.append(xPosition)
        }
        xOffset.append(0.0)
        for _ in 0..<2 {
            xOffset.append(featureColumnWidth + CGFloat(cellPadding))
        }
        var yOffset : [CGFloat] = []
        for item in 0..<9 {
            var yPosition = floor(Double(item/3) * (Double(columnWidth) + Double(cellPadding)))
            if item == 8 {
                yPosition += (Double(columnHeight) + Double(cellPadding))
            }
            yOffset.append(CGFloat(yPosition))
        }
        
        let numberOfItemInPerSection : Int = 9
        let heightOfSection : CGFloat = (4 * columnWidth) + (4 * CGFloat(cellPadding))
        var itemInSection : Int = 0
        
        if let items  = collectionView?.numberOfItems(inSection: 0) {
            for item in 0..<items {
                let indexPath = IndexPath(item: item, section: 0)
                let xPos = xOffset[itemInSection]
                let multipler : Double = floor(Double(item) / Double(numberOfItemInPerSection))
                let yPos = yOffset[itemInSection] + (heightOfSection * CGFloat(multipler))
                
                var cellwidth = columnWidth
                var cellHight = columnHeight
                
                if (itemInSection + 1)%7 == 0 && itemInSection != 0 {
                    cellwidth = featureColumnWidth
                    cellHight = featureColumHeight
                }
                
                let frame = CGRect(x: xPos, y: yPos, width: cellwidth, height: cellHight)
                let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attribute.frame = frame
                cache.append(attribute)
                collectionHeight = max(collectionHeight, frame.maxY)
                if (itemInSection + 1) % 9 == 0 {
                    itemInSection = 0
                } else {
                    itemInSection += 1
                }
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visiableLayoutAttribute : [UICollectionViewLayoutAttributes] = []
        for attributes in cache {
            if attributes.frame.intersects(rect){
                visiableLayoutAttribute.append(attributes)
            }
        }
        return visiableLayoutAttribute
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}


