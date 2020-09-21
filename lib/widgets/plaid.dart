import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:plaid_flutter/plaid_flutter.dart';
import 'package:http/http.dart' as http;

class PlaidWidget extends StatefulWidget {
  @override
  _PlaidWidgetState createState() => _PlaidWidgetState();
}

class _PlaidWidgetState extends State<PlaidWidget> {
  PlaidLink _plaidPublicKey, _plaidLinkToken;

  Future<String> getToken() async {
    var data = {
      "client_id": "5f5fd7d35f6405001006a206",
      "secret": "3ff51f23d01ff487b8acedcae80304",
      "client_name": "camerony",
      "language": "en",
      "country_codes": ["US"],
      "user": {"client_user_id": "azerty"},
      "products": [
        "auth",
        "transactions",
        "identity",
        "assets",
        "investments",
        "liabilities"
      ]
    };
    var response = await http.post(
        'https://sandbox.plaid.com/link/token/create',
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(data));

    var _token = jsonDecode(response.body);
    return _token['link_token'].toString();
  }

  @override
  void initState() {
    super.initState();
    Future<String> _token = getToken();

    LinkConfiguration linkTokenConfiguration;
    _token.then((value) => {
          linkTokenConfiguration = LinkConfiguration(linkToken: value),
          _plaidLinkToken = PlaidLink(
            configuration: linkTokenConfiguration,
            onSuccess: _onSuccessCallback,
            onEvent: _onEventCallback,
            onExit: _onExitCallback,
          ),
        });
  }

  void _onSuccessCallback(String publicToken, LinkSuccessMetadata metadata) {
    print("onSuccess: $publicToken, metadata: ${metadata.description()}");
  }

  void _onEventCallback(String event, LinkEventMetadata metadata) {
    print("onEvent: $event, metadata: ${metadata.description()}");
  }

  void _onExitCallback(String error, LinkExitMetadata metadata) {
    print("onExit: $error, metadata: ${metadata.description()}");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          width: double.infinity,
          color: Colors.purple[200],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: () => _plaidLinkToken.open(),
                child: Text("Connect to Plaid Account"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
