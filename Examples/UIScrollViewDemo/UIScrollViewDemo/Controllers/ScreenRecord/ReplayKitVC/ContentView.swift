import SwiftUI

struct ContentView: View {
    @StateObject private var recorder = ReplayCaptureRecorder()
    @State private var playMusicWhileRecording = true

    var body: some View {
        VStack(spacing: 16) {
            Text("ReplayKit 录屏 Demo")
                .font(.title2).bold()

            Toggle("录制时播放音乐（demo.mp3）", isOn: $playMusicWhileRecording)
                .padding(.horizontal)

            Text(recorder.statusText)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                Button("开始录制") {
                    recorder.start(playMusic: playMusicWhileRecording)
                }
                .buttonStyle(.borderedProminent)
                .disabled(recorder.isRecording)

                Button("停止并保存到相册") {
                    recorder.stop()
                }
                .buttonStyle(.bordered)
                .disabled(!recorder.isRecording)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}
