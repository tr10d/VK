//
//  SearchView.swift
//  VK
//
//  Created by  Sergei on 21.01.2021.
//

import UIKit

final class SearchView: UITableViewHeaderFooterView {

    @IBOutlet private weak var searchBar: UISearchBar!

    static let nib = UINib(nibName: "SearchView", bundle: nil)
    static let identifier = "Cell"

}
