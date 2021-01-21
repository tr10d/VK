//
//  SearchView.swift
//  VK
//
//  Created by  Sergei on 21.01.2021.
//

import UIKit

class SearchView: UITableViewHeaderFooterView {

    @IBOutlet weak var searchBar: UISearchBar!

    static let nib = UINib(nibName: "SearchView", bundle: nil)
    static let identifier = "Cell"

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
