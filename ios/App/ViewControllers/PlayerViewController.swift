import AVFoundation
import AVKit
import UIKit

class PlayerViewController: UIViewController {

    // MARK: - Constants
    private let videoURL =
        "https://flipfit-cdn.akamaized.net/flip_hls/663d1244f22a010019f3ec12-f3c958/video_h1.m3u8"

    // MARK: - UI Components
    private lazy var playerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Current Video"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text =
            "This is a sample HLS video stream. The video demonstrates high-quality streaming with adaptive bitrate capabilities."
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var controlsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var playPauseButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(playPauseAction), for: .touchUpInside)
        return button
    }()

    private lazy var muteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "speaker.fill"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(muteUnmuteAction), for: .touchUpInside)
        return button
    }()

    // MARK: - Properties
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var isPlaying = true
    private var isMuted = false

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPlayer()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = playerView.bounds
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground

        view.addSubview(playerView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)

        playerView.addSubview(controlsStackView)
        controlsStackView.addArrangedSubview(playPauseButton)
        controlsStackView.addArrangedSubview(muteButton)

        NSLayoutConstraint.activate([
            playerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playerView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 9 / 16),  // 16:9 aspect ratio

            controlsStackView.centerXAnchor.constraint(equalTo: playerView.centerXAnchor),
            controlsStackView.bottomAnchor.constraint(
                equalTo: playerView.bottomAnchor, constant: -20),

            titleLabel.topAnchor.constraint(equalTo: playerView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }

    private func setupPlayer() {
        guard let url = URL(string: videoURL) else { return }

        let player = AVPlayer(url: url)
        self.player = player

        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        self.playerLayer = playerLayer

        playerView.layer.addSublayer(playerLayer)

        // Add periodic time observer
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] _ in
            self?.updatePlaybackStatus()
        }

        // Start playback
        player.play()

        // Register for notifications
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerItemDidReachEnd),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem)
    }

    // MARK: - Actions
    @objc private func playPauseAction() {
        if isPlaying {
            player?.pause()
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            player?.play()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
        isPlaying.toggle()
    }

    @objc private func muteUnmuteAction() {
        player?.isMuted.toggle()
        isMuted.toggle()

        let imageName = isMuted ? "speaker.slash.fill" : "speaker.fill"
        muteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }

    @objc private func playerItemDidReachEnd() {
        // Seek to beginning and play again
        player?.seek(to: .zero)
        player?.play()
    }

    private func updatePlaybackStatus() {
        guard let player = player else { return }
        isPlaying = player.rate != 0
        let imageName = isPlaying ? "pause.fill" : "play.fill"
        playPauseButton.setImage(UIImage(systemName: imageName), for: .normal)
    }

    // MARK: - Cleanup
    deinit {
        NotificationCenter.default.removeObserver(self)
        player?.pause()
        player = nil
    }
}
