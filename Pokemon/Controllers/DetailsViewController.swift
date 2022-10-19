//
//  DetailsViewController.swift
//  Pokemon
//
//  Created by Kevin Reid on 17/10/2022.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    var pokemonDetails: RemotePokemonDetails?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for type in pokemonDetails!.types {
            print("Type \(type)")
        }
        
        nameLabel.text = pokemonDetails?.name ?? ""
        weightLabel.text = String(pokemonDetails?.weight ?? 0)
        heightLabel.text = String(pokemonDetails?.height ?? 0)
    }
}
