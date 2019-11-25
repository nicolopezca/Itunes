//
//  UrlImageView.swift
//  itunes1
//
//  Created by Cristobal Ramos Laina on 25/11/2019.
//  Copyright © 2019 Cristobal Ramos Laina. All rights reserved.
//

import UIKit

final class UrlImageView: UIImageView  {
    private var url: String?
    func setImage(with url: String, with spinner: UIActivityIndicatorView) {
        self.url = url
        let api = ImageAPI(url: url)
        spinner.startAnimating()
        api.download { image in
            guard self.url == url else { return }
            self.image = image
            spinner.stopAnimating()
        }
    }
}
