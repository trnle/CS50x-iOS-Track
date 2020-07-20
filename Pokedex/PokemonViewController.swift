import UIKit

class PokemonViewController: UIViewController {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var type1Label: UILabel!
    @IBOutlet var type2Label: UILabel!
    @IBOutlet var catchButton: UIButton!
    @IBOutlet var pokeImage: UIImageView!
    @IBOutlet var descriptionText: UITextView!
    
    var url: String!
    var name: String!
    var buttonPressed = false
    var pokedex = Pokedex.init(caught: [ : ])
    var defaults = UserDefaults.standard
    
    func capitalize(text: String) -> String {
        return text.prefix(1).uppercased() + text.dropFirst()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameLabel.text = ""
        numberLabel.text = ""
        type1Label.text = ""
        type2Label.text = ""
        descriptionText.text = ""
        
        loadPokemon()
    }
    
    func loadPokemon() {
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            do {
                let result = try JSONDecoder().decode(PokemonResult.self, from: data)
                DispatchQueue.main.async {
                    self.navigationItem.title = self.capitalize(text: result.name)
                    self.nameLabel.text = self.capitalize(text: result.name)
                    self.numberLabel.text = String(format: "#%03d", result.id)
                    
                    if self.defaults.bool(forKey: self.nameLabel.text!) == true {
                        self.pokedex.caught[self.nameLabel.text!] = true
                    }
                    if self.pokedex.caught[self.nameLabel.text!] == false || self.pokedex.caught[self.nameLabel.text!] == nil  {
                        self.catchButton.setTitle("Catch", for: .normal)
                    } else if self.pokedex.caught[self.nameLabel.text!] == true {
                        self.catchButton.setTitle("Release", for: .normal)
                    }
                    // add images of each pokemon
                    if let imageURL = URL(string: result.sprites.front_default) {
                        do {
                            let imageData = try Data(contentsOf: imageURL)
                            self.pokeImage.image = UIImage(data: imageData)
                        } catch let error {
                            print(error)
                        }
                    }
                    
                    for typeEntry in result.types {
                        if typeEntry.slot == 1 {
                            self.type1Label.text = typeEntry.type.name
                        }
                        else if typeEntry.slot == 2 {
                            self.type2Label.text = typeEntry.type.name
                        }
                    }
                    
                    self.loadDescription(pokemonID: result.id)
                }
            } catch let error {
                print(error)
            }
        }.resume()
    }
    // description for each pokemon
    func loadDescription(pokemonID: Int) {
        let descriptionURL = "https://pokeapi.co/api/v2/pokemon-species/\(pokemonID)"
        URLSession.shared.dataTask(with: URL(string: descriptionURL)!) {
            (data, response, error) in
            guard let data = data else {
                return
            }
            
            do {
                let result = try JSONDecoder().decode(PokemonSpeciesEntry.self, from: data)
                DispatchQueue.main.async {
                    for textEntry in result.flavor_text_entries {
                        if textEntry.language.name == "en" {
                            self.descriptionText.text = textEntry.flavor_text
                            break
                        }
                    }
                }
            } catch let error {
                print(error)
            }
        }.resume()
    }
    
    // method called when button is tapped
    @IBAction func toggleCatch() {
        // if caught, change "Catch" text to "Release" and vice versa
        if pokedex.caught[nameLabel.text!] == false || pokedex.caught[nameLabel.text!] == nil {
            catchButton.setTitle("Release", for: .normal)
            pokedex.caught[nameLabel.text!] = true
            defaults.set(true, forKey: nameLabel.text!)
        } else {
            catchButton.setTitle("Catch", for: .normal)
            pokedex.caught[nameLabel.text!] = false
            defaults.set(false, forKey: nameLabel.text!)
        }
    }
}
