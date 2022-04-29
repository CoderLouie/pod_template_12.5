//
//  LocalPlayerView.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

import UIKit
import AVFoundation

final class LocalPlayer {
    enum State {
        case paused
        case changeItem
        case finished
        case playing
        case reset
    }
    private(set) var layer: AVPlayerLayer
    private var player: AVPlayer
    private var state: State = .paused
    
    var listener: ((State) -> Void)?
    var loop = false
    
    init(player: AVPlayer) {
        self.player = player
        player.isMuted = true
        layer = AVPlayerLayer(player: player).then {
            $0.videoGravity = .resizeAspectFill
            $0.shouldRasterize = true
            $0.rasterizationScale = UIScreen.main.scale
        }
    }
    convenience init() {
        self.init(player: AVPlayer())
    }
    convenience init?(filename: String) {
        guard let item = Self.avplayerItem(with: filename) else {
            return nil
        }
        self.init(player: AVPlayer(playerItem: item))
    }
    
    @discardableResult
    func play(file filename: String? = nil) -> Bool {
        if let filename = filename {
            if let item = Self.avplayerItem(with: filename) {
                state = .changeItem
                listener?(.changeItem)
                player.replaceCurrentItem(with: item)
            } else {
                return false
            }
        }
        NotificationCenter.default.removeObserver(self)
        player.play()
        state = .playing
        listener?(.playing)
        NotificationCenter.default.addObserver(self, selector: #selector(didPlayToEnd(_:)), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        AVAudioSession.sharedInstance().do {
            try? $0.setCategory(.ambient, options: [.mixWithOthers, .defaultToSpeaker])
            try? $0.setActive(true)
        }
        return true
    }
    private var needResume = false
    @objc private func appDidEnterBackground() {
        guard state == .playing else { return }
        needResume = true
        DispatchQueue.main.async {
            self.player.pause()
        }
    }
    @objc private func appDidEnterForeground() {
        guard needResume else { return }
        needResume = false
        DispatchQueue.main.async {
            self.player.play()
        }
    }
    func pause() {
        player.pause()
        state = .paused
        listener?(.paused)
    }
    func reset() {
        NotificationCenter.default.removeObserver(self)
        player.pause()
        player.seek(to: .zero)
        state = .reset
        listener?(.reset)
        listener = nil
    }
    deinit {
        Console.log("\(type(of: self)) deinit")
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func didPlayToEnd(_ noti: Notification) {
        guard let item = noti.object as? AVPlayerItem else { return }
        if item != player.currentItem { return }
        state = .finished
        listener?(.finished)
        player.pause()
        player.seek(to: .zero)
        guard loop else { return }
        DispatchQueue.main.async {
            self.player.play()
            self.state = .playing
            self.listener?(.playing)
        }
    }
    private static func avplayerItem(with filename: String) -> AVPlayerItem? {
        guard let filePath = Bundle.main.path(forResource: filename, ofType: ".mp4") else {
            return nil
        }
        return AVPlayerItem(url: .init(fileURLWithPath: filePath))
    }
}


final class LocalPlayerView: UIView {
    var loop: Bool {
        set { player.loop = newValue }
        get { player.loop }
    }
    
    init(filename: String, frame: CGRect = .zero) {
        super.init(frame: frame)
        
        guard let player = LocalPlayer(filename: filename) else {
            fatalError()
        }
        layer.addSublayer(player.layer)
        self.player = player
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        player.layer.frame = bounds
    }
    func pause() {
        player.pause()
    }
    func reset() {
        player.reset()
    }
    
    func play(_ completion: (() -> Void)? = nil) {
        if let closure = completion {
            player.listener = { event in
                if case .finished = event {
                    closure()
                }
            }
        }
    
        player.play()
    }
     
    private(set) var player: LocalPlayer!
    
    private override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
