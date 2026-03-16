

// ================= socket_events.dart =================
class SocketEvents {
  // ===== Presence =====
  static const partnerOnline = "partner:online";
  static const partnerStatusUpdate = "partner:status:update";
  static const partnerStatusChanged = "partner:status:changed";

  // ===== Conversation =====
  static const newConversationRequest = "notification:conversation:request";
  static const conversationCancelled = "notification:conversation:cancelled";
  static const joinConversation = "conversation:join";
  static const leaveConversation = "conversation:leave";
  static const bulkJoinConversation = "conversation:bulk-join";

  // ===== Messaging =====
  static const sendMessage = "message:send";
  static const newMessage = "message:new";
  static const messageDelivered = "message:delivered";
  static const messageRead = "message:read";
  static const readReceipt = "message:read:receipt";

  // ===== End Conversation =====
  static const endConversation = "conversation:end";
  static const conversationEnded = "conversation:ended";
  static const conversationEndFailed = "conversation:end:failed";

  // ===== Typing =====
  static const typingStart = "typing:start";
  static const typingStop = "typing:stop";
  static const typingStatus = "typing:status";




  // ===== Voice Calls (WebRTC Signaling) =====
static const voiceCallInitiate = "voice:call:initiate";
static const voiceCallIncoming = "voice:call:incoming";
static const voiceCallAccept = "voice:call:accept";
static const voiceCallAccepted = "voice:call:accepted";
static const voiceCallReject = "voice:call:reject";
static const voiceCallRejected = "voice:call:rejected";
static const voiceSignal = "voice:signal";
static const voiceCallEnd = "voice:call:end";
static const voiceCallEnded = "voice:call:ended";

}
