//
//  ViewController.swift
//  CustomNavigationAnimations-Starter
//
//  Created by Sam Stone on 29/09/2017.
//  Copyright © 2017 Sam Stone. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    private let cellId = "MusicCell"
    private var selectedSong : Song?
    
    private var selectedFrame : CGRect?
    private var customInteractor : CustomInteractor?
    
    private var songs : [Song] = [Song(artist: "Kendrick Lamar", title: "DNA", artwork: UIImage(named: "damn")!),Song(artist: "Freddie Gibbs", title: "Alexys", artwork: UIImage(named: "twice")!), Song(artist: "Brockhampton", title: "JUNKY", artwork: UIImage(named: "sat")!), Song(artist: "MC Eiht", title: "Represent Like This", artwork: UIImage(named: "west")!), Song(artist: "Tyler the Creator", title: "November", artwork: UIImage(named: "flower")!), Song(artist: "Jay-Z", title: "4:44", artwork: UIImage(named: "four")!), Song(artist: "Joey Bada$$", title: "ROCKABYE BABY", artwork: UIImage(named: "badass")!), Song(artist: "Sean Price", title: "Imperious Rex", artwork: UIImage(named: "imperious")!), Song(artist: "Oddisee", title: "Hold it back", artwork: UIImage(named: "iceburg")!), Song(artist: "J.I.D", title: "Never", artwork: UIImage(named: "never")!)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        songs.append(contentsOf: songs + songs + songs)
        SetupCollectionView()
    }

    private func SetupCollectionView(){
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UINib.init(nibName: "SongCell", bundle: Bundle.main), forCellWithReuseIdentifier: cellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return songs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SongCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SongCell
        cell.refreshWith(song: songs[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width / 3, height: self.collectionView.frame.width / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedSong = songs[indexPath.row]
        let theAttributes:UICollectionViewLayoutAttributes! = collectionView.layoutAttributesForItem(at: indexPath)
        selectedFrame = collectionView.convert(theAttributes.frame, to: collectionView.superview)
        self.performSegue(withIdentifier: "Player", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "Player") {
            let playerVc = segue.destination as! MusicPlayerViewController
            playerVc.song = self.selectedSong
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let ci = customInteractor else { return nil }
        return ci.transitionInProgress ? customInteractor : nil
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let frame = self.selectedFrame else { return nil }
        guard let song = self.selectedSong else { return nil }
        
        switch operation {
        case .push:
            customInteractor = CustomInteractor(attachTo: toVC)
            return CustomAnimator(duration: TimeInterval(UINavigationControllerHideShowBarDuration), isPresenting: true, originFrame: frame, image: song.artwork)
        default:
            return CustomAnimator(duration: TimeInterval(UINavigationControllerHideShowBarDuration), isPresenting: false, originFrame: frame, image: song.artwork)
        }
    }
}

