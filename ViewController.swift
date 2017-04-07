//
//  ViewController.swift
//  RetroCalculator
//
//  Created by Хуліо Ґомез on 2/5/17.
//  Copyright © 2017 Хуліо Ґомес. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
   
    @IBOutlet weak var outputLabel: UILabel!

    var btnSound: AVAudioPlayer!
    
    var runningNumber = ""
    var currentOperation = Operation.Empty
    var leftValStr = ""
    var rightValStr = ""
    var result = ""
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Substract = "-"
        case Add = "+"
        case Empty = "Empty"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "btn", ofType: "wav")
        let soundURL = URL(fileURLWithPath: path!)
        
        do {
            try btnSound = AVAudioPlayer(contentsOf: soundURL)
            btnSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    @IBAction func numberPressed(_ sender: UIButton) {
        playSound()
        
        runningNumber += "\(sender.tag)"
        outputLabel.text! = runningNumber
    }
    
    func playSound() {
        if btnSound.isPlaying {
            btnSound.stop()
        }
        
        btnSound.play()
    }
    
    func processOperation(_ operation: Operation) {
        playSound()
        if currentOperation != Operation.Empty {
            
            //A user selected an operator but enter another operator without entering the next number
            if runningNumber != "" {
                rightValStr = runningNumber
                runningNumber = ""
                
                if currentOperation == Operation.Multiply {
                    result = "\(Double(leftValStr)! * Double(rightValStr)!)"
                } else if currentOperation == Operation.Divide {
                    result = "\(Double(leftValStr)! / Double(rightValStr)!)"
                } else if currentOperation == Operation.Add {
                    result = "\(Double(leftValStr)! + Double(rightValStr)!)"
                } else if currentOperation == Operation.Substract {
                    result = "\(Double(leftValStr)! - Double(rightValStr)!)"
                }
                
                leftValStr = result
                outputLabel.text = result
            }
            
            currentOperation = operation
        //This is the first time an operation has been entered
        } else {
            leftValStr = runningNumber
            runningNumber = ""
            currentOperation = operation
        }
    }
    
    @IBAction func onDividePressed(_ sender: UIButton) {
        processOperation(Operation.Divide)
    }
    
    @IBAction func onMultiplyPressed(_ sender: UIButton) {
        processOperation(Operation.Multiply)
    }
    
    @IBAction func onAddPressed(_ sender: UIButton) {
        processOperation(Operation.Add)
    }
    
    @IBAction func onSubstractPressed(_ sender: UIButton) {
        processOperation(Operation.Substract)
    }
    
    @IBAction func onEqualPressed(_ sender: UIButton) {
        processOperation(currentOperation)
    }

}

