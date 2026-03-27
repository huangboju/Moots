//
//  Socket.swift
//  RPush
//
//  Created by Axe on 2021/1/8.
//

#if canImport(Network)
import Foundation
import Network

@available(macOS 10.14, iOS 12.0, watchOS 5.0, tvOS 12.0, *)
class Socket {
    private var connection: NWConnection!
    private let queue = DispatchQueue(label: "com.rpush.networkstream")
    private var isRunning = false
    
    init(address: String, port: Int, timeout: TimeInterval = 30, cert: SecCertificate? = nil) {
        let host = NWEndpoint.Host(address)
        let portx = NWEndpoint.Port(rawValue: UInt16(port))!
        
        // TLS
        let tlsOptions = NWProtocolTLS.Options()
        sslSetCertificate(cert, tls: tlsOptions)

        let tcpOptions = NWProtocolTCP.Options()
        tcpOptions.connectionTimeout = Int(timeout.rounded(.up))
        
        let parameters = NWParameters(tls: tlsOptions, tcp: tcpOptions)

        // Create an outbound connection.
        self.connection = NWConnection(host: host, port: portx, using: parameters)
    }
    
    func connect(completion: ((Result<Void, NWError>) -> Void)? = nil) {
        guard connection != nil else {
            completion?(.success(()))
            return
        }
        
        connection.stateUpdateHandler = { [weak self] state in
            guard let this = self else { return }
            switch state {
            case .ready:
                // Handle connection established.
                completion?(.success(()))
            case .waiting(_):
                // Handle connection waiting for network.
                this.connection.restart()
            case .failed(let error):
                // Handle fatal connection error.
                completion?(.failure(error))
            default:
                break
            }
        }
        
        connection.start(queue: queue)
        isRunning = true
        
        receiveLoop()
    }
    
    func send(data: Data, completion: ((Result<Void, NWError>) -> Void)? = nil) {
        guard connection != nil else { return }
        connection.send(content: data, completion: .contentProcessed { error in
            if let error = error {
                // handle error in sending.
                completion?(.failure(error))
            } else {
                // Send has been processed.
                completion?(.success(()))
            }
        })
    }
    
    func disconnect(force: Bool = false) {
        if force {
            connection.forceCancel()
        } else {
            connection.cancel()
        }
        isRunning = false
    }
    
    private func receiveLoop() {
        guard isRunning else {
            return
        }
        
        connection.receive(minimumIncompleteLength: 2, maximumLength: 4096) { [weak self] (data, context, finished, error) in
            guard let this = self else { return }
            
            if let data = data {
                print("Receive Data: \(data)")
                if let message = String(data: data, encoding: .utf8) {
                    print("Receive Message: \(message)")
                }
            }
            
            // Refer to https://developer.apple.com/documentation/network/implementing_netcat_with_network_framework
            if let context = context, context.isFinal, finished {
                return
            }
            
            if error == nil {
                this.receiveLoop()
            }
        }
    }
    
    private func sslSetCertificate(_ cert: SecCertificate?, tls: NWProtocolTLS.Options) {
        guard let certificate = cert, let secIdentity = certificate.identity, let identity = sec_identity_create(secIdentity) else {
            return
        }
        sec_protocol_options_set_local_identity(tls.securityProtocolOptions, identity)
    }
    
}

#endif
