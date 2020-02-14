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

enum Direction {
    enum Vertical: String {
        case up
        case down
    }

    enum Horizontal: String {
        case left
        case right
    }
}

class HorizontalCollectionViewCell: UICollectionViewCell {
    static let headerHeight: CGFloat = 400
    private let backColor = UIColor.g_random.withAlphaComponent(0.3)

    var test = [10, 50, 30]

    var index: Int = 0
    private weak var collectionView: UICollectionView!
    private let currentTabRelay = BehaviorRelay<Int>(value: 0)

    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupLayoutConstraints()

        collectionView.rx.contentOffset
            .filter { [weak self] _ in
                return self?.index == self?.currentTabRelay.value
            }
            .map { $0.y }
            .scan((0, .down)) { prior, current -> (CGFloat, Direction.Vertical) in
                let direction: Direction.Vertical = current > prior.0 ? .down : .up

                return (current, direction)
            }
            .subscribe(onNext: { [weak self] in
                print("⭐️ content y: ", $0.0, " / ", $0.1.rawValue)

                if self?.collectionView.contentOffset.y ?? 0 > HorizontalCollectionViewCell.headerHeight - 80 {
                    
                }

                NotificationCenter.default.post(name: .contentUp, object: $0)
            })
            .disposed(by: disposeBag)

        NotificationCenter.default.rx.notification(.contentUp)
            .map {
                return $0.object as? (CGFloat, Direction.Vertical) ?? (0, .down)
            }
            .filter { [weak self] in
                guard self?.currentTabRelay.value != self?.index else {
                    return false
                }

                return $0.0 <= HorizontalCollectionViewCell.headerHeight - 80
            }
            .subscribe(onNext: { [weak self] yOffset, direction in
                print("🔸 received contentoffset : ", yOffset)
//                let showingHeaderHeight = HorizontalCollectionViewCell.headerHeight - 80
//
//                if case .down = direction,
//                    yOffset <= showingHeaderHeight + 100,
//                    self?.collectionView.contentOffset.y != showingHeaderHeight {
//
//                    print("내려가는중 오프셋 통일시킴")
//                    let offset = min(yOffset, showingHeaderHeight)
//                    self?.collectionView.contentOffset.y = offset
//
//                } else if case .up = direction, yOffset <= showingHeaderHeight {
//                    print("올라가는중 오프셋 통일시킴")
//                    self?.collectionView.contentOffset.y = yOffset
//                }

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
        collectionView.g_registerCellClass(cellType: SingleLineCollectionViewCell.self)
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.scrollIndicatorInsets = .init(top: HorizontalCollectionViewCell.headerHeight, left: 0, bottom: 0, right: 0)
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
