// import 'dart:io';

// // Future<void> testSocket() async {
// //   try {
// //     final socket = await WebSocket.connect(
// //       'wss://stage.brahmakosh.com/socket.io/?EIO=4&transport=websocket',
// //       headers: {
// //         'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2OTc5ZTk3Nzc0ZTc4ZDg2YTY0YmVkMmEiLCJyb2xlIjoicGFydG5lciIsImlhdCI6MTc3MDQ5MTMwNiwiZXhwIjoxNzcxMDk2MTA2fQ.3NdIUjJU4fXOlfZjtNvXys2TlbGDVzbKVtlynm13C3k',
// //       },
// //     );

// //     print("🟢 CONNECTED");

// //     socket.listen(
// //       (data) {
// //         print("📩 DATA: $data");
// //       },
// //       onError: (err) {
// //         print("❌ ERROR: $err");
// //       },
// //       onDone: () {
// //         print("🔴 CLOSED");
// //       },
// //     );
// //   } catch (e) {
// //     print("❌ EXCEPTION: $e");
// //   }
// // }
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// void testSocketIO() {
//   final socket = IO.io(
//     "https://stage.brahmakosh.com",
//     {
//       "transports": ["polling", "websocket"], // polling first
//       "path": "/socket.io/",
//       "auth": {
//         "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2OTc5ZTk3Nzc0ZTc4ZDg2YTY0YmVkMmEiLCJyb2xlIjoicGFydG5lciIsImlhdCI6MTc3MDQ5MTMwNiwiZXhwIjoxNzcxMDk2MTA2fQ.3NdIUjJU4fXOlfZjtNvXys2TlbGDVzbKVtlynm13C3k",

//       },
//       "autoConnect": true,
//     },
//   );

//   socket.onConnect((_) {
//     print("CONNECTED: ${socket.id}");
//   });

//   socket.onConnectError((err) {
//     print("CONNECT ERROR: $err");
//   });

//   socket.onError((err) {
//     print("ERROR: $err");
//   });
// }
