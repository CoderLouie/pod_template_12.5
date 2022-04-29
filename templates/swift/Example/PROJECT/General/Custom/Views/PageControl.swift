//
//  PageControl.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

import UIKit

class PageControl: BaseView {
    var numberOfPages: Int {
        set {
            if pages.count == newValue { return }
            if let constraint = tailConstraint {
                constraint.deactivate()
            }
            if pages.count < newValue {
                var prevView = pages.last
                for _ in pages.count..<newValue {
                    prevView = UIView().then {
                        $0.backgroundColor = pageIndicatorTintColor
                        addSubview($0)
                        pages.append($0)
                        $0.snp.makeConstraints { make in
                            if let prev = prevView {
                                make.left.equalTo(prev.snp.right).offset(4.fit)
                                make.centerY.equalTo(prev)
                            } else {
                                make.left.equalTo(0)
                                make.top.bottom.equalTo(0)
                            }
                            make.height.equalTo(4.fit)
                            make.width.equalTo(pageWidth)
                        }
                    }
                }
                guard let prev = prevView else {
                    return
                }
                prev.snp.makeConstraints { make in
                    tailConstraint = make.right.equalTo(0).constraint
                }
            } else {
                let pieces = pages[newValue...]
                pieces.forEach { $0.removeFromSuperview() }
                pages.removeLast(pages.count - newValue)
                if let last = pages.last {
                    last.snp.makeConstraints { make in
                        tailConstraint = make.right.equalTo(0).constraint
                    }
                }
            }
            
            updateConstraintsIfNeeded()
        }
        get { pages.count }
    }
    var currentPage = 0 {
        didSet {
            guard !pages.isEmpty else { return }
            let oldPage = pages[oldValue]
            let newPage = pages[currentPage]
            UIView.animate(withDuration: 0.25) {
                oldPage.snp.updateConstraints { make in
                    make.width.equalTo(self.pageWidth)
                }
                oldPage.backgroundColor = self.pageIndicatorTintColor
                newPage.snp.updateConstraints { make in
                    make.width.equalTo(self.currentPageWith)
                }
                newPage.backgroundColor = self.currentPageIndicatorTintColor
            } completion: { _ in
            }
//            updateConstraintsIfNeeded()
        }
    }
    
    var pageIndicatorTintColor = UIColor(gray: 255, alpha: 0.4) {
        didSet {
            guard !pages.isEmpty else { return }
            for (i, page) in pages.enumerated() {
                if i == currentPage { continue }
                page.backgroundColor = pageIndicatorTintColor
            }
        }
    }
 
    var currentPageIndicatorTintColor = UIColor(gray: 255) {
        didSet {
            guard !pages.isEmpty else { return }
            let page = pages[currentPage]
            page.backgroundColor = currentPageIndicatorTintColor
        }
    }
    
    func forward() {
        var page = currentPage + 1
        if page >= numberOfPages { page = 0 }
        currentPage = page
    }
    func backward() {
        var page = currentPage - 1
        if page < 0 { page = numberOfPages - 1 }
        currentPage = page
    }
    
    override func setup() {
        super.setup()
        DispatchQueue.main.async {
            self.currentPage = 0
        }
    }
    
    private let pageWidth = 9.fit
    private let currentPageWith = 18.fit
    
    private var pages: [UIView] = []
    private var tailConstraint: Constraint?
}
