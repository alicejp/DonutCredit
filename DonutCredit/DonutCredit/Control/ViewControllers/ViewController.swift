import UIKit

class ViewController: UIViewController
{
    private var processView: ProcessView!
    private let processViewModel: ProcessViewModel

    init(viewModel: ProcessViewModel)
    {
        self.processViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addProcessView()
        fetchCredit()
    }

    private func addProcessView()
    {
        processView = ProcessView(frame: view.bounds)
        view.addSubview(processView)

        processView.fatchBtnTapped = {
            [weak self] in
            guard let self = self else { return }
            self.fetchCredit()
        }

        processView.layout([
            processView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            processView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            processView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            processView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func fetchCredit()
    {
        processViewModel.fetchCredit {
            [weak self] result in
            guard let self = self else { return }

            switch result
            {
            case .failure(let error):
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: "Network request failed: \(error)", preferredStyle: .alert)
                    alert.view.tintColor = UIColor.purple
                    alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: { _ in }))
                    self.present(alert, animated: true, completion: nil)

                    self.processView.updateWith(self.processViewModel)
                }

            case .success:
                DispatchQueue.main.async {
                    self.processView.updateWith(self.processViewModel)
                }
            }
        }
    }
}

extension UIView
{
    final func layout(_ constraints: [NSLayoutConstraint])
    {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
        layoutIfNeeded()
    }
}
