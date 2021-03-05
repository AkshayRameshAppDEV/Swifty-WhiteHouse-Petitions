//
//  ViewController.swift
//  Swifty White House
//
//  Created by Akshay Ramesh on 12/30/20.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var defaultPetitions = [Petition]()
    var filterPetitionsArr = [Petition]()
    var urlString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showCredits))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(filterPetitions))
        performSelector(inBackground: #selector(fetchJSON), with: nil)
    }
    
    @objc func fetchJSON() {
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    
    @objc func filterPetitions() {
        let petitionsController = UIAlertController(title: "Filter Petitions", message: "Enter a string to display petitions related to the string", preferredStyle: .alert)
        petitionsController.addTextField()
        let addAction = UIAlertAction(title: "Filter", style: .default) { [weak self, weak petitionsController] _ in
            guard let petition = petitionsController?.textFields?[0].text else { return }
            self?.filter(petition)
        }
        petitionsController.addAction(addAction)
        present(petitionsController, animated: true)
    }
    
    func filter(_ petition: String) {
        filterPetitionsArr.removeAll()
        for p in defaultPetitions {
            if p.title.contains(petition) {
                filterPetitionsArr.append(p)
            }
        }
        petitions = filterPetitionsArr
        tableView.reloadData()
    }
    
    @objc func showCredits() {
        let ac = UIAlertController(title: "Credits", message: "The petitions data comes from the We The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func showError() {
        let ac = UIAlertController(title: "Loading Error", message: "The was some server issue", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            defaultPetitions = petitions
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

