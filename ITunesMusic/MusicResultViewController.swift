//
//  MusicResultViewController.swift
//  ITunesMusic
//
//  Created by Hsuan on 2021/12/7.
//

import UIKit
import RxSwift
import RxRelay
import JGProgressHUD
import AVFoundation
import MediaPlayer

class MusicResultViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    private enum Action:String {
        case previous = "上一首"
        case next = "下一首"
    }
    
    @IBOutlet weak var mainTableView: UITableView! {
        didSet {
            mainTableView.isHidden = true
        }
    }
    
    @IBOutlet weak var defaultSearchNameLabel: UIView!
    @IBOutlet weak var musicNameLabel: UILabel!
    
    
    private lazy var player:AVPlayer = {
        AVPlayer()
    }()
    private var playItem: AVPlayerItem?
    private var currentRow = 0 //記錄當下音樂播放的index
   
    private var musicResult = SearchMusicResponse()
    private var compositeDisposable:CompositeDisposable = CompositeDisposable()
    private var disposeKey:CompositeDisposable.DisposeKey? = nil
    private lazy var searchMusicViewModel: SearchMusicViewModel = {
        SearchMusicViewModel(composite: compositeDisposable, searchMusicRepository: SearchMusicRepository())
    }()
    
    private lazy var hud: JGProgressHUD = {
        JGProgressHUD()
    }()
    private var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rigesterCell()
        hud.textLabel.text = "Loading"
        setTextFiled()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.endReceivingRemoteControlEvents()
    }
    
    private func callMusicApi(enterTerm:String){
        if let key = disposeKey {
            compositeDisposable.remove(for: key)
        }
        
        disposeKey = compositeDisposable.insert(searchMusicViewModel.searchMusicSubject.subscribe(with: self, onNext: { (viewController, status) in
            switch status {
            
            case .loadstart:
                viewController.defaultSearchNameLabel.isHidden = true
                viewController.hud.show(in: self.view)
            case .loadEnd:
                viewController.hud.dismiss()
            case .error(errorMessage: let errorMessage):
                viewController.showErrorAlert(errorMessage: errorMessage.description)
            case .data(let data):
                viewController.musicResult = data
                viewController.mainTableView.reloadData()
                viewController.mainTableView.isHidden = false
                
                
            }
        }, onError: { viewController, error in
            viewController.showErrorAlert(errorMessage: error.localizedDescription)
        }))

        let msusicParameter = MusicParameter(term: enterTerm)
        searchMusicViewModel.readProductDetailApiData(enterTerm: enterTerm, musicParameter: msusicParameter)
    }
    
    private func setTextFiled() {
        
        let textWidth: CGFloat = UIScreen.main.bounds.size.width * (285.0/375.0)
        self.searchTextField = UITextField(frame: CGRect(x: 28, y: 0, width: textWidth, height: 30))
        searchTextField.backgroundColor = .white
        searchTextField.textColor = .black
        searchTextField.layer.cornerRadius = 3
        searchTextField.delegate = self
        searchTextField.placeholder = " 搜尋"
        self.navigationItem.titleView = self.searchTextField
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return musicResult.resultCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainTableView.dequeueReusableCell(withIdentifier: "MusicTableViewCell", for: indexPath) as! MusicTableViewCell
        
        cell.artistNameLabel.text = musicResult.results[indexPath.row].artistName
        cell.songNameLabel.text = musicResult.results[indexPath.row].trackName
        cell.imageUrl(imageUrl: musicResult.results[indexPath.row].artworkUrl100)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.currentRow = indexPath.row
        let index = musicResult.results[indexPath.row]
        musicPlay(MusicIndex: index)
        setLockScreenDisplay(data: index)
        musicNameLabel.text = musicResult.results[indexPath.row].trackName
       
    }
    
    private func rigesterCell() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(UINib(nibName: "MusicTableViewCell", bundle: nil), forCellReuseIdentifier: "MusicTableViewCell")
    }
    
    private func showErrorAlert(errorMessage:String) {
        let controller = UIAlertController(title: "錯誤訊息", message: errorMessage, preferredStyle: .alert)
         let okAction = UIAlertAction(title: "確認", style: .default, handler: nil)
         controller.addAction(okAction)
         present(controller, animated: true, completion: nil)
          
      }
    
    
    
    @IBAction func clickPause(_ sender: Any) {
        pauseMusic()
    }
    
    @IBAction func clickPlay(_ sender: Any) {
        playMusic()
    }
    
    @IBAction func clickCancle(_ sender: Any) {
        searchTextField.text = nil
    }
    
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let text = textField.text  {
            
            callMusicApi(enterTerm: text)
        }
       
        return true
    }
    
    private func playMusic() {
        if player.timeControlStatus == .paused {
            player.play()
        }
    }
    
    private func pauseMusic() {
        if player.timeControlStatus == .playing {
            player.pause()
        }
    }
    
    // MARK: 播放音樂
    private func musicPlay(MusicIndex:SearchMusicResponse.Results) {
            if let url = URL(string: MusicIndex.previewUrl) {
                self.playItem = AVPlayerItem(url: url)
            }
        player.replaceCurrentItem(with: playItem)
        playMusic()
    }
    
    private func centerMusiaPlay(currectIndex:Int) {
        if let url = URL(string: musicResult.results[currectIndex].previewUrl) {
            self.playItem = AVPlayerItem(url: url)
        }
        player.replaceCurrentItem(with: playItem)
        playMusic()
    }
    
    //MARK: 設置鎖屏＆控制中心訊息
   private func setLockScreenDisplay(data:SearchMusicResponse.Results) {
        
        var info = Dictionary<String, Any>()
        info[MPMediaItemPropertyTitle] = data.trackName//歌名
        info[MPMediaItemPropertyArtist] = data.artistName//作者
    
        if let image = UIImage(named: data.artworkUrl60) { //設定歌曲圖片
        info[MPMediaItemPropertyArtwork] = MPMediaItemArtwork.init(boundsSize: image.size, requestHandler: { (size) -> UIImage in
            return image
    })
                }
        info[MPMediaItemPropertyPlaybackDuration] = playItem?.asset.duration.seconds//總時長
        info[MPNowPlayingInfoPropertyPlaybackRate] = 1.0//播放速率
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
    }
    
    //    MARK: 鎖屏＆控制中心控制
    override func remoteControlReceived(with event: UIEvent?) {
        if let type = event?.subtype {
            switch type {
            case .remoteControlPlay:  //播放
                playMusic()
            case .remoteControlPause:  //暂停
                pauseMusic()
            case .remoteControlNextTrack:    //下一首
                setCurrentRow(type: .next, data: musicResult)
                break
            case .remoteControlPreviousTrack:  //上一首
                setCurrentRow(type: .previous, data: musicResult)
             break
           
            default:
                break
            }
        }
       
    }
    
    
   
   private func setCurrentRow(type: Action,data:SearchMusicResponse){
        let current = self.currentRow
                switch type {
                case .next:
                    if current < data.results.count - 1 { //下一首
                        currentRow = current + 1
                    } else {
                        currentRow = 0
                    }
                case .previous:
                    if current < 1 {
                        currentRow = data.results.count - 1 //上一首
                    } else {
                        currentRow = current - 1
                    }
                }
        setLockScreenDisplay(data: data.results[currentRow])
        centerMusiaPlay(currectIndex: currentRow)
        
         
       }
       
    
}
