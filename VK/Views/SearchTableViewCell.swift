//
//  SearchTableViewCell.swift
//  VK
//
//  Created by  Sergei on 21.01.2021.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var searchBar: UISearchBar!

    static let nib = UINib(nibName: "SearchTableViewCell", bundle: nil)
    static let identifier = "Cell"

}
