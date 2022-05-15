//
// Copyright © 2022 Stream.io Inc. All rights reserved.
//

import StreamChat
import StreamChatUI
import UIKit

extension ChatClient {
    /// The channel name that we want to use for the livestream chat
    static let livestreamChannelName = "ytlivestream"
    
    /// The singleton instance of `ChatClient`
    
}

extension ChatChannelController {
    static var liveStreamChannelController: ChatChannelController {
        ChatClient.sharedLive.channelController(
            for: ChannelId(
                type: .livestream,
                id: ChatClient.livestreamChannelName
            )
        )
    }
}
