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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 6
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            BProgressHUD.showLoadingView()
            BProgressHUD.dismissHUD(delay: 5)
            break
        case 1:
            BProgressHUD.showSuccessMessageAutoHide(delay: 2, msg: "test这是长一点内容的测试")
            
            break
        case 2:
            BProgressHUD.showErrorMessageAutoHide(delay: 2, msg: "test", dismissBlock: nil)
            break
        case 3:
            BProgressHUD.showLoadingViewWithMessage(msg: "Loading...")
            BProgressHUD.dismissHUD(delay: 5)
            break
        case 4:
            BProgressHUD.showOnlyMessageAutoHide(delay: 2, msg: "只显示文本信息", dismissBlock: nil)
            break
        case 5: 
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DemoViewController") as! DemoViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
            break
        
            
        default:
            
            break
        }
    }

}
