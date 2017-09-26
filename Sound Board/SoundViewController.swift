//
//  SoundViewController.swift
//  Sound Board
//
//  Created by Mohammed Faizuddin on 9/25/17.
//  Copyright © 2017 Faiz Tech. All rights reserved.
//

import UIKit
import AVFoundation

class SoundViewController: UIViewController {
    
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    var audioRecorder : AVAudioRecorder? = nil
    var audioPlayer : AVAudioPlayer?
    var audioURL : URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //calling function
        setupRecorder()
        
        //disabling play button until something recorded
        playButton.isEnabled = false
        
        //disabling add button until something recorded
        addButton.isEnabled = false
        
    }
    
    //function to setup Recorder
    func setupRecorder()
    {
        do
        {
            //creating an audio session
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            //creating URL for audio file
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponent = [basePath,"audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponent)!
            /*getting the audio URL
             debugging
             print("**************")
             print(audioURL)
             print("**************")*/
            
            //creating settings for audio recorder
            var settings : [String:Any] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC)
            settings[AVSampleRateKey] = 44100.0
            settings[AVNumberOfChannelsKey] = 2
            
            // create audio recorder object
            try audioRecorder = AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorder!.prepareToRecord()
            
        }
        catch let error as NSError{
            print(error)
        }
        
    }
    
    @IBAction func recordTapped(_ sender: Any) {
        
        //checking if it is recording or not
        if(audioRecorder!.isRecording)
        {
            //stopping recording
            audioRecorder?.stop()
            
            //changing record button to RECORD
            recordButton.setTitle("RECORD", for: .normal)
            
            //reenabling the Play button
            playButton.isEnabled = true
            
            //reenabling the Play button
            addButton.isEnabled = true
        }else{
            //starting the recording
            audioRecorder?.record()
            
            //change the button to STOP
            recordButton.setTitle("STOP", for: .normal)
        }
        
    }
    
    
    @IBAction func playTapped(_ sender: Any) {
        do{
            //setting up audio Player
            try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
            //playiong the audio when play is tapped
            audioPlayer!.play()
            
        } catch { }
    }
    
    
    
    @IBAction func addTapped(_ sender: Any) {
        
        //mapping with Core Data
        let context  = (UIApplication.shared.delegate
            as! AppDelegate).persistentContainer.viewContext
        
        //creating a sound object
        let sound = Sound(context: context)
        
        //saving sound clip name here
        sound.name = textField.text
        
        //saving audio after converting it into NSData
        sound.audio = NSData(contentsOf: audioURL!)! as Data
        
        //saving into Core Data
        (UIApplication.shared.delegate
            as! AppDelegate).saveContext()
        
        //popping back to the previous screen
        navigationController!.popViewController(animated: true)
        
        
    }
    
    
    
}
