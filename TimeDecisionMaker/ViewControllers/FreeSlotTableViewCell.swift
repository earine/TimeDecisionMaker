//
//  FreeSlotTableViewCell.swift
//  TimeDecisionMaker
//
//  Created by Marina Lunts on 5/26/19.
//

import UIKit

class FreeSlotTableViewCell: UITableViewCell {

    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
