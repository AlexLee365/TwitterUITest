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
    private weak var mainTableView: UITableView!

    private weak var testTableView: UITableView!


    private let contentTableViewContentOffset = PublishSubject<CGFloat>()
    private let contentTableViewScrollEnabled = PublishSubject<Bool>()
    private var disposeBag = DisposeBag()

    private let headerHeight: CGFloat = 200

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayoutConstraints()

        mainTableView.rx.contentOffset
            .map { $0.y }
            .subscribe(onNext: { y in
                print("mainTableView y: ", y)
                
//                if y >= self.headerHeight {
//                    self.mainTableView.contentOffset = CGPoint(x: 0, y: self.headerHeight)
//                    self.contentTableViewScrollEnabled.onNext(true)
//                } else {
//                    self.contentTableViewScrollEnabled.onNext(false)
//                }
            })
            .disposed(by: disposeBag)

        contentTableViewContentOffset
            .subscribe(onNext: { y in
//                print("🔸🔸🔸 offset: ", y)
            })
            .disposed(by: disposeBag)

    }

    private func setupViews() {
        let mainTableView = UITableView()
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.g_registerCellClass(cellType: ColorTableViewCell.self)
        mainTableView.g_registerCellClass(cellType: ContentTableViewCell.self)
        mainTableView.showsVerticalScrollIndicator = false
//        mainTableView.insetsContentViewsToSafeArea = false
        mainTableView.contentInsetAdjustmentBehavior = .never
        mainTableView.delaysContentTouches = false
        mainTableView.allowsSelection = false
        view.addSubview(mainTableView)
        self.mainTableView = mainTableView

        let testTableView = UITableView()
        testTableView.delegate = self
        testTableView.dataSource = self
        testTableView.register(UITableViewCell.self, forCellReuseIdentifier: "test")
        testTableView.allowsSelection = false
//        testTableView.rowHeight = 50
        testTableView.contentInsetAdjustmentBehavior = .never
//        testTableView.delaysContentTouches = false
        mainTableView.addSubview(testTableView)
        self.testTableView = testTableView

//        mainTableView.panGestureRecognizer.delegate = self

//        let gesture = mainTableView.gestureRecognizers?.filter { $0 is UIPanGestureRecognizer }.first
//        gesture?.delegate = self
//        gesture?.name = "1"



//        print("🔴", mainTableView.gestureRecognizers?.filter { $0 is UIPanGestureRecognizer })
    }

    private func setupLayoutConstraints() {
        mainTableView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }

        testTableView.snp.makeConstraints {
            $0.top.equalTo(view).offset(headerHeight)
            $0.leading.trailing.bottom.equalTo(view)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)


    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == mainTableView {
            return 1
        } else {
            return 20
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if tableView == mainTableView {


            let cell: UITableViewCell
            switch indexPath.row {
            case 0:
                let colorCell = tableView.g_dequeueReusableCell(cellType: ColorTableViewCell.self, indexPath: indexPath)
                colorCell.setColor(color: .brown, title: "HeaderView")

                cell = colorCell

            case 1:
                let contentCell = tableView.g_dequeueReusableCell(cellType: ContentTableViewCell.self, indexPath: indexPath)
                contentCell.setData(contentOffsetSubject: contentTableViewContentOffset, scrollEnabledObserver: contentTableViewScrollEnabled.asObservable())

                cell = contentCell

            default:
                cell = UITableViewCell()
            }


            return cell

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "test", for: indexPath)
            cell.textLabel?.text = "test"

            return cell
        }


    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if tableView == mainTableView {
            let height: CGFloat
            switch indexPath.row {
            case 0:
                height = headerHeight + UIScreen.main.bounds.height

            case 1:
                height = UIScreen.main.bounds.height

            default:
                height = 0
            }

            return height
        }
        else {
            return 50
        }

    }

}

//extension ViewController: UIGestureRecognizerDelegate {
////    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
////        print("⭐️ gesture1: ", gestureRecognizer)
////        print("   gesture2 : ", otherGestureRecognizer)
////        if gestureRecognizer.name == "1" && otherGestureRecognizer.name == "2" {
////            print("🔴 same gesture")
////            return true
////        }
////        return false
////    }
//
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        print("⭐️ gesture1: ", gestureRecognizer)
//        print("   gesture2 : ", otherGestureRecognizer)
//        if gestureRecognizer.name == "1" && otherGestureRecognizer.name == "2" {
//            print("🔴 same gesture")
//            return true
//        }
//        return false
//    }
//
//
////    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//////        print("⭐️ gesture1: ", gestureRecognizer)
//////        print("   gesture2 : ", otherGestureRecognizer)
////        return true
////    }
//}
