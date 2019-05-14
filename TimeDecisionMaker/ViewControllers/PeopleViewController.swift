//
//  PeopleViewController.swift
//  TimeDecisionMaker
//
//  Created by Marina Lunts on 5/12/19.
//

import UIKit

class PeopleViewController: UIViewController {

    private var organizerICSPath = "A"
    private var attendeeICSPath = "B"
    var selectedPerson : Person?
    
    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appendPersonToPeopleArray()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func appendPersonToPeopleArray() {
        people.append(Person(name: "Person 1", ICSPath: organizerICSPath))
        people.append(Person(name: "Person 2", ICSPath: attendeeICSPath))
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToPersonApointments") {
            let vc = segue.destination as! ViewController
            
            vc.selectedPerson = selectedPerson
        }
    }
}

extension PeopleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "peopleCell", for: indexPath) as! PeopleTableViewCell
        cell.personNameLabel.text = people[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPerson = people[indexPath.row]
        performSegue(withIdentifier: "goToPersonApointments", sender: nil)
    }
    
    
}


class PeopleTableViewCell : UITableViewCell {
    
    @IBOutlet weak var personNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
