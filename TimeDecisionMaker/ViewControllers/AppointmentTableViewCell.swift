//
//  AppointmentTableViewCell.swift
//  TimeDecisionMaker
//
//  Created by Marina Lunts on 5/10/19.
//

import UIKit

class AppointmentTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lineImage: UIImageView!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var dateStarterImageView: UIImageView!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var eventWeekdayLabel: UILabel!
    @IBOutlet weak var noEventsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    public func UIforDayWithoutEvents() {
        noEventsLabel.isHidden = false
        summaryLabel.isHidden = true
        timeLabel.isHidden = true
        durationLabel.isHidden = true
        noEventsLabel.text = "No events for today :("
        
    }
    
    public func UIforDayWithEvents() {
        noEventsLabel.isHidden = true
        summaryLabel.isHidden = false
        timeLabel.isHidden = false
        durationLabel.isHidden = false
    }
    
    public func UIforTodayView() {
        dateStarterImageView.backgroundColor = UIColor(rgb: 0x555273)
        eventDateLabel.textColor = UIColor(rgb: 0x555273)
        
    }
    
    public func UIforFirstRow(dateValue: String, weekdayValue: String) {
        dateStarterImageView.isHidden = false
        eventDateLabel.isHidden = false
        eventDateLabel.text = dateValue
        eventWeekdayLabel.isHidden = false
        eventWeekdayLabel.text = weekdayValue
    }
    
    public func UIforOtherRow() {
        dateStarterImageView.isHidden = true
        eventDateLabel.isHidden = true
        eventWeekdayLabel.isHidden = true
    }
    
    public func makeRegularCellStyle() {
        backgroundColor = .white
        dateStarterImageView.backgroundColor = UIColor(rgb: 0x65799B)
        eventDateLabel.textColor = UIColor(rgb: 0x65799B)
    }
    
    private func updateUI() {
        dateStarterImageView.cornerRadiusRatio = 0.5
        makeRegularCellStyle()
    }


}

extension UIColor {
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
