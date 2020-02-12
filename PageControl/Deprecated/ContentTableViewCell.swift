//
//  ContentTableViewCell.swift
//  PageControl
//
//  Created by AlexLee_Dev on 2020/01/29.
//  Copyright © 2020 AlexLee_Dev. All rights reserved.
//
import RxCocoa
import RxSwift
import UIKit

class ContentTableViewCell: UITableViewCell {
    weak var contentTableView: UITableView!

    private var disposeBag = DisposeBag()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)


        let contentTableView = UITableView()
        contentTableView.delegate = self
        contentTableView.dataSource = self
        contentTableView.g_registerCellClass(cellType: ColorTableViewCell.self)
        contentTableView.allowsSelection = false
        contentTableView.rowHeight = 50
        contentTableView.contentInsetAdjustmentBehavior = .never
        contentTableView.isScrollEnabled = false
        contentTableView.delaysContentTouches = false

        contentView.addSubview(contentTableView)
        self.contentTableView = contentTableView

        let gesture = contentTableView.gestureRecognizers?.filter { $0 is UIPanGestureRecognizer }[1]

        gesture?.name = "2"
//        gesture?.delegate = self

        contentTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }


    func setData(contentOffsetSubject: PublishSubject<CGFloat>, scrollEnabledObserver: Observable<Bool>) {

        contentTableView.rx.contentOffset.map { $0.y }
            .bind(to: contentOffsetSubject)
            .disposed(by: disposeBag)

        //
        contentTableView.rx.contentOffset
            .subscribe(onNext: { offset in
                if offset.y <= 0 {
//                    self.contentTableView.contentOffset = CGPoint(x: 0, y: 0)
                }
            })
            .disposed(by: disposeBag)

        scrollEnabledObserver.startWith(false)
            .subscribe(onNext: { canScroll in
                if canScroll == false {
//                    print("⭐️ : ")
//                    self.contentTableView.contentOffset = CGPoint(x: 0, y: 0)
                    self.contentTableView.isScrollEnabled = false
                } else {
                    self.contentTableView.isScrollEnabled = true
                }
            })
            .disposed(by: disposeBag)
    }
}


extension ContentTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.g_dequeueReusableCell(cellType: ColorTableViewCell.self, indexPath: indexPath)
        cell.setColor(color: .lightGray, title: "")

        return cell
    }
}

//
//extension ContentTableViewCell: UIGestureRecognizerDelegate {
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        print("⭐️ gesture1: ", gestureRecognizer)
//        print("   gesture2 : ", otherGestureRecognizer)
//        if gestureRecognizer.name == "1" && otherGestureRecognizer.name == "2" {
//            print("🔴 same gesture")
//            return true
//        }
//        return false
//    }
//}
