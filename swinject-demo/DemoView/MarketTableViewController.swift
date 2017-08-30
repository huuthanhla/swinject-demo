//
//  MarketTableViewController.swift
//  swinject-demo
//
//  Created by Ominext Mobile's on 8/30/17.
//  Copyright © 2017 Ominext. All rights reserved.
//

import UIKit
import DemoViewModel

public final class MarketTableViewController: UITableViewController {
    public var viewModel: IMarketTableViewModel? {
        didSet {
            if let viewModel = viewModel {
                viewModel.cellModels.producer
                    .on(value: {
                        _ in self.tableView.reloadData()
                    })
                    .start()
            }
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.startGetMarkets()
    }
    
}

// MARK: UITableViewDataSource
extension MarketTableViewController {
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let viewModel = viewModel {
            return viewModel.cellModels.value.count
        }
        return 0
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MarketTableViewCell", for: indexPath) as! MarketTableViewCell
        cell.viewModel = viewModel.map { $0.cellModels.value[indexPath.row] }
        
        return cell
    }
}
