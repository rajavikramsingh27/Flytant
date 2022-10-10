//
//  AudioViewController.swift
//  Flytant
//
//  Created by Vivek Rai on 12/08/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import Foundation
import IQAudioRecorderController

class AudioViewController {
    
    var delegate: IQAudioRecorderViewControllerDelegate
    
    init(delegate_: IQAudioRecorderViewControllerDelegate) {
        delegate = delegate_
    }
    
    
    func presentAudioRecorder(target: UIViewController) {
        
        let controller = IQAudioRecorderViewController()
        
        controller.delegate = delegate
        controller.title = "Record"
        controller.maximumRecordDuration = AUDIO_MAX_DURATION
        controller.allowCropping = true
        
        target.presentBlurredAudioRecorderViewControllerAnimated(controller)
    }

}
