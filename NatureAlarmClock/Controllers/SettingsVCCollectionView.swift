//
//  SettingsVCCollectionView.swift
//  NatureAlarmClock
//
//  Created by Владислав on 20.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

//MARK:- Collection View Data Source

extension SettingsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[Section.allCases[section]]!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionKind = Section(rawValue: indexPath.section) else {
            fatalError("Invalid section kind or data type")
        }
        
        switch sectionKind {
        case .time:
            let timeCell = collectionView.dequeueReusableCell(withReuseIdentifier: TimeCell.reuseIdentifier, for: indexPath) as! TimeCell
            let time = sections[sectionKind]!.first as! AlarmTime
            timeCell.configure(with: time, mode: mode)
            
            return timeCell
            
        case .additionalSound, .mainSound:
            let soundCell = collectionView.dequeueReusableCell(withReuseIdentifier: SoundCell.reuseIdentifier, for: indexPath) as! SoundCell
            let sound = sections[sectionKind]![indexPath.row] as! Sound
            soundCell.configure(with: sound)
            
            return soundCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            fatalError("Invalid supplementary view kind")
        }
        guard let sectionKind = Section(rawValue: indexPath.section) else {
            fatalError("Invalid section kind")
        }
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.reuseIdentifier, for: indexPath) as! SectionHeaderView
        headerView.titleLabel.text = sectionKind.title
        
        return headerView
    }
    
    //MARK:- Delegate
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        print("did highlight item at indexPath \(indexPath)")
        guard let cell = collectionView.cellForItem(at: indexPath),
            Section(rawValue: indexPath.section)! != .time else { return }
        
        cell.contentView.layer.borderWidth = 2
        cell.contentView.layer.borderColor = mode.color.cgColor
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        cell.contentView.layer.borderWidth = 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("did select item at indexPath \(indexPath)")
        guard let sectionKind = Section(rawValue: indexPath.section) else {
            fatalError("Invalid section kind")
        }
        
        switch sectionKind {
        case .time:
            break
        case .additionalSound, .mainSound:
            guard let cell = collectionView.cellForItem(at: indexPath) as? SoundCell else { return }
            cell.isPlaying ? cell.pause() : cell.play()
        }
    }
}

//MARK:- Layout

extension SettingsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let sectionKind = Section(rawValue: indexPath.section) else { fatalError("Invalid section kind") }
        switch sectionKind {
        case .time:
            return CGSize(width: settingsCollectionView.frame.width, height: 65)
        
        case .additionalSound, .mainSound:
            let edgeinsets: CGFloat = 16
            let interItemSpacing: CGFloat = 5
            let itemsPerRow: CGFloat = 3
            let aspectRatio = CGFloat(10) / 13
            let width = (settingsCollectionView.frame.width - 2 * edgeinsets - interItemSpacing * (itemsPerRow - 1)) / itemsPerRow
            let height = width / aspectRatio
            
            print(settingsCollectionView.frame.width)
            print(width)
            
            return CGSize(width: width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
}
