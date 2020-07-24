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
        return (sections[.additionalSound]!.count > 0) ? 3 : 2
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
            switch mode {
            case .sleep:
                let timeDurationCell = collectionView.dequeueReusableCell(withReuseIdentifier: TimeDurationCell.reuseIdentifier, for: indexPath) as! TimeDurationCell
                let time = sections[sectionKind]!.first as! AlarmTime
                timeDurationCell.configureCell(with: time, mode: mode)
                timeDurationCell.delegate = self
                
                return timeDurationCell
                
            case .wakeUp:
                let timeCell = collectionView.dequeueReusableCell(withReuseIdentifier: TimeRangeCell.reuseIdentifier, for: indexPath) as! TimeRangeCell
                let time = sections[sectionKind]!.first as! AlarmTime
                timeCell.configureCell(with: time, mode: mode)
                timeCell.delegate = self
                
                return timeCell
            }
            
        case .additionalSound, .mainSound:
            let soundCell = collectionView.dequeueReusableCell(withReuseIdentifier: SoundCell.reuseIdentifier, for: indexPath) as! SoundCell
            let sound = sections[sectionKind]![indexPath.row] as! Sound
            soundCell.configure(with: sound)
            soundCell.delegate = self
            if sound.fileNamePlusExtension == Globals.alarm(mode).mainSoundFileName {
                soundCell.setSelected(mode)
                pickedMainSound = sound
            }
            
            if sound.fileNamePlusExtension == Globals.alarm(mode).secondarySoundFileName {
                soundCell.setSelected(mode)
                pickedSecondSound = sound
            }
            
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
        headerView.titleLabel.text = sectionKind.title(mode)
        
        return headerView
    }
    
    //MARK:- Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //    print("did select item at indexPath \(indexPath)")
        guard let sectionKind = Section(rawValue: indexPath.section) else {
            fatalError("Invalid section kind")
        }
        
        hapticsGenerator.impactOccurred()
        switch sectionKind {
        case .time:
            break
        case .additionalSound:
            guard let cell = collectionView.cellForItem(at: indexPath) as? SoundCell,
                let sound = sections[sectionKind]?[indexPath.row] as? Sound else { return }
            deselectItems(in: collectionView, at: sectionKind)
            cell.setSelected(mode)
            
            Globals.alarm(mode).secondarySoundFileName = sound.fileNamePlusExtension
            pickedSecondSound = sound
          //  schdeuleCurrentNotification(mode)
        case .mainSound:
            guard let cell = collectionView.cellForItem(at: indexPath) as? SoundCell,
                let sound = sections[sectionKind]?[indexPath.row] as? Sound else { return }
            deselectItems(in: collectionView, at: sectionKind)
            cell.setSelected(mode)
            
            Globals.alarm(mode).mainSoundFileName = sound.fileNamePlusExtension
            pickedMainSound = sound
           // schdeuleCurrentNotification(mode)
        }
        
        AudioHelper.mergeAudios(mainSound: pickedMainSound, secondSound: pickedSecondSound) { (url, error) in
            print(error ?? "success")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return indexPath.section != 0
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
                        
            return CGSize(width: width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
}


extension SettingsViewController {
    func deselectItems(in collectionView: UICollectionView, at section: Section) {
        collectionView.indexPathsForVisibleItems.forEach { (indexPath) in
            if Section(rawValue: indexPath.section) == section  {
                collectionView.deselectItem(at: indexPath, animated: true)
                if let cell = collectionView.cellForItem(at: indexPath) as? SoundCell {
                    cell.deselect()
                }
            }
        }
    }
    
    func pausePlayers(in collectionView: UICollectionView, at section: Section) {
        collectionView.indexPathsForVisibleItems.forEach { (indexPath) in
            if Section(rawValue: indexPath.section) == section  {
                if let cell = collectionView.cellForItem(at: indexPath) as? SoundCell {
                    cell.pause()
                }
            }
        }
    }
    
    func pauseAllPlayers() {
        settingsCollectionView.visibleCells.forEach {
            if let cell = $0 as? SoundCell {
                cell.pause()
            }
        }
    }
}
