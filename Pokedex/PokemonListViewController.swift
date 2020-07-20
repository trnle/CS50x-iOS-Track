import UIKit

class PokemonListViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    
    // original pokemon results from API
    var pokemon: [PokemonListResult] = []
    // filtered search results from original
    var filteredPokemon: [PokemonListResult] = []
    var defaults = UserDefaults.standard
    
    func capitalize(text: String) -> String {
        return text.prefix(1).uppercased() + text.dropFirst()
    }
    // load api
    override func viewDidLoad() {
        super.viewDidLoad()
        // set delegate property of search bar to be instance of pkvcontroller
        tableView.backgroundColor = UIColor.lightGray
        searchBar.delegate = self
        
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=151") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            do {
                let entries = try JSONDecoder().decode(PokemonListResults.self, from: data)
                self.pokemon = entries.results
                self.filteredPokemon = self.pokemon
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            catch let error {
                print(error)
            }
        }.resume()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPokemon.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)
        let pokemonList = filteredPokemon[indexPath.row]
        cell.textLabel?.text = pokemonList.name.capitalized
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPokemonSegue",
            let destination = segue.destination as? PokemonViewController,
            let index = tableView.indexPathForSelectedRow?.row {
            destination.url = filteredPokemon[index].url
        }
    }
    // when user changes text in search bar, this method is called
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredPokemon = pokemon.filter({ (entries: PokemonListResult) -> Bool in
            return entries.name.contains(searchText.lowercased()) || searchText == ""
        })
        tableView.reloadData()
    }
}
