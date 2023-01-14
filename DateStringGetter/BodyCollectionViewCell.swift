//
//  CollectionViewCell.swift
//  DateStringGetter
//
//  Created by Jaappao on 2023/01/13.
//

import UIKit


class bodyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var profileImageFrameView: UIView!

    private let selectedFrameColor: CGColor = UIColor.tintColor.cgColor
    private let defaultFrameColor: CGColor = UIColor.systemGray5.cgColor

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override var isSelected: Bool {
        didSet {
            // 選択状態が切り替わった時に実行される
            self.profileImageFrameView.layer.borderColor = isSelected ? selectedFrameColor : defaultFrameColor
        }
    }

    func setup() {
        profileImageFrameView.frame = bounds // これを指定しないと楕円形になる(https://blog.ch3cooh.jp/entry/ios/corner_radius_on_uicollection_view_cell)
        profileImageFrameView.layer.borderWidth = 1
        profileImageFrameView.layer.borderColor = defaultFrameColor
        profileImageFrameView.layer.cornerRadius = profileImageFrameView.layer.frame.height / 2
    }
}

