//
//  ParchmentViewController.swift
//  PageControl
//
//  Created by AlexLee_Dev on 2020/02/13.
//  Copyright © 2020 AlexLee_Dev. All rights reserved.
//
import RxCocoa
import RxSwift
import SnapKit
import Parchment
import UIKit

protocol PageControlProtocol {
    var verticalScrollView: UIScrollView { get }
    var isHeaderViewFixed: Bool { get set }
}

class ParchmentViewController: UIViewController {

    let array = [TableViewController(), TableViewController(), TableViewController()]
    private weak var pagingViewController: CustomPagingViewController!

    var currentIndex = 0

    var currentYOffset: CGFloat = -350
    var isHeaderViewSet = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        setupViews()
        setTableVC()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    private func setupViews() {
        let pagingViewController = CustomPagingViewController()
        pagingViewController.delegate = self
        pagingViewController.dataSource = self
        pagingViewController.menuItemSize = PagingMenuItemSize.fixed(width: UIScreen.width / 3, height: 50)
        pagingViewController.indicatorOptions = .visible(height: 2, zIndex: 0,
                                                         spacing: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10),
                                                         insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        pagingViewController.borderOptions = .visible(height: 1, zIndex: 0, insets: UIEdgeInsets(top: 0, left: 0, bottom: 1.5, right: 0))
        pagingViewController.borderColor = UIColor.lightGray.withAlphaComponent(0.3)
        pagingViewController.indicatorColor = .systemPink
        pagingViewController.menuBackgroundColor = .black
        pagingViewController.textColor = .white
        pagingViewController.selectedTextColor = .systemPink

        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        pagingViewController.didMove(toParent: self)

        pagingViewController.view.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(view)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(0)
        }

        self.pagingViewController = pagingViewController
    }

    private func setTableVC() {
        let height = pagingViewController.options.menuHeight + CustomPagingView.HeaderHeight
        print("⭐️ height: ", height)
        let insets = UIEdgeInsets(top: height, left: 0, bottom: 0, right: 0)
        array.forEach {
            $0.tableView.contentInset = insets
            $0.tableView.scrollIndicatorInsets = insets
            $0.tableView.delegate = self

        }
    }

}

extension ParchmentViewController: PagingViewControllerDataSource {
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        return array.count
    }

    func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        return array[index]
    }

    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        return PagingIndexItem(index: index, title: "Title \(index)")
    }


}

extension ParchmentViewController: PagingViewControllerDelegate {

    func pagingViewController(_ pagingViewController: PagingViewController, didScrollToItem pagingItem: PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) {
        currentIndex = pagingViewController.visibleItems.indexPath(for: pagingItem)?.row ?? 0
        print("current Index: ", currentIndex)

    }

    func pagingViewController(_: PagingViewController, willScrollToItem pagingItem: PagingItem, startingViewController: UIViewController, destinationViewController: UIViewController) {
        guard let startingViewController = startingViewController as? PageControlProtocol,
              var destinationViewController = destinationViewController as? PageControlProtocol else {
                return
        }

        print("---------------------------[]---------------------------")
        print("destination's content y: ", destinationViewController.verticalScrollView.contentOffset.y)


        if !startingViewController.isHeaderViewFixed {
            print("헤더가 조정되고있으므로 현재 포인트로 통일시킵니다.")
            let offset = min(-50, currentYOffset)
            destinationViewController.verticalScrollView.contentOffset.y = offset
            destinationViewController.isHeaderViewFixed = false

        } else if destinationViewController.isHeaderViewFixed != startingViewController.isHeaderViewFixed {
            print("헤더가 고정된 상태인데, 다음 테이블뷰는 고정되지않았으므로 고정된 포인트로 통일시킵니다.")
            let offset = min(-50, currentYOffset)
            destinationViewController.verticalScrollView.contentOffset.y = offset
            destinationViewController.isHeaderViewFixed = true
        }

        print("destination isHeaderViewSet: ", destinationViewController.isHeaderViewFixed)
    }

}

extension ParchmentViewController: UITableViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -50 {
            array[currentIndex].isHeaderViewFixed = false
        } else {
            array[currentIndex].isHeaderViewFixed = true
        }


        guard scrollView.contentOffset.y < 0 else {
            return
        }

        print("⭐️ offset: ", scrollView.contentOffset.y)


        if let customPageView = pagingViewController.view as? CustomPagingView {

            let topInset = pagingViewController.options.menuHeight + CustomPagingView.HeaderHeight
            let headerViewOffset = -min(CustomPagingView.HeaderHeight, scrollView.contentOffset.y + topInset)
            currentYOffset = scrollView.contentOffset.y

            print("topInset: ", topInset)
            print("headerViewOffset: ", headerViewOffset)


            customPageView.headerViewTopConstraint.update(offset: headerViewOffset)
        }


    }

}

// MARK: - CustomPagingView
// =================================== ===================================
class CustomPagingView: PagingView {

    static let HeaderHeight: CGFloat = 300

    var headerHeightConstraint: NSLayoutConstraint?
    weak var headerViewTopConstraint: Constraint!

    lazy var headerView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "sample"))
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.backgroundColor = .brown
        return view
    }()

    override func setupConstraints() {
        addSubview(headerView)

        collectionView.isScrollEnabled = false
        collectionView.snp.makeConstraints {
            $0.leading.trailing.equalTo(self)
            $0.height.equalTo(options.menuHeight)
            $0.top.equalTo(headerView.snp.bottom)
        }

        headerView.snp.makeConstraints {
            $0.leading.trailing.equalTo(self)
            $0.height.equalTo(type(of: self).HeaderHeight)
            self.headerViewTopConstraint = $0.top.equalTo(self).constraint
        }


//        headerView.addGestureRecognizer(tapGesture)

        pageView.snp.makeConstraints {
            $0.edges.equalTo(self)
        }
    }
}

// Create a custom paging view controller and override the view with
// our own custom subclass.
class CustomPagingViewController: PagingViewController {
    override func loadView() {
        view = CustomPagingView(
            options: options,
            collectionView: collectionView,
            pageView: pageViewController.view
        )
    }

    
}


// MARK: - TableViewController
// =================================== ===================================
class TableViewController: UITableViewController, PageControlProtocol {
    private static let CellIdentifier = "CellIdentifier"

    lazy var verticalScrollView: UIScrollView = tableView
    var isHeaderViewFixed = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: TableViewController.CellIdentifier)
        tableView.separatorColor = .lightGray
        tableView.allowsSelection = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = 80
        tableView.indicatorStyle = .white

        print("🔸🔸🔸 viewDidLoad: ")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewController.CellIdentifier, for: indexPath)
        cell.backgroundColor = .clear
        cell.textLabel?.text = "Content \(indexPath.row)"
        cell.textLabel?.textColor = .white

        return cell
    }

}



// =================================== ===================================
class AViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
    }
}

class BViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
    }
}

class CViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
    }
}
