//
//  VideoLoopView.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

import UIKit


class VideoLoopView: UIView {

    var autoPlayNext: Bool = true
    
    var selectedItemDidChange: ((Int) -> Void)?
    
    func forward() {
        playerView.forward()
    }
    
    var isScrollEnabled: Bool {
        get { playerView.isScrollEnabled }
        set { playerView.isScrollEnabled = newValue }
    }
    
    init(frame: CGRect = .zero, videos: [String]) {
        precondition(videos.count > 1)
        
        super.init(frame: frame)
        
        videoList = videos.compactMap {
            let player = LocalPlayer(filename: $0)
            player?.loop = true
            return player
        }
        
        playerView = CarouselView().then { this in
            this.register(VideoLoopCell.self)
            this.delegate = self
            this.itemsCount = videoList.count
            addSubview(this)
            this.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
    
    private override init(frame: CGRect) {
        fatalError("init(coder:) has not been implemented")
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private(set) unowned var playerView: CarouselView!
    private(set) var videoList: [LocalPlayer]!
}


extension VideoLoopView: CarouselViewDelegate {
    func carouselView(_ carouselView: CarouselView, didSelect cell: CarouselViewCell, at index: Int) {
        guard let videoCell = cell as? VideoLoopCell else {
            return
        }
        let player = videoList[index]
        videoCell.render(with: player)
        if autoPlayNext {
            player.listener = { [unowned self] event in
                if case .finished = event, !self.playerView.isTracking {
                    self.playerView.forward()
                }
            }
        }
        selectedItemDidChange?(index)
        player.play()
    }

//    func carouselView(_ carouselView: CarouselView, didDeselect cell: CarouselViewCell, at index: Int) {
//        videoList[index].reset()
//    }
    
    func carouselView(_ carouselView: CarouselView, willAppear cell: CarouselViewCell, at index: Int) {
        guard let videoCell = cell as? VideoLoopCell else {
            return
        }
        videoCell.render(with: videoList[index])
    }
}


fileprivate class VideoLoopCell: CarouselViewCell {
    override func setup() {
        videoView = UIView().then {
            $0.clipsToBounds = true
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
    func render(with item: LocalPlayer) {
        videoView.layer.removeSublayers()
        item.layer.frame = bounds
        videoView.layer.addSublayer(item.layer)
    }
    private(set) unowned var videoView: UIView!
}
