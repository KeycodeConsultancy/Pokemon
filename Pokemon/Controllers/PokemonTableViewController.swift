//
//  PokemonTableViewController.swift
//  
//
//  Created by Kevin Reid on 15/10/2022.
//

import UIKit

class PokemonTableViewController: UITableViewController {
    private var pokemons = [PokemonViewModel]()
    private var offset = 0
    private var limit = 20
    private var isDataLoading = false
    private var didEndReached = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        Task {
            await fetchPokemons()
        }
    }
    
    private func fetchPokemons() async {
        do {
            self.pokemons = try await PokemonListViewModel().fetchAllPokemons(offset: 20, limit: limit)
            self.loadTableView()
        } catch {
            print("Error  \(error.localizedDescription)")
        }
    }
    
    private func loadTableView() {
        Task { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pokemons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = self.pokemons[indexPath.row].name.capitalized
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        guard let pokemonId = self.pokemons[indexPath.row].id else {
            return
        }
        
        Task {
            var pokemonDetails: RemotePokemonDetails!
            try await pokemonDetails = (getDetails(pokemonId: pokemonId))
            var viewController = DetailsViewController()
             viewController = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
            viewController.pokemonDetails = pokemonDetails
             self.navigationController?.pushViewController(viewController, animated: true)
        }
    }

    func getDetails(pokemonId: String) async throws -> RemotePokemonDetails? {
        var pokemonDetails: RemotePokemonDetails!
        pokemonDetails = try await PokemonListViewModel().fetchPokemonDetailsByID(id: pokemonId)
        return pokemonDetails
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDataLoading = false
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {}
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height)
        {
            if !isDataLoading && limit <= pokemonsMaxRecordsCount  {
                isDataLoading = true
                limit += 20
                Task {
                    await fetchPokemons()
                }
            }
        }
    }
}
