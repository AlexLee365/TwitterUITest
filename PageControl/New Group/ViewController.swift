//
//  ViewController.swift
//  PageControl
//
//  Created by AlexLee_Dev on 2020/01/29.
//  Copyright © 2020 AlexLee_Dev. All rights reserved.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

class ViewController: UIViewController {
    private weak var contentScrollView: UIScrollView!
    private weak var headerView: ColorView!
    private weak var collectionView: UICollectionView!


    lazy var collectionViewHeight = UIScreen.height - headerHeight

    private var disposeBag = DisposeBag()

    private let headerHeight: CGFloat = 200
    private var cellCounts = [10, 20, 30]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayoutConstraints()
    }

    private func setupViews() {
        view.backgroundColor = .white

        let contentScrollView = UIScrollView()
        contentScrollView.contentSize = CGSize(width: UIScreen.width, height: UIScreen.height)
//        contentScrollView.backgroundColor = UIColor.blue.withAlphaComponent(0.3)
        contentScrollView.contentInsetAdjustmentBehavior = .never
        view.addSubview(contentScrollView)
        self.contentScrollView = contentScrollView

        let headerView = ColorView(text: "Header View", color: .brown)
        contentScrollView.addSubview(headerView)
        self.headerView = headerView

        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionViewFlowLayout.minimumLineSpacing = 0
        collectionViewFlowLayout.minimumInteritemSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white


        collectionView.g_registerCellClass(cellType: FirstContentCollectionViewCell.self)

        contentScrollView.addSubview(collectionView)
        self.collectionView = collectionView

    }

    private func setupLayoutConstraints() {
        contentScrollView.snp.makeConstraints {
            $0.edges.equalTo(view)
//            $0.width.equalTo(view)
        }

        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.width.equalTo(view)
            $0.height.equalTo(headerHeight)
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(headerHeight)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(UIScreen.height - headerHeight)
        }
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)




        updateContentScrollviewSize(currentTab: 0)

    }

    private func updateContentScrollviewSize(currentTab: Int) {
        let cellCount = cellCounts[currentTab]
        collectionViewHeight = SingleLineCollectionViewCell.height * CGFloat(cellCount)

        collectionView.snp.updateConstraints {
            $0.height.equalTo(collectionViewHeight)
        }


        contentScrollView.contentSize = CGSize(width: UIScreen.width, height: headerHeight + collectionViewHeight)
    }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.g_dequeueReusableCell(cellType: FirstContentCollectionViewCell.self, indexPath: indexPath)
        cell.setData(cellCount: cellCounts[indexPath.item])

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let cellCount = CGFloat(cellCounts[indexPath.item])
        return CGSize(width: UIScreen.width, height: SingleLineCollectionViewCell.height * cellCount)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("will display cell \(indexPath.item)")

        updateContentScrollviewSize(currentTab: indexPath.item)
    }



    


}

