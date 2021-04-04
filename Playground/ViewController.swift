//
//  ViewController.swift
//  Playground
//
//  Created by Kenichi Saito on 2021/03/12.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        view.backgroundColor = Color.Theme.main

        let button = NeomorphicButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Tap", for: .normal)
        button.addTarget(self, action: #selector(ViewController.tap), for: .touchUpInside)

        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            button.widthAnchor.constraint(equalToConstant: 40),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @objc
    func tap() {
        print("Original: ViewController")
    }
}

