//
//  AsyncFriendsPhotoCollectionViewController.swift
//  VK
//
//  Created by  Sergei on 23.04.2021.
//

import UIKit
import RealmSwift
import AsyncDisplayKit

class AsyncFriendsPhotoCollectionViewController: ASDKViewController<ASDisplayNode> {

  private var user: RealmUser?
  private var photos: Results<RealmPhoto>?
  private var notificationToken: NotificationToken?

  override func viewDidLoad() {
    super.viewDidLoad()

  }
}
