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
    
    fileprivate var numberOfColumns: Int = 3
    fileprivate var cellPadding: Int = 3
    fileprivate var cache: [UICollectionViewLayoutAttributes] = []
    fileprivate var contentHeight: CGFloat = 0.0
    
    override func prepare() {
        guard cache.isEmpty == true, let collection = collectionView else {
            return
        }
        
        let itemsPerRow: Int = 3
        let columnWidth: CGFloat = (collection.bounds.width - CGFloat(numberOfColumns - 1) * CGFloat(cellPadding)) / CGFloat(numberOfColumns)
        let columnHeight: CGFloat = columnWidth
        let featureColumnWidth: CGFloat = (columnWidth * 2) + CGFloat(cellPadding)
        let featureColumnHeight = featureColumnWidth
        
        var xOffset: [CGFloat] = []
        for item in 0..<6 {
            let multiplier = item % 3
            let xPosition = CGFloat(multiplier) * (columnWidth + CGFloat(cellPadding))
            xOffset.append(xPosition)
        }
        xOffset.append(0.0)
        for _ in 0..<2 {
            xOffset.append(featureColumnWidth + CGFloat(cellPadding))
        }
        
        var yOffset: [CGFloat] = []
        for item in 0..<9 {
            var yPosition = floor(Double(item/3) * (Double(columnWidth) + Double(cellPadding)))
            if item == 8 {
                yPosition += (Double(columnHeight) + Double(cellPadding))
            }
            yOffset.append(CGFloat(yPosition))
        }
        
        let numberOfItemsInSection: Int = 9
        let heightOfSection: CGFloat = (4 * columnWidth) + (4 * CGFloat(cellPadding))
        var itemInSection: Int = 0
        
        if let items = collectionView?.numberOfItems(inSection: 0) {
            for item in 0..<items {
                let indexPath = IndexPath(item: item, section: 0)
                let xPos = xOffset[itemInSection]
                let multipler: Double = floor(Double(item) / Double(numberOfItemsInSection))
                let yPos = yOffset[itemInSection] + (heightOfSection * CGFloat(multipler))
                
                var cellWidth = columnWidth
                var cellHeight = columnHeight
                
                if (itemInSection + 1) % 7 == 0 && itemInSection != 0 {
                    cellWidth = featureColumnWidth
                    cellHeight = featureColumnHeight
                }
                
                let frame = CGRect(x: xPos, y: yPos, width: cellWidth, height: cellHeight)
                let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attribute.frame = frame
                cache.append(attribute)
                
                contentHeight = max(contentHeight, frame.maxY)
                
                if (itemInSection + 1) % numberOfItemsInSection == 0 {
                    itemInSection = 0
                } else {
                    itemInSection += 1
                }
            }
        }
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView?.bounds.width ?? 0, height: contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { $0.frame.intersects(rect) }
    }
    
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        var visiableLayoutAttribute : [UICollectionViewLayoutAttributes] = []
//        for attributes in cache {
//            if attributes.frame.intersects(rect){
//                visiableLayoutAttribute.append(attributes)
//            }
//        }
//        return visiableLayoutAttribute
//    }

    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}


