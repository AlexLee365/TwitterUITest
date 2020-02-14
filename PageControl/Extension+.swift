//
//  Extension+.swift
//  PageControl
//
//  Created by AlexLee_Dev on 2020/01/31.
//  Copyright © 2020 AlexLee_Dev. All rights reserved.
//
import RxCocoa
import RxSwift
import UIKit


extension UITableView {
    func g_registerCellClass(cellType: UITableViewCell.Type) {
        self.register(cellType, forCellReuseIdentifier: "\(cellType)")
    }

    func g_dequeueReusableCell<T: UITableViewCell>(cellType: T.Type, indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: "\(cellType)", for: indexPath) as! T
    }
}


public extension UICollectionView {
    func g_registerCellNib(cellType: UICollectionViewCell.Type) {
        let cellName = "\(cellType)"
        register(UINib(nibName: cellName, bundle: nil), forCellWithReuseIdentifier: cellName)
    }

    func g_registerCellClass(cellType: UICollectionViewCell.Type) {
        register(cellType, forCellWithReuseIdentifier: "\(cellType)")
    }

    func g_registerHeaderClass(viewType: UICollectionReusableView.Type) {
        register(viewType, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(viewType)")
    }

    func g_registerFooterClass(viewType: UICollectionReusableView.Type) {
        register(viewType, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "\(viewType)")
    }

    func g_dequeueReusableCell<T: UICollectionViewCell>(cellType: T.Type = T.self, reuseIdentifier: String? = nil, indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: reuseIdentifier ?? "\(cellType)", for: indexPath) as! T
    }

    func g_dequeueHeader<T: UICollectionReusableView>(viewType: T.Type = T.self, indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(viewType)", for: indexPath) as! T
    }

    func g_dequeueFooter<T: UICollectionReusableView>(viewType: T.Type = T.self, indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "\(viewType)", for: indexPath) as! T
    }
}

extension UIColor {
    convenience init(_ red: Int, _ green: Int, _ blue: Int) {
        self.init(red, green, blue, 1)
    }

    convenience init(_ red: Int, _ green: Int, _ blue: Int, _ alpha: CGFloat = 1) {
        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: alpha)
    }

    static var g_random: UIColor {
        return UIColor(Int.random(in: 0...255), Int.random(in: 0...255), Int.random(in: 0...255))
    }
}


extension UIScreen {
    static var width: CGFloat {
        return self.main.bounds.width
    }

    static var height: CGFloat {
        return self.main.bounds.height
    }
}



extension Notification.Name {
    static let contentUp = Notification.Name(rawValue: "contentUp")
}







extension SharedSequenceConvertibleType {
    func g_unwrap<T>() -> SharedSequence<SharingStrategy, T> where E == T? {
        return filter { $0 != nil }.map { $0! }
    }

    func g_wrap<T>() -> SharedSequence<SharingStrategy, T?> where E == T {
        return map { $0 as T? }
    }

    /// 이전 값을 함께 주는 operator, 따라서 두번째 이벤트부터 시작됨
    func g_withPrevious() -> SharedSequence<SharingStrategy, (E, E)> {
        return self
            .scan([]) { array, newElement in
                return (array + [newElement]).suffix(2)
            }
            .filter { $0.count == 2 }
            .map { ($0[0], $0[1]) }
    }

    /// pauser가 true일때만 이벤트를 통과시키는 operator
    func g_pausable<P: SharedSequenceConvertibleType> (_ pauser: P) -> SharedSequence<SharingStrategy, E> where P.SharingStrategy == SharingStrategy, P.E == Bool {
        return withLatestFrom(pauser) { element, paused in
            return (element, paused)
        }
        .filter { _, paused in paused }
        .map { element, _ in element }
    }
}
