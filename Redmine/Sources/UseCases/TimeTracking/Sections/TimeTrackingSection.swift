//
//  TimeTrackingSection.swift
//  Redmine
//
//  Created by Anderson Lucas C. Ramos on 12/05/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import GenericDataSourceSwift

enum PlayPauseAction {
    case play
    case pause
}

protocol TimeTrackingTableViewCellProtocol: class {
    func playPauseAction(for tracker: TimeTracker, finishAction callThis: ((_ action: PlayPauseAction) -> Void))
    func publishAction(for tracker: TimeTracker)
    func state(for item: TimeTracker) -> PlayPauseAction
}

class TimeTrackingSection: Section {
    weak var delegate: TimeTrackingTableViewCellProtocol?
    
    override func cellType(for index: Int) -> UITableViewCell.Type {
        return TimeTrackingTableViewCell.self
    }
    
    override func cellHeight(for index: Int) -> CGFloat {
        return 100
    }
    
    override func estimatedCellHeight(for index: Int) -> CGFloat {
        return 100
    }
    
    func cellPostConfiguration(for cell: UITableViewCell, at indexPath: IndexPath) {
        guard let cell = cell as? TimeTrackingTableViewCell else { return }
        cell.playPauseButton.tag = indexPath.row
        cell.publishButton.tag = indexPath.row
        if cell.playPauseButton.actions(forTarget: self, forControlEvent: .touchUpInside) == nil {
            cell.playPauseButton.addTarget(self, action: #selector(self.playPauseButton(sender:)), for: .touchUpInside)
            cell.publishButton.addTarget(self, action: #selector(self.publishButton(sender:)), for: .touchUpInside)
        }
        self.configureState(for: cell, at: indexPath)
        self.configureBackground(for: cell, at: indexPath)
    }
    
    fileprivate func configureState(for cell: TimeTrackingTableViewCell, at indexPath: IndexPath) {
        if let state = self.delegate?.state(for: self.getItem(for: indexPath.row)) {
            cell.playPauseButton.setBackgroundImage(state == .play ? #imageLiteral(resourceName: "play") : #imageLiteral(resourceName: "pause"), for: .normal)
        }
    }
    
    fileprivate func configureBackground(for cell: TimeTrackingTableViewCell, at indexPath: IndexPath) {
        cell.backgroundColor = indexPath.row % 2 == 0 ? #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 0.1531999144) : UIColor.white
    }
    
    @objc fileprivate func playPauseButton(sender: UIButton) {
        let index = sender.tag
        let tracker: TimeTracker = self.getItem(for: index)
        var hasCalledFinishAction = false
        self.delegate?.playPauseAction(for: tracker, finishAction: { (action) in
            sender.setBackgroundImage(action == .pause ? #imageLiteral(resourceName: "play") : #imageLiteral(resourceName: "pause"), for: .normal)
            hasCalledFinishAction = true
        })
        assert(hasCalledFinishAction, "YOU MUST CALL FINISH ACTION WITH THE EXECUTED ACTION")
    }
    
    @objc fileprivate func publishButton(sender: UIButton) {
        let index = sender.tag
        let tracker: TimeTracker = self.getItem(for: index)
        self.delegate?.publishAction(for: tracker)
    }
}