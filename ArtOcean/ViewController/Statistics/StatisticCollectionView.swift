//
//  StatisticCollectionView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 02/06/2022.
//

import Foundation
import UIKit


enum StatisticsTab:String{
    case ranking = "Ranking"
    case activity = "Activity"
    case none = ""
}

extension StatisticsTab{
    mutating func fetchEnum(value:String){
        switch(value){
            case "Ranking":
                self = .ranking
            case "Activity":
                self = .activity
            default:
                self = .none
        }
    }
}

class StatisticCollectionView:UICollectionViewController{
    
    private var data:[Any] = Array(repeating: 0, count: 100)
    private var cellName:String = ""
    public var tab:StatisticsTab
    
    public var buttonDelegate:CustomButtonDelegate? = nil
    
    init(cellType:StatisticsTab,data:[Any]? = nil){
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: UIScreen.main.bounds.width - 48, height: 50)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 20
        self.tab = cellType
        if let safeData = data{
            self.data = safeData
        }
        
        super.init(collectionViewLayout: layout)
        self.collectionView.showsVerticalScrollIndicator = false
        
        if cellType == .ranking{
            cellName = StatisticRankingCollectionViewCell.identifier
            self.collectionView.register(StatisticRankingCollectionViewCell.self, forCellWithReuseIdentifier: StatisticRankingCollectionViewCell.identifier)
        }else{
            cellName = StatisticActivityCollectionViewCell.identifier
            self.collectionView.register(StatisticActivityCollectionViewCell.self, forCellWithReuseIdentifier: StatisticActivityCollectionViewCell.identifier)
        }
        
        self.collectionView.backgroundColor = .clear
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let safeFlowlayout = self.collectionViewLayout as? UICollectionViewFlowLayout{
            safeFlowlayout.itemSize = .init(width: self.collectionView.frame.width, height: 50)
        }
    }
}

//MARK: - StatisticCollectionViewController UICollectionDelegate
extension StatisticCollectionView{
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellName, for: indexPath) as? StatisticRankingCollectionViewCell{
            cell.updateCell(idx: indexPath.row + 1)
            cell.buttonDelegate = self.buttonDelegate
            return cell
        } else if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellName, for: indexPath) as? StatisticActivityCollectionViewCell {
            if let item = self.data[indexPath.row] as? Item{
                cell.configure(item)
            }
            cell.buttonDelegate = self.buttonDelegate
            return cell
        }else {
            return UICollectionViewCell()
        }
    }
    
}
