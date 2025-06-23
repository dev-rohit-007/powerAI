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
        // MARK: - UI Components
        private lazy var playerView: UIView = {
            let view = UIView()
            view.backgroundColor = .black
            view.translatesAutoresizingMaskIntoConstraints = false
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(playerViewTapped))
            view.addGestureRecognizer(tapGesture)
            return view
        }()

        private lazy var controlsOverlay: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()

        private lazy var controlsStackView: UIStackView = {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.distribution = .equalSpacing
            stack.alignment = .center
            stack.spacing = 20
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()

        private lazy var playPauseButton: UIButton = {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
            let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
            button.setImage(UIImage(systemName: "pause.fill", withConfiguration: config), for: .normal)
            button.tintColor = .white
            button.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            button.layer.cornerRadius = 22
            button.addTarget(self, action: #selector(playPauseAction), for: .touchUpInside)
            return button
        }()

        private lazy var muteButton: UIButton = {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
            let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
            button.setImage(UIImage(systemName: "speaker.fill", withConfiguration: config), for: .normal)
            button.tintColor = .white
            button.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            button.layer.cornerRadius = 22
            button.addTarget(self, action: #selector(muteUnmuteAction), for: .touchUpInside)
            return button
        }()

        private lazy var progressSlider: UISlider = {
            let slider = UISlider()
            slider.translatesAutoresizingMaskIntoConstraints = false
            slider.minimumTrackTintColor = .systemBlue
            slider.maximumTrackTintColor = .gray
            slider.setThumbImage(UIImage(), for: .normal)
            slider.addTarget(self, action: #selector(progressSliderChanged(_:)), for: .valueChanged)
            slider.addTarget(self, action: #selector(progressSliderEndedEditing(_:)), for: [.touchUpInside, .touchUpOutside])
            return slider
        }()

        private lazy var timeLabel: UILabel = {
            let label = UILabel()
            label.textColor = .white
            label.font = .systemFont(ofSize: 12, weight: .medium)
            label.text = "00:00"
            return label
        }()

        private lazy var durationLabel: UILabel = {
            let label = UILabel()
            label.textColor = .white
            label.font = .systemFont(ofSize: 12, weight: .medium)
            label.text = "00:00"
            return label
        }()

    // MARK: - Properties
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var isPlaying = true
    private var isMuted = false
    private var controlsTimer: Timer?
    private var timeObserverToken: Any?

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

        playerView.addSubview(controlsOverlay)
        controlsOverlay.addSubview(controlsStackView)

        let progressStack = UIStackView()
        progressStack.axis = .horizontal
        progressStack.spacing = 8
        progressStack.alignment = .center
        progressStack.addArrangedSubview(timeLabel)
        progressStack.addArrangedSubview(progressSlider)
        progressStack.addArrangedSubview(durationLabel)

        let buttonStack = UIStackView()
        buttonStack.axis = .horizontal
        buttonStack.spacing = 16
        buttonStack.addArrangedSubview(playPauseButton)
        buttonStack.addArrangedSubview(muteButton)

        controlsStackView.addArrangedSubview(progressStack)
        controlsStackView.addArrangedSubview(buttonStack)

        NSLayoutConstraint.activate([
            playerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playerView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 9 / 16),  // 16:9 aspect ratio

            controlsOverlay.topAnchor.constraint(equalTo: playerView.topAnchor),
            controlsOverlay.leadingAnchor.constraint(equalTo: playerView.leadingAnchor),
            controlsOverlay.trailingAnchor.constraint(equalTo: playerView.trailingAnchor),
            controlsOverlay.bottomAnchor.constraint(equalTo: playerView.bottomAnchor),

            controlsStackView.leadingAnchor.constraint(equalTo: controlsOverlay.leadingAnchor, constant: 16),
            controlsStackView.trailingAnchor.constraint(equalTo: controlsOverlay.trailingAnchor, constant: -16),
            controlsStackView.bottomAnchor.constraint(equalTo: controlsOverlay.bottomAnchor, constant: -16),

            playPauseButton.widthAnchor.constraint(equalToConstant: 44),
            playPauseButton.heightAnchor.constraint(equalToConstant: 44),
            muteButton.widthAnchor.constraint(equalToConstant: 44),
            muteButton.heightAnchor.constraint(equalToConstant: 44),

            progressSlider.widthAnchor.constraint(equalTo: progressStack.widthAnchor, multiplier: 0.7),

            titleLabel.topAnchor.constraint(equalTo: playerView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])

        startControlsTimer()
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
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.updatePlaybackStatus()
            self?.updateTimeLabels()
        }

        // Start playback
        player.play()

        // Register for notifications
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerItemDidReachEnd),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem)

        // Update duration once asset is ready
        player.currentItem?.asset.loadValuesAsynchronously(forKeys: ["duration"]) { [weak self] in
            DispatchQueue.main.async {
                self?.updateDurationLabel()
            }
        }
    }

    // MARK: - Actions
    @objc private func playPauseAction() {
        if isPlaying {
            player?.pause()
            let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
            playPauseButton.setImage(UIImage(systemName: "play.fill", withConfiguration: config), for: .normal)
        } else {
            player?.play()
            let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
            playPauseButton.setImage(UIImage(systemName: "pause.fill", withConfiguration: config), for: .normal)
        }
        isPlaying.toggle()
        startControlsTimer()
    }

    @objc private func muteUnmuteAction() {
        player?.isMuted.toggle()
        isMuted.toggle()

        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        let imageName = isMuted ? "speaker.slash.fill" : "speaker.fill"
        muteButton.setImage(UIImage(systemName: imageName, withConfiguration: config), for: .normal)
        startControlsTimer()
    }

    @objc private func playerViewTapped() {
        if controlsOverlay.alpha == 0 {
            showControls()
        } else {
            hideControls()
        }
    }

    @objc private func progressSliderChanged(_ slider: UISlider) {
        guard let duration = player?.currentItem?.duration else { return }
        let value = Float64(slider.value) * CMTimeGetSeconds(duration)
        timeLabel.text = formatTime(seconds: value)
    }

    @objc private func progressSliderEndedEditing(_ slider: UISlider) {
        guard let duration = player?.currentItem?.duration else { return }
        let value = Float64(slider.value) * CMTimeGetSeconds(duration)
        let time = CMTime(seconds: value, preferredTimescale: 600)
        player?.seek(to: time)
        startControlsTimer()
    }

    @objc private func playerItemDidReachEnd() {
        // Seek to beginning and play again
        player?.seek(to: .zero)
        player?.play()
    }

    private func updatePlaybackStatus() {
        guard let player = player else { return }
        isPlaying = player.rate != 0
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        let imageName = isPlaying ? "pause.fill" : "play.fill"
        playPauseButton.setImage(UIImage(systemName: imageName, withConfiguration: config), for: .normal)

        // Update progress slider
        if let duration = player.currentItem?.duration,
           !duration.isIndefinite {
            let currentTime = CMTimeGetSeconds(player.currentTime())
            let totalDuration = CMTimeGetSeconds(duration)
            progressSlider.value = Float(currentTime / totalDuration)
        }
    }

    private func updateTimeLabels() {
        guard let currentTime = player?.currentTime(),
              let duration = player?.currentItem?.duration,
              !duration.isIndefinite else { return }

        let currentSeconds = CMTimeGetSeconds(currentTime)
        timeLabel.text = formatTime(seconds: currentSeconds)
    }

    private func updateDurationLabel() {
        guard let duration = player?.currentItem?.duration,
              !duration.isIndefinite else { return }

        let totalSeconds = CMTimeGetSeconds(duration)
        durationLabel.text = formatTime(seconds: totalSeconds)
    }

    private func formatTime(seconds: Float64) -> String {
        let minutes = Int(seconds / 60)
        let seconds = Int(seconds.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func showControls() {
        UIView.animate(withDuration: 0.3) {
            self.controlsOverlay.alpha = 1
        }
        startControlsTimer()
    }

    private func hideControls() {
        UIView.animate(withDuration: 0.3) {
            self.controlsOverlay.alpha = 0
        }
        controlsTimer?.invalidate()
        controlsTimer = nil
    }

    private func startControlsTimer() {
        controlsTimer?.invalidate()
        showControls()
        controlsTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [weak self] _ in
            self?.hideControls()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        controlsTimer?.invalidate()
        controlsTimer = nil

        if let timeObserverToken = timeObserverToken {
            player?.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }

    // MARK: - Cleanup
    deinit {
        NotificationCenter.default.removeObserver(self)
        player?.pause()
        player = nil
    }
}
