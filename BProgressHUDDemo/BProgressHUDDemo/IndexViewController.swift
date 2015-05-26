//
//  IndexViewController.swift
//  BProgressHUDDemo
//
//  Created by Brant on 5/26/15.
//  Copyright (c) 2015 brant. All rights reserved.
//

import UIKit

class IndexViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 5
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            BProgressHUD.showLoadingView()
            BProgressHUD.dismissHUD(5)
            break
        case 1:
            BProgressHUD.showSuccessMessageAutoHide(2, msg: "test这是长一点内容的测试")
            break
        case 2:
            BProgressHUD.showErrorMessageAutoHide(2, msg: "test", dismissBlock: nil)
            break
        case 3:
            BProgressHUD.showLoadingViewWithMessage("Loading...")
            BProgressHUD.dismissHUD(5)
            break
        case 4:
            BProgressHUD.showOnlyMessageAutoHide(2, msg: "只显示文本信息", dismissBlock: nil)
            break
            
        default:
            
            break
        }
    }

}
