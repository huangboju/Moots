import AVFoundation
import UIKit

class AudioManager {
    static let shared = AudioManager()
    
    private var audioPlayer: AVAudioPlayer?
    private var audioFile: AVAudioFile?
    
    private init() {
        setupAudioSession()
    }
    
    /// 配置音频会话
    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetoothHFP])
            try audioSession.setActive(true)
        } catch {
            print("音频会话配置失败: \(error)")
        }
    }
    
    /// 播放音乐文件（从Bundle或URL）
    func playMusic(from url: URL, loop: Bool = false) {
        do {
            // 停止之前的播放
            stopMusic()
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = loop ? -1 : 0
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            
            print("开始播放音乐: \(url.lastPathComponent)")
        } catch {
            print("播放音乐失败: \(error)")
        }
    }
    
    /// 播放Bundle中的音乐文件
    func playMusicFromBundle(fileName: String, fileExtension: String = "mp3", loop: Bool = false) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
            print("找不到音乐文件: \(fileName).\(fileExtension)")
            return
        }
        playMusic(from: url, loop: loop)
    }
    
    /// 停止播放音乐
    func stopMusic() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
    
    /// 暂停播放
    func pauseMusic() {
        audioPlayer?.pause()
    }
    
    /// 继续播放
    func resumeMusic() {
        audioPlayer?.play()
    }
    
    /// 检查是否正在播放
    var isPlaying: Bool {
        return audioPlayer?.isPlaying ?? false
    }
    
    /// 设置音量
    func setVolume(_ volume: Float) {
        audioPlayer?.volume = volume
    }
}

