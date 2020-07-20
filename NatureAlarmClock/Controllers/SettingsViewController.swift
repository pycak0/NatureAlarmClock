//
//MARK:  SettingsViewController.swift
//  NatureAlarmClock
//
//  Created by Владислав on 20.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    enum Section: Int, CaseIterable {
        case time, mainSound, additionalSound
        
        var title: String {
            switch self {
            case .time:
                return "Начало и конец мелодии"
            case .mainSound:
                return "Основная мелодия"
            case .additionalSound:
                return "Дополнительные звуки"
            }
        }
    }

    @IBOutlet weak var settingsCollectionView: UICollectionView!
    var mode: AlarmView.AlarmMode!
    
    var sections: [Section: [Any]] = [
        .time : [],
        .mainSound : [
            Sound(name: "Рассвет", file: "", withExtension: ""),
            Sound(name: "Прибой", file: "", withExtension: ""),
            Sound(name: "Лес", file: "", withExtension: ""),
            Sound(name: "Море", file: "", withExtension: ""),
            Sound(name: "Поле", file: "", withExtension: "")
        ],
        .additionalSound : [
            Sound(name: "Чайка", file: "", withExtension: ""),
            Sound(name: "Дятел", file: "", withExtension: ""),
            Sound(name: "Петух", file: "", withExtension: "")
        ]
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarTitleView(text: mode.message, tintColor: mode.color)
        configureCollectionView()
    }
    
    func configureCollectionView() {
        settingsCollectionView.delegate = self
        settingsCollectionView.dataSource = self
    }
    
    func cellSizeForDevice() -> CGSize {
        let edgeinsets: CGFloat = 16
        let interItemSpacing: CGFloat = 2
        let itemsPerRow: CGFloat = 3
        let aspectRatio = CGFloat(10) / 13
        let width = (settingsCollectionView.frame.width /*- 2 * edgeinsets - interItemSpacing * (itemsPerRow - 1)*/) / itemsPerRow
        let height = width / aspectRatio
        
        return CGSize(width: width, height: height)
    }

}


//MARK:- Collection View Data Source
extension SettingsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[Section.allCases[section]]!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let soundCell = collectionView.dequeueReusableCell(withReuseIdentifier: SoundCell.reuseIdentifier, for: indexPath) as! SoundCell
        guard let sectionKind = Section(rawValue: indexPath.section),
            let sound = sections[sectionKind]?[indexPath.row] as? Sound else {
            fatalError("Invalid section kind or data type")
        }
        soundCell.configure(with: sound)
        
        return soundCell
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
        //return cellSizeForDevice()
        CGSize(width: 111, height: CGFloat(111) * 13 / 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
}
