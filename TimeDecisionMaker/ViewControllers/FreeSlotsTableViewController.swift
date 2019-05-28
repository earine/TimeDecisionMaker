//
//  FreeSlotsTableViewController.swift
//  TimeDecisionMaker
//
//  Created by Marina Lunts on 5/26/19.
//

import UIKit

class FreeSlotsTableViewController: UIViewController {

    public var firstPerson = Person()
    public var secondPerson = Person()
    private var freeSlots = [DateInterval]()
    
    @IBOutlet weak var noFreeSlotsView: UIView!
    @IBOutlet weak var freeSlotsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        freeSlots = RDTimeDecisionMaker().suggestAppointments(organizerICS: firstPerson.ICSPath, attendeeICS: secondPerson.ICSPath, duration: 600)

       
    }
}

extension FreeSlotsTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if freeSlots.count > 0 {
            freeSlotsTable.isHidden = false
            noFreeSlotsView.isHidden = true
            return freeSlots.count
        } else {
            noFreeSlotsView.isHidden = false
            freeSlotsTable.isHidden = true
        }
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "slotCell", for: indexPath) as! FreeSlotTableViewCell
        if freeSlots.count > 0 {
            cell.startDateLabel.text = freeSlots[indexPath.row].start.dateToString()
            cell.endDateLabel.text = freeSlots[indexPath.row].end.dateToString()
        }
        return cell
    }
}
