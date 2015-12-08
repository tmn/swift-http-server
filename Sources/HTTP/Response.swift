import func libc.send
import func libc.strlen

public class Response {
    func sendMessage(socket: Int32, message: String) {
        send(socket,[UInt8](message.utf8), Int(strlen(message)), 0)
    }
}