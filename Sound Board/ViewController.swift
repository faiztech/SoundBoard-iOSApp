//
//  ViewController.swift
//  Sound Board
//
//  Created by Mohammed Faizuddin on 9/25/17.
//  Copyright © 2017 Faiz Tech. All rights reserved.
//

import UIKit
//AVFoundation import
import AVKit

//adding extensions for table views
class ViewController: UIViewController, UITableViewDelegate,
UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    //an array of sound objects
    var sound :[Sound] = []
    
    //setting up audio player
    var audioPlayer : AVAudioPlayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //configuring table Views
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //mapping to Core Data
        let context  = (UIApplication.shared.delegate
            as! AppDelegate).persistentContainer.viewContext
        
        do {
            //fetching sounds
            try sound =  context.fetch(Sound.fetchRequest())
            tableView.reloadData()
        } catch  {
            
        }
    }
    
    
    //function for number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //returning the number of elements in the array as number of rows in table view
        return sound.count
    }
    
    //function for putting content into the table view rows
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //intitializing a cell as TableView Cell
        let cell = UITableViewCell()
        
        //just putting the index of cell here
        let sounds = sound[indexPath.row]
        
        //initializing the content of cell as the name of the sound
        cell.textLabel?.text = sounds.name
        
        return cell
    }
    
    
    //function to implement actions inside tableViews
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //just putting the index of cell here
        let sounds = sound[indexPath.row]
        do{
            try audioPlayer = AVAudioPlayer(data: sounds.audio!)
            audioPlayer?.play()
        } catch{}
        
        //removing highlighting after playing
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //function for swipe to delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        //if edit style is delete then doing stuff
        if editingStyle == .delete
        {
            //just putting the index of cell here
            let sounds = sound[indexPath.row]
            
            //mapping to CoreData
            let context  = (UIApplication.shared.delegate
                as! AppDelegate).persistentContainer.viewContext
            
            //deleting from CoreData
            context.delete(sounds)
            
            //saving changes
            (UIApplication.shared.delegate
                as! AppDelegate).saveContext()
            
            //reloading data
            do {
                //fetching sounds
                try sound =  context.fetch(Sound.fetchRequest())
                tableView.reloadData()
            } catch  {
                
            }
            
        }
    }
    
}

