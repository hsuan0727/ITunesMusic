//
//  MusicTableViewCell.swift
//  ITunesMusic
//
//  Created by Hsuan on 2021/12/7.
//

import UIKit
import SDWebImage

class MusicTableViewCell: UITableViewCell {

    @IBOutlet weak var musicImage: UIImageView!
    
    @IBOutlet weak var songNameLabel: UILabel!
    
    
    @IBOutlet weak var artistNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func imageUrl(imageUrl:String) {
        loadImage(url: imageUrl, imageView: musicImage)
    }
    
    private func loadImage(url: String?, imageView: UIImageView) {

            guard let imageUrl = URL(string: url ?? "") else { return }

            imageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(systemName: "music.note.list"), options: [], progress: nil, completed: nil)

        
    }
    
}
