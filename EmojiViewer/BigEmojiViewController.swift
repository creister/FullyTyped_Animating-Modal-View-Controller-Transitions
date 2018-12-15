//
//  BigEmojiViewController.swift
//  EmojiViewer
//
//  Created by Colin Reisterer on 12/14/18.
//  Copyright © 2018 FullyTyped. All rights reserved.
//

import UIKit

class BigEmojiViewController: UIViewController {

  private let emoji: String

  init(emoji: String) {
    self.emoji = emoji
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .black

    // Display the emoji at a large size in the center of the view!
    let label = UILabel()
    label.font = .systemFont(ofSize: 200)
    label.text = emoji
    view.addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

    // Dismiss if user taps anywhere to go back to list of all emojis
    let tapGR = UITapGestureRecognizer(target: self, action: #selector(handleViewTapped))
    view.addGestureRecognizer(tapGR)
  }

  @objc
  private func handleViewTapped() {
    dismiss(animated: true, completion: nil)
  }

}
