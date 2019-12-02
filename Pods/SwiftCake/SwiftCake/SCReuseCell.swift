//
//  SCReuseCell.swift
//  SwiftCake
//
//  Created by Dominik Majda on 12.03.2017.
//  Copyright © 2017 Dominik Majda. All rights reserved.
//

import UIKit

public protocol SCReusableCell {
    static var cellIdentifier: String { get }
}

extension SCReusableCell where Self: UITableViewCell {
    public static var cellIdentifier: String {
        return String(describing: type(of: self)).replacingOccurrences(of: ".Type", with: "")
    }
}

extension SCReusableCell where Self: UICollectionViewCell {
    public static var cellIdentifier: String {
        return String(describing: type(of: self)).replacingOccurrences(of: ".Type", with: "")
    }
}

extension UICollectionView {
    
    public func registerNib(cell: SCReusableCell.Type) {
        let nib = UINib(nibName: cell.cellIdentifier, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: cell.cellIdentifier)
    }
    
    public func dequeueHeader<T>(withReusable cell: T.Type, for indexPath: IndexPath) -> T where T: SCReusableCell {
        return self.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: cell.cellIdentifier, for: indexPath) as! T
    }
    
    public func dequeueCell<T>(withReusable cell: T.Type, for indexPath: IndexPath) -> T where T: SCReusableCell {
        return self.dequeueReusableCell(withReuseIdentifier: cell.cellIdentifier, for: indexPath) as! T
    }
    
}

extension UITableView {
    
    public func registerNib(cell: SCReusableCell.Type) {
        let nib = UINib(nibName: cell.cellIdentifier, bundle: nil)
        self.register(nib, forCellReuseIdentifier: cell.cellIdentifier)
    }
    
    public func dequeueCell<T>(withReusable cell: T.Type, for indexPath: IndexPath) -> T where T: SCReusableCell {
        return self.dequeueReusableCell(withIdentifier: cell.cellIdentifier, for: indexPath) as! T
    }
}

