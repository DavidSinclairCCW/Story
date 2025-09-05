import Foundation
import StripePaymentSheet
import UIKit

final class StripeManager {
    static let shared = StripeManager()
    private init() {}

    private let backendURL = URL(string: "Your backend endpoint/payment-sheet")!
    private var paymentSheet: PaymentSheet?

    func startCheckout(from controller: UIViewController, completion: @escaping (Bool) -> Void) {
        var request = URLRequest(url: backendURL)
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            if let error = error {
                print("Error fetching payment sheet: \(error)")
                completion(false)
                return
            }
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let customer = json["customer"] as? String,
                  let ephemeralKey = json["ephemeralKey"] as? String,
                  let paymentIntent = json["paymentIntent"] as? String,
                  let publishableKey = json["publishableKey"] as? String else {
                completion(false)
                return
            }

            STPAPIClient.shared.publishableKey = publishableKey
            var configuration = PaymentSheet.Configuration()
            configuration.merchantDisplayName = "Clarity Express"
            configuration.customer = .init(id: customer, ephemeralKeySecret: ephemeralKey)
            configuration.allowsDelayedPaymentMethods = true
            configuration.returnURL = "clarityexpress://stripe-redirect"
            self?.paymentSheet = PaymentSheet(paymentIntentClientSecret: paymentIntent, configuration: configuration)

            DispatchQueue.main.async {
                self?.paymentSheet?.present(from: controller) { result in
                    switch result {
                    case .completed:
                        completion(true)
                    default:
                        completion(false)
                    }
                }
            }
        }
        task.resume()
    }
}
