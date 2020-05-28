//
//  GraphReportTableViewCell.swift
//  Budget
//
//  Created by Anatoliy Anatolyev on 04.05.2020.
//  Copyright © 2020 Anatoliy Anatolyev. All rights reserved.
//

import UIKit

class GraphReportTableViewCell: UITableViewCell {

    
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet weak var colorIndicatorView: GraphReportTableViewCell!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    func setupCellFor(compareObject: CompareObjectModel)  {
        valueLabel.text = String(compareObject.value)
        colorIndicatorView.backgroundColor = compareObject.color
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
