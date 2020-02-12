//
//  HorizontalCollectionViewCell.swift
//  PageControl
//
//  Created by AlexLee_Dev on 2020/02/12.
//  Copyright © 2020 AlexLee_Dev. All rights reserved.
//
import RxCocoa
import RxSwift
import UIKit

class HorizontalCollectionViewCell: UICollectionViewCell {
    static let headerHeight: CGFloat = 400
    private let backColor = UIColor.g_random.withAlphaComponent(0.3)

    var test = [5, 50, 30]

    var index: Int = 0
    private weak var collectionView: UICollectionView!
    private let currentTabRelay = BehaviorRelay<Int>(value: 0)

    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)



        setupViews()
        setupLayoutConstraints()

        collectionView.rx.contentOffset
            .map { $0.y }
            .filter { [weak self] _ in
                return self?.index == self?.currentTabRelay.value
            }
            .subscribe(onNext: { [weak self] yOffset in
                print("⭐️ content y: ", yOffset)

                let userInfo: [String: Any] = ["yOffset": yOffset, "index": self?.index ?? 0]

                NotificationCenter.default.post(name: .contentUp, object: nil, userInfo: userInfo)
            })
            .disposed(by: disposeBag)

        NotificationCenter.default.rx.notification(.contentUp)
            .flatMap { [weak self] noti -> Observable<CGFloat> in
                guard let yOffset = noti.userInfo?["yOffset"] as? CGFloat,
                    self?.currentTabRelay.value != self?.index else {
                    return .empty()
                }

//                print("🔸🔸🔸  sender: ", index, " / self: ", self?.index)

                return Observable.just(yOffset)
            }
            .filter {
                return $0 < type(of: self).headerHeight - 80
            }
            .subscribe(onNext: { [weak self] yOffset in
                self?.collectionView.contentOffset.y = yOffset
            })
            .disposed(by: disposeBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func setupViews() {
        self.backgroundColor = .white

        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.scrollIndicatorInsets = .init(top: HorizontalCollectionViewCell.headerHeight, left: 0, bottom: 0, right: 0)
        collectionView.g_registerCellClass(cellType: SingleLineCollectionViewCell.self)
        collectionView.backgroundColor = .white
        self.addSubview(collectionView)
        self.collectionView = collectionView
    }

    private func setupLayoutConstraints() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }

    func setData(currentTabsubject: PublishSubject<Int>) {
        currentTabsubject.bind(to: self.currentTabRelay)
            .disposed(by: disposeBag)
    }
}

extension HorizontalCollectionViewCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return test[index]
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.g_dequeueReusableCell(cellType: SingleLineCollectionViewCell.self, indexPath: indexPath)
            cell.setData(text: "Header", color: backColor)

            return cell
        case 1:
            let cell = collectionView.g_dequeueReusableCell(cellType: SingleLineCollectionViewCell.self, indexPath: indexPath)
            cell.setData(text: "content \(indexPath.row + 1)", color: backColor)

            return cell
        default:
            return UICollectionViewCell()
        }
    }


}

extension HorizontalCollectionViewCell: UICollectionViewDelegate {



}

extension HorizontalCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: UIScreen.width, height: HorizontalCollectionViewCell.headerHeight)
        case 1:
            return CGSize(width: UIScreen.width, height: 100)
        default:
            return .zero
        }
    }
}
