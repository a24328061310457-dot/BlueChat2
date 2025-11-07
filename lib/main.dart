import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const BluetoothChatApp());
}

class BluetoothChatApp extends StatelessWidget {
  const BluetoothChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat Bluetooth',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const ChatHomePage(),
    );
  }
}

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({super.key});

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  BluetoothConnection? connection;
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  List<BluetoothDevice> devices = [];
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    _initBluetooth();
  }

  Future<void> _initBluetooth() async {
    await Permission.bluetooth.request();
    await Permission.location.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();

    final state = await FlutterBluetoothSerial.instance.state;
    setState(() => _bluetoothState = state);

    if (state == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
    }

    devices = await FlutterBluetoothSerial.instance.getBondedDevices();
    setState(() {});
  }

  Future<void> startServer() async {
    // Este método crea un servidor Bluetooth usando acceptOn()
   final connection = await FlutterBluetoothSerial.instance
    .onAccept()
    .first;


    connection!.input!.listen((Uint8List data) {
      final msg = utf8.decode(data);
      setState(() {
        messages.add({
          "text": msg,
          "isMe": false,
          "time": DateFormat('hh:mm a').format(DateTime.now()),
        });
      });
    });
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    connection = await BluetoothConnection.toAddress(device.address);
    setState(() {
      messages.add({
        "text": "✅ Conectado a ${device.name}",
        "isMe": true,
        "time": DateFormat('hh:mm a').format(DateTime.now()),
      });
    });

    connection!.input!.listen((Uint8List data) {
      final msg = utf8.decode(data);
      setState(() {
        messages.add({
          "text": msg,
          "isMe": false,
          "time": DateFormat('hh:mm a').format(DateTime.now()),
        });
      });
    });
  }

  void sendMessage() {
    if (connection == null || _messageController.text.trim().isEmpty) return;
    final text = _messageController.text.trim();
    connection!.output.add(Uint8List.fromList(utf8.encode(text)));
    setState(() {
      messages.add({
        "text": text,
        "isMe": true,
        "time": DateFormat('hh:mm a').format(DateTime.now()),
      });
    });
    _messageController.clear();
  }

  @override
  void dispose() {
    connection?.dispose();
    super.dispose();
  }

  Widget _buildMessageBubble(String text, bool isMe, String time) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isMe ? Colors.teal[200] : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isMe ? const Radius.circular(12) : const Radius.circular(0),
            bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(12),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(text, style: const TextStyle(fontSize: 16, color: Colors.black87)),
            const SizedBox(height: 4),
            Text(time, style: TextStyle(fontSize: 11, color: Colors.grey[700])),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Bluetooth'), centerTitle: true),
      body: Column(
        children: [
          Text("Estado Bluetooth: $_bluetoothState"),
          if (connection == null)
            Expanded(
              child: ListView(
                children: [
                  const ListTile(title: Text("Modo servidor o cliente")),
                  ListTile(
                    title: const Text("🟢 Iniciar como Servidor"),
                    onTap: startServer,
                  ),
                  const Divider(),
                  const ListTile(title: Text("🔵 Conectar a un dispositivo")),
                  ...devices.map(
                    (d) => ListTile(
                      title: Text(d.name ?? "Dispositivo"),
                      subtitle: Text(d.address),
                      onTap: () => connectToDevice(d),
                    ),
                  )
                ],
              ),
            )
          else
            Expanded(
              child: Container(
                color: Colors.grey[100],
                child: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    return _buildMessageBubble(
                        msg["text"], msg["isMe"], msg["time"]);
                  },
                ),
              ),
            ),
          if (connection != null)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: "Escribe un mensaje...",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: IconButton(
                      onPressed: sendMessage,
                      icon: const Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
