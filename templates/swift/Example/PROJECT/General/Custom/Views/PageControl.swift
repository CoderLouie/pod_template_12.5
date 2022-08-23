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
            tailConstraint?.deactivate()
            if pages.count < newValue {
                var prevView = pages.last
                for i in pages.count..<newValue {
                    let hit = i == _currentPage
                    prevView = UIView().then {
                        $0.backgroundColor = hit ? currentPageIndicatorTintColor : pageIndicatorTintColor
                        addSubview($0)
                        pages.append($0)
                        $0.snp.makeConstraints { make in
                            if let prev = prevView {
                                make.leading.equalTo(prev.snp.trailing).offset(pageWidth)
                                make.centerY.equalTo(prev)
                            } else {
                                make.leading.equalToSuperview()
                                make.top.bottom.equalTo(0)
                            }
                            make.height.equalTo(pageWidth)
                            make.width.equalTo(hit ? currentPageWith : pageWidth)
                        }
                    }
                }
                prevView?.snp.makeConstraints { make in
                    tailConstraint = make.trailing.equalToSuperview().constraint
                }
            } else {
                if newValue < 1 {
                    pages.forEach { $0.removeFromSuperview() }
                    pages = []
                    tailConstraint?.deactivate()
                    tailConstraint = nil
                    layoutIfNeeded()
                    return
                }
                let pieces = pages[newValue...]
                if _currentPage > newValue - 1 {
                    _currentPage = newValue - 1
                    let hitPage = pages[_currentPage]
                    hitPage.backgroundColor = currentPageIndicatorTintColor
                    hitPage.snp.updateConstraints { make in
                        make.width.equalTo(currentPageWith)
                    }
                }
                pieces.forEach { $0.removeFromSuperview() }
                pages.removeLast(pages.count - newValue)
                if let last = pages.last {
                    last.snp.makeConstraints { make in
                        tailConstraint = make.trailing.equalTo(0).constraint
                    }
                }
            }
             
            layoutIfNeeded()
        }
        get { pages.count }
    }
    private var _currentPage = 0
    var currentPage: Int {
        get { _currentPage }
        set {
            guard newValue != _currentPage else { return }
            guard pages.fullRange.contains(newValue) else { return }
            let oldPage = pages[_currentPage]
            let newPage = pages[newValue]
            _currentPage = newValue
            oldPage.snp.updateConstraints { make in
                make.width.equalTo(self.pageWidth)
            }
            newPage.snp.updateConstraints { make in
                make.width.equalTo(self.currentPageWith)
            }
            UIView.animate(withDuration: 0.25) {
                oldPage.backgroundColor = self.pageIndicatorTintColor
                newPage.backgroundColor = self.currentPageIndicatorTintColor
                self.layoutIfNeeded()
            } completion: { _ in
            }
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
        self.snp.makeConstraints { make in
            make.width.height.equalTo(1).priority(50)
        }
    }
    
    private let pageWidth = 4.fit
    private let currentPageWith = 12.fit
    
    private var pages: [UIView] = []
    private var tailConstraint: Constraint?
}
