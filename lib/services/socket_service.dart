import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:shared_preferences/shared_preferences.dart';

class SocketService {
  // Make baseUrl static so it can be accessed in static methods
  static final String baseUrl = "http://172.20.10.5:3000"; // Replace with your server URL

  static io.Socket? _socket;
  static bool _isSocketConnected = false;

  static io.Socket get socket {
    if (_socket == null) throw Exception('Socket non initialisée');
    return _socket!;
  }

  /// Initialisation de la connexion WebSocket avec un fallback HTTP
  static Future<void> initialize() async {
    if (_socket != null) return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    try {
      _socket = io.io(
        baseUrl, // Access the static baseUrl
        io.OptionBuilder()
            .setTransports(['websocket']) // Use WebSocket transport
            .enableAutoConnect()
            .setQuery({'token': token}) // Pass the token for authentication
            .build(),
      );

      _socket!.onConnect((_) {
        _isSocketConnected = true;
        print('✅ WebSocket connecté');
      });

      _socket!.onDisconnect((_) {
        _isSocketConnected = false;
        print('⚠️ WebSocket déconnecté');
      });

      _socket!.onConnectError((error) {
        print('❌ Erreur de connexion WebSocket: $error');
      });

      _socket!.onError((error) {
        print('❌ Erreur WebSocket: $error');
      });

      _socket!.connect();
    } catch (e) {
      print('❌ Erreur lors de la connexion WebSocket: $e');
    }
  }

  /// Déconnexion WebSocket
  static void disconnect() {
    _socket?.disconnect();
    _socket = null;
    _isSocketConnected = false;
    print('🔌 WebSocket déconnecté');
  }

  /// Écoute des messages WebSocket
  static void onMessageReceived(Function(dynamic) handler) {
    _socket?.on('message', handler);
  }

  /// Écoute de la notification de saisie
  static void onTypingReceived(Function(dynamic) handler) {
    _socket?.on('typingNotification', handler);
  }

  /// Envoi d'un message avec WebSocket ou HTTP
  static Future<void> sendMessage(Map<String, dynamic> message) async {
    if (_isSocketConnected && _socket != null) {
      _socket!.emit('sendMessage', message);
      print('📤 Message envoyé via WebSocket');
    } else {
      await _sendMessageViaHttp(message);
    }
  }

  /// Fallback pour envoyer un message via HTTP
  static Future<void> _sendMessageViaHttp(Map<String, dynamic> message) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null) {
        throw Exception('Token d\'accès non disponible');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/sendMessage'), // Access the static baseUrl
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(message),
      );

      if (response.statusCode == 200) {
        print('📤 Message envoyé via HTTP avec succès');
      } else {
        print('❌ Erreur HTTP: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('❌ Erreur lors de l\'envoi du message via HTTP: $e');
    }
  }
}