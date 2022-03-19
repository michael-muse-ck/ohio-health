//
//  ContentView.swift
//  ohio-health
//
//  Created by Michael Muse on 3/19/22.
//

import SwiftUI
import AVFoundation
import Speech


struct ContentView: View {
    
    private let audioEngine = AVAudioEngine()
    private  let speech = SFSpeechRecognizer()
    
    @State private var userName: String = ""
    @State private var cityName: String = ""
    @State private var yearOfJoining: String = ""
    @StateObject var speechEngine = SpeechEngine()
    @State private var isRecording = false
    //private var player: AVPlayer { AVPlayer.sharedDingPlayer }
    
    enum HighlightTag {
            case none, first, second, third
        }

    @State private var highlighted = HighlightTag.none
    
    fileprivate func processVoiceTap(inputValue: inout String) {
        if isRecording == false {
            speechEngine.reset()
            inputValue = ""
            speechEngine.transcribe()
            isRecording = true
        } else {
            speechEngine.stopTranscribing()
            isRecording = false
            inputValue = speechEngine.transcript
            speechEngine.reset()
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("First Page")
                    .padding()
                HStack {
                    Text("First")
                        .padding()
                    TextField(text: $userName, prompt: Text("Required")) {
                            Text("Username")
                        }
                    Button("Voice") {
                        highlighted = .first
                        processVoiceTap(inputValue: &userName)
                    }.padding().buttonStyle(ProgressButtonStyle(isLoading: isRecording))
                }
                HStack {
                    Text("City Name")
                        .padding()
                    TextField(text: $cityName, prompt: Text("Required")) {
                            Text("Username")
                        }
                    Button("Voice") {
                        highlighted = .second
                        processVoiceTap(inputValue: &cityName)
                    }.padding().buttonStyle(ProgressButtonStyle(isLoading: isRecording))
                }
                HStack {
                    Text("Year of Joining")
                        .padding()
                    TextField(text: $yearOfJoining, prompt: Text("Required")) {
                            Text("Username")
                        }
                    Button("Voice") {
                        highlighted = .third
                        processVoiceTap(inputValue: &yearOfJoining)
                    }.padding().buttonStyle(ProgressButtonStyle(isLoading: isRecording))
                }
                
                NavigationLink(destination: SecondView()) {
                                    Text("Next")
                                }
                                .navigationTitle("User Details")
            }.onAppear {
                print("ContentView appeared!")
                askUserPermission()
            }.onDisappear {
                print("ContentView disappeared!")
            }
        }.navigationTitle("Ohio Health")
    }
    
    private func askUserPermission() {
        print("Asking user permission")
        // Make the authorization request
           SFSpeechRecognizer.requestAuthorization { authStatus in

           // The authorization status results in changes to the
           // app’s interface, so process the results on the app’s
           // main queue.
              OperationQueue.main.addOperation {
                  print(authStatus)
                  
//                 switch authStatus {
//                    case .authorized:
//                       self.recordButton.isEnabled = true
//
//                    case .denied:
//                       self.recordButton.isEnabled = false
//                       self.recordButton.setTitle("User denied access
//                                   to speech recognition", for: .disabled)
//
//                    case .restricted:
//                       self.recordButton.isEnabled = false
//                       self.recordButton.setTitle("Speech recognition
//                               restricted on this device", for: .disabled)
//
//                    case .notDetermined:
//                       self.recordButton.isEnabled = false
//                       self.recordButton.setTitle("Speech recognition not yet
//                                              authorized", for: .disabled)
//                 }
              }
           }
    }
    
    var fontColor: Color {
            return !isRecording ? .white : .black
        }
    
    var backgroundColor: Color {
        return !isRecording ? .blue : .red
        }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ProgressButtonStyle: ButtonStyle {
    let isLoading: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(isLoading ? 0 : 1)
            .overlay {
                if isLoading {
                    ProgressView()
                }
            }
    }
}


struct RecordingButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.title)
      .foregroundColor(.white)
      .padding()
      .background(Color.red)
      .clipShape(RoundedRectangle(cornerRadius: 20))
  }
}

struct DefaultButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.title)
      .foregroundColor(.white)
      .padding()
      .background(Color.blue)
      .clipShape(RoundedRectangle(cornerRadius: 20))
  }
}



