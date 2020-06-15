import UIKit
import NexmoClient

final class ViewController: UIViewController {

    private let npeName = "bullet"
    private let rs256PrivateKey = "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCaPeklBUXxgKbc\ndWHESIJoMpCJfGg5KtDWNUvo7/V3Xz9z4hd0rrtA/F4Bu/bp1wWeF3hGqJNEJpco\npC2TNfwfEEDXgZOaaIqTJFCPgdawbYOzu38ucL09YMbo//ClWNjOTbJAFxnY9EgG\nN461f7B1D2Lrl+t21ITuSyJ9DRnHSWWkSxuuameyt51BSa0gRE4W9PPwBZ0nEZAk\nILkh5WGVejjW2qcZpliIpBdJ30aanRUCzOpcutcpKIgSrrOE2A9iFLAEs5HmPZXr\n5Cq2sqHY3faVN5+4jLS6dAMW9IfPiWxQef9oXGqK0YZudaiV0uXW1Mw+VUMTFMun\ndGePIN1rAgMBAAECggEABTM4JITgfkthlMYqVSVCrEOkJtZ4ZxD/+HDUjdZlNrCR\n4ZTKSKdJbd/0RWeyY+DZciKFbhBp4p7QctDSLoff56YzIXDfapHCtkI/qw7sD4ep\nrIoSOB0Z7DNSkXFrig+MQ6xP6aQ9vVhDA16lI45aAyBRK/Mzv45bqvMChyfFajgM\nWUaAYMDOFMo0N9C8i0601rcFtR20WUx0njFpZc2pF4eXyAaAB9wrKp69BiTcMAlo\nJieoyGA8k4bXBz6xCy2xmhQ4O9JiI3QqdGimlZlJQj4Dyec1OFtN6pjo90bDsFic\nltJ+BgglFyvZ/ajgNMCIif2hoA/V7GeaZ0aZXGqZXQKBgQDPrsbw07M0M14B6ESW\ng/4BVA6UsSuzdcvEt+A1cI7kGGyM1K+PaLOys2VaijFPHwGzpgqk5qzy+jzSjSHq\nv7qkGHFC1FP0bjssfaBjXsQyLjT7zqKF1f3MKj1d+puWM6SRRqxH7SNz6oA2e6Jb\ngsS7vkpC9tC7sHUqGnB5COiSBwKBgQC+IEmF1eLXx9jwkB4/NyejFq9nZdl0F0FJ\nHgp0JGIlhrTic1WMyYuzPVv54VntaiiYnzqLcEJEYJPvrNws1UAWcbCZRShLg60l\npFxXriYRLUOnTkI+my7/+qduOlRQMtQ8mlVpGNXFLITaSb0DUAeVnT4rO+DB+/cw\nInqPVz3wfQKBgBqAeByFN0oDAA0IQbBfWYt72Xx5+1SkRINu32qSWXmb8EYsYdbQ\nCpZUNCvQlKg/Ea2GE7elRA6hhh9sKRbWro+AGvvnMmtvoZd01IG5txmcMeCsJqsj\neoaSIVCbyTzqjCaJuTRYe3ywQPoy3q4EyuwWRU20R0CcLOdZhl67l0oDAoGAfUar\nC2vOp94AHSrpM0A1dunos9nRegQkuXf47WRX42AqahgS48ydp4Ijy7foWF6d10r7\n+YsDryhv8fpVrZjqPJ+2/JcsIO3ntijhy8htPt4zeNdBIR2Bz5uqnSAEFEAZxsDu\nzGxX1y8pbugtijQ+ex/8KeKvi0JqMyZU2YRjxMUCgYEAuUV5eAudHCf+smr3q1za\nBjy4jyE/f5tYYET8jSBiHTRDx6YS/2hVifsra6AgZhpFcT+DK2gg46dVzOv69EsQ\nGpNi7FtB2oFqRRvOLBVADaMg6rysjWpfymL4zSxCu7X3VsKZ38gC/FHYisXkpPY9\nNhapR6yH48e1szqePgQdT6k=\n-----END PRIVATE KEY-----\n"
    private let applicationId = "ec9e8472-9c69-4394-8874-38f434babfac"
    private let username = "Sergei"

    @IBOutlet weak var connectionStatusLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        connectionStatusLabel.text = "-"
    }

    @IBAction func onLoginButtonTouchUpInside(_ sender: UIButton) {
        let clientConfig = NXMClientConfig(
            apiUrl: "https://\(npeName)-api.npe.nexmo.io",
            websocketUrl: "https://\(npeName)-ws.npe.nexmo.io",
            ipsUrl: "https://api.dev.nexmoinc.net/play4/v1/image",
            useFirstIceCandidate: true
        )
        NXMClient.setConfiguration(clientConfig)

        NXMClient.shared.setDelegate(self)

        let userToken = JWTGenerator.generateToken(
            privateKey: rs256PrivateKey,
            applicationId: applicationId,
            username: username
        )
        NXMClient.shared.login(withAuthToken: userToken)
    }
}

extension ViewController: NXMClientDelegate {

    func client(
        _ client: NXMClient,
        didChange status: NXMConnectionStatus,
        reason: NXMConnectionStatusReason
    ) {
        let connectionStatus: String
        switch status {
        case .disconnected: connectionStatus = "Disconnected"
        case .connecting:   connectionStatus = "Connecting"
        case .connected:    connectionStatus = "Connected"
        @unknown default:   connectionStatus = "Unknown NXMConnectionStatus"
        }
        updateConnectionStatusLabel(connectionStatus)
    }

    func client(_ client: NXMClient, didReceiveError error: Error) { }

    private func updateConnectionStatusLabel(_ text: String) {
        DispatchQueue.main.async { [weak self] in
            self?.connectionStatusLabel.text = text
        }
    }
}
