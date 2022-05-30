//
//  NFTOfferTableView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 30/05/2022.
//

import Foundation
import UIKit

class NFTOffersTableView:UITableView{
    
    private var offers:NFTArtOffers = .init(repeating: .init(name: "John Doe", percent: "5.93", price: 12.03, time: 5), count: 5)
    
    init() {
        super.init(frame: .zero, style: .plain)
        self.translatesAutoresizingMaskIntoConstraints = false

        self.showsVerticalScrollIndicator = false
        self.isScrollEnabled = false
        self.separatorStyle = .none
    
        self.delegate = self
        self.dataSource = self
        self.register(NFTOfferTableViewCell.self, forCellReuseIdentifier: NFTOfferTableViewCell.identifier)
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK: - UITableViewDelegate/DataSource

extension NFTOffersTableView:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.offers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NFTOfferTableViewCell.identifier, for: indexPath) as? NFTOfferTableViewCell else {
            return UITableViewCell()
        }

        let offer = self.offers[indexPath.row]
        cell.updateCell(offer: offer)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.frame.height/CGFloat(self.offers.count)
    }
}
