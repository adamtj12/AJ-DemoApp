import Foundation

/// Dumb error to model simple errors
/// In a real implementation this should be more exhaustive
public enum ErrorModel: Error {
	case encoding
	case decoding
	case server(message: String)
}
