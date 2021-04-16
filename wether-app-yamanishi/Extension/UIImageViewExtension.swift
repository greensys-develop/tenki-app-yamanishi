//
//  UIImageViewExtension.swift
//  wether-app-yamanishi
//
//  Created by Mayumi Yamanishi on 2021/04/15.
//

import UIKit

extension UIImageView {
    func setImageByDefault(with icon: String) {
        guard let url = URL(string: "https://openweathermap.org/img/w/\(icon).png") else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if error == nil, case .some(let result) = data, let image = UIImage(data: result) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            } else {
                print("error", error!)
            }
        }.resume()
    }
}
