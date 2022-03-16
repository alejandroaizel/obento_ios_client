//
//  ContentSizedTableView.swift
//  Obento
//
//  Created by Alejandro Aizel Boto on 16/3/22.
//

import UIKit

class ContentSizedTableView: UITableView {
    override var contentSize:CGSize {
            didSet {
                invalidateIntrinsicContentSize()
            }
        }

        override var intrinsicContentSize: CGSize {
            layoutIfNeeded()
            return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
        }

}
