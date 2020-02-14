//
//  NewViewController.swift
//  PageControl
//
//  Created by AlexLee_Dev on 2020/02/12.
//  Copyright © 2020 AlexLee_Dev. All rights reserved.
//

import SnapKit
import RxCocoa
import RxSwift
import UIKit

class NewViewController: UIViewController {
    private weak var headerView: UIImageView!
    private weak var horizontalCollectionView: UICollectionView!

    private var currentTab: Int = 0

    private let headerHeight: CGFloat = 400

    private let currentTabSubject = PublishSubject<Int>()
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupLayoutConstraints()

        horizontalCollectionView.rx.didEndDecelerating.startWith(())
            .subscribe(onNext: { [weak self] _ in
                guard let strongself = self else { return }

                let tabNumber = Int(strongself.horizontalCollectionView.contentOffset.x / UIScreen.width)
                self?.currentTab = tabNumber

                self?.currentTabSubject.onNext(tabNumber)

                print("---------------------------[current Tab: \(strongself.currentTab) ]---------------------------")
            })
            .disposed(by: disposeBag)



        NotificationCenter.default.rx.notification(.contentUp)
            .flatMap { noti -> Observable<(CGFloat, Direction.Vertical)> in
                guard let scrolledInfo = noti.object as? (CGFloat, Direction.Vertical) else {
                    return .empty()
                }
//                    yOffset <= HorizontalCollectionViewCell.headerHeight

                return Observable.just(scrolledInfo)
            }
            .subscribe(onNext: { [weak self] yOffset, _ in
                guard let strongself = self else{ return }
                let offset = min(yOffset, HorizontalCollectionViewCell.headerHeight - 80)

                strongself.headerView.snp.updateConstraints {
                    $0.top.equalTo(strongself.view).offset(-offset)
                }
            })
            .disposed(by: disposeBag)

        

    }

    private func setupViews() {
        view.backgroundColor = .white

        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal

        let horizontalCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        horizontalCollectionView.delegate = self
        horizontalCollectionView.dataSource = self
        horizontalCollectionView.g_registerCellClass(cellType: HorizontalCollectionViewCell.self)
        horizontalCollectionView.contentInsetAdjustmentBehavior = .never
        horizontalCollectionView.isPagingEnabled = true
        horizontalCollectionView.backgroundColor = .white
        view.addSubview(horizontalCollectionView)
        self.horizontalCollectionView = horizontalCollectionView

        let headerView = UIImageView()
        headerView.backgroundColor = .black
        headerView.image = UIImage(named: "sample")
        headerView.contentMode = .scaleAspectFit
        horizontalCollectionView.addSubview(headerView)
        self.headerView = headerView
    }

    private func setupLayoutConstraints() {
//        let safeGuide = view.safeAreaLayoutGuide

        horizontalCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }

        headerView.snp.makeConstraints {
            $0.top.equalTo(view)
            $0.leading.trailing.equalTo(view)
            $0.height.equalTo(HorizontalCollectionViewCell.headerHeight)
        }

    }

    


}


// MARK: - Delegate
extension NewViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.g_dequeueReusableCell(cellType: HorizontalCollectionViewCell.self, indexPath: indexPath)
        cell.index = indexPath.row
        cell.setData(currentTabsubject: currentTabSubject)

        return cell
    }


}

extension NewViewController: UICollectionViewDelegate {


}

extension NewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.width, height: UIScreen.height)
    }
}
