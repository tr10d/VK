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

}
