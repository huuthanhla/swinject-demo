//
//  MarketTableViewCell.swift
//  swinject-demo
//
//  Created by Ominext Mobile's on 8/30/17.
//  Copyright © 2017 Ominext. All rights reserved.
//

import UIKit
import DemoViewModel
import Alamofire
import AlamofireImage

internal final class MarketTableViewCell: UITableViewCell {
    internal var viewModel: IMarketTableViewCellModel? {
        didSet {
            lblMarketName.text = viewModel?.marketName
            if let logo = viewModel?.logoUrl {
                imgLogo.af_setImage(withURL: URL(string: logo)!)
            }
        }
    }
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblMarketName: UILabel!
}
