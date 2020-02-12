//
//  FirstContentCollectionViewCell.swift
//  PageControl
//
//  Created by AlexLee_Dev on 2020/01/31.
//  Copyright © 2020 AlexLee_Dev. All rights reserved.
//

import UIKit

class FirstContentCollectionViewCell: UICollectionViewCell {
    private weak var collectionView: UICollectionView!

    private var cellCount = 10

    private var contentCellColor = UIColor.g_random.withAlphaComponent(0.3)

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupLayoutConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.minimumLineSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .white

        collectionView.g_registerCellClass(cellType: SingleLineCollectionViewCell.self)

        contentView.addSubview(collectionView)
        self.collectionView = collectionView
    }


    private func setupLayoutConstraints() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

    }

    func setData(cellCount: Int) {
        
    }
}


extension FirstContentCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.g_dequeueReusableCell(cellType: SingleLineCollectionViewCell.self, indexPath: indexPath)
        cell.setData(text: "contentCell \(indexPath.item + 1)", color: contentCellColor)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: UIScreen.width, height: SingleLineCollectionViewCell.height)
    }


}
