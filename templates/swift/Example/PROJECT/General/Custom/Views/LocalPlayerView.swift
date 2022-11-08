//
//  LocalPlayerView.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

import UIKit
import AVFoundation

import AVFoundation
import SwifterKnife

final class LocalPlayer: NSObject {
    enum State {
        case paused
        case changeItem
        case finished
        case playing
        case reset
    }
    private(set) var layer: AVPlayerLayer
    private(set) var player: AVPlayer
    private var state: State = .paused
    
    var listener: ((State) -> Void)?
    var loop = false
    
    var isMuted: Bool {
        get { player.isMuted }
        set { player.isMuted = newValue }
    }
    init(player: AVPlayer) {
        self.player = player
        player.isMuted = true
        layer = AVPlayerLayer(player: player).then {
            $0.videoGravity = .resizeAspectFill
            $0.shouldRasterize = true
            $0.rasterizationScale = UIScreen.main.scale
        }
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didPlayToEnd(_:)), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    convenience override init() {
        self.init(player: AVPlayer())
    }
    convenience init?(filename: String) {
        guard let item = Self.avplayerItem(with: filename) else {
            return nil
        }
        self.init(player: AVPlayer(playerItem: item))
    }
    convenience init(url: URL) {
        self.init(player: AVPlayer(url: url))
    }
    convenience init(item: AVPlayerItem) {
        self.init(player: AVPlayer(playerItem: item))
    }
    
    var size: CGSize? {
        guard let item = player.currentItem,
              let size = item.asset.tracks(withMediaType: .video).first?.naturalSize else {
                  return nil
              }
        return size * 0.5
    }
    var duration: TimeInterval? {
        guard let item = player.currentItem else {
            return nil
        }
        return TimeInterval(CMTimeGetSeconds(item.duration))
    }
    var current: TimeInterval? {
        guard let item = player.currentItem else {
            return nil
        }
        return TimeInterval(CMTimeGetSeconds(item.currentTime()))
    }
    var error: Error? {
        if let item = player.currentItem,
           let error = item.error { return error }
        return player.error
    }
    func seek(to time: TimeInterval) {
        let cmtime = CMTime(seconds: time, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player.seek(to: cmtime, toleranceBefore: .zero, toleranceAfter: .zero)
    }
    
    private var playCompletion: ((Error?) -> Void)?
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let item = object as? AVPlayerItem,
              item === player.currentItem else {
                  return
              }
        if keyPath == "status" {
            item.removeObserver(self, forKeyPath: "status")
            switch item.status {
            case .readyToPlay:
                player.play()
                state = .playing
                listener?(.playing)
                playCompletion?(nil)
            default:
                let error = item.error ?? player.error
                Console.trace("play failed \(String(describing: error))")
                playCompletion?(error)
            }
            playCompletion = nil
        }
    }
    
    @discardableResult
    func play(file filename: String? = nil,
              completion: ((Error?) -> Void)? = nil) -> Bool {
        if let filename = filename {
            if let item = Self.avplayerItem(with: filename) {
                player.pause()
                state = .changeItem
                listener?(.changeItem)
                player.replaceCurrentItem(with: item)
            } else {
                completion?(NSError(domain: AVFoundationErrorDomain, code: -12121, userInfo: [NSLocalizedDescriptionKey: "create AVPlayerItem failed"]))
                return false
            }
        }
        guard let item = player.currentItem else {
            completion?(NSError(domain: AVFoundationErrorDomain, code: -12122, userInfo: [NSLocalizedDescriptionKey: "no current play item"]))
            return false
        }
        switch item.status {
        case .failed:
            completion?(item.error ?? player.error)
            return false
        case .readyToPlay:
            player.play()
            state = .playing
            listener?(.playing)
            completion?(nil)
            return true
        case .unknown:
//            item.addObserver(self, forKeyPath: "status", options: .new, context: nil)
//            playCompletion = completion
            DispatchQueue.main.async {
                self.player.play()
                self.state = .playing
                self.listener?(.playing)
                completion?(nil)
            }
            return true
        @unknown default:
            completion?(item.error ?? player.error)
            return false
        }
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
        player.pause()
        player.seek(to: .zero)
        state = .reset
        listener?(.reset)
        listener = nil
    }
    deinit {
        Console.log("\(type(of: self)) deinit")
//        removeStatusListen()
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func didPlayToEnd(_ noti: Notification) {
        guard let item = noti.object as? AVPlayerItem else { return }
        guard item === player.currentItem else { return }
        state = .finished
        listener?(.finished)
        player.pause()
        guard loop else { return }
        player.seek(to: .zero)
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
    
    init(player: LocalPlayer, frame: CGRect = .zero) {
        self.player = player
        super.init(frame: frame)
        layer.addSublayer(self.player.layer)
    }
    convenience override init(frame: CGRect) {
        self.init(player: LocalPlayer(), frame: frame)
    }
    convenience init(filename: String, frame: CGRect = .zero) {
        guard let player = LocalPlayer(filename: filename) else {
            fatalError()
        }
        self.init(player: player, frame: frame)
    }
    convenience init(url: URL, frame: CGRect = .zero) {
        let player = LocalPlayer(url: url)
        self.init(player: player, frame: frame)
    }
    
    var isMuted: Bool {
        get { player.isMuted }
        set { player.isMuted = newValue }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        player.layer.frame = bounds
    }
    override var intrinsicContentSize: CGSize {
        player.size ?? super.intrinsicContentSize
    }
    func pause() {
        player.pause()
    }
    func reset() {
        player.reset()
    }
    
    func playCallbacked(file filename: String? = nil,
                        callback: @escaping (Error?) -> Void) {
        player.play(file: filename, completion: callback)
    }
    func play(file filename: String? = nil,
              finished: (() -> Void)? = nil) {
        player.play(file: filename)
        if let closure = finished {
            player.listener = { event in
                if case .finished = event {
                    closure()
                }
            }
        }
    }
    
    let player: LocalPlayer
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


