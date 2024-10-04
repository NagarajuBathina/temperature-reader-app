import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:usb_arduino/app/colors.dart';
import 'package:usb_arduino/app/constants.dart';
import 'package:usb_arduino/main.dart';
import 'package:usb_serial/transaction.dart';
import 'package:usb_serial/usb_serial.dart';

class DashboardScreen2 extends StatefulWidget {
  const DashboardScreen2({super.key});

  @override
  State<DashboardScreen2> createState() => _DashboardScreen2State();
}

class _DashboardScreen2State extends State<DashboardScreen2>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  UsbPort? _port;
  String _status = "Idle";
  List<Widget> _ports = [];
  List<Widget> _serialData = [];

  String c = '';
  String f = '';

  StreamSubscription<String>? _subscription;
  Transaction<String>? _transaction;
  UsbDevice? _device;

  final TextEditingController _textController = TextEditingController();
  String lastCelsius = '';
  String lastFahrenheit = '';

  bool isCelsius = false;
  // Function to connect to USB device
  Future<bool> _connectTo(device) async {
    _serialData.clear();

    if (_subscription != null) {
      _subscription!.cancel();
      _subscription = null;
    }

    if (_transaction != null) {
      _transaction!.dispose();
      _transaction = null;
    }

    if (_port != null) {
      _port!.close();
      _port = null;
    }

    if (device == null) {
      _device = null;
      setState(() {
        _status = "Disconnected";
      });
      return true;
    }

    _port = await device.create();
    if (await (_port!.open()) != true) {
      setState(() {
        _status = "Failed to open port";
      });
      return false;
    }
    _device = device;

    await _port!.setDTR(true);
    await _port!.setRTS(true);
    await _port!.setPortParameters(
        115200, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

    _transaction = Transaction.stringTerminated(
        _port!.inputStream as Stream<Uint8List>, Uint8List.fromList([13, 10]));

    _subscription = _transaction!.stream.listen((String line) async {
      print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!${line}");

      setState(() {
        _serialData
            .add(Text(line, style: const TextStyle(color: Colors.white)));
        if (_serialData.length > 20) {
          _serialData.removeAt(0);
        }
      });

      // Check if the received line contains the expected code pattern
      if (line.contains("INVST20249901")) {
        // Extract the received code (e.g., "INVST20249901")
        String receivedCode = line.trim();
        print(receivedCode);

        // Prepare the response code (e.g., "OINVST20249901K")
        String responseCode = "O${receivedCode}K";

        print("Sending back: $responseCode");

        // Send the response code back to the device
        String dataToSend = "$responseCode\r\n";
        _port!.write(Uint8List.fromList(dataToSend.codeUnits));
      }

      // Check if the line contains temperature data in Celsius (C) and Fahrenheit (F)
      processLine(line);
    });

    setState(() {
      _status = "Connected";
    });
    return true;
  }

  void processLine(String line) {
    // Regex patterns to match the temperature values
    RegExp cRegExp = RegExp(r'C(\d+\.\d+)#');
    RegExp fRegExp = RegExp(r'F(\d+\.\d+)#');

    // Check for Celsius values
    if (cRegExp.hasMatch(line)) {
      Match? cMatch = cRegExp.firstMatch(line);
      if (cMatch != null) {
        lastCelsius = cMatch.group(1) ?? ''; // Get the value or an empty string
      }
    }

    // Check for Fahrenheit values
    if (fRegExp.hasMatch(line)) {
      Match? fMatch = fRegExp.firstMatch(line);
      if (fMatch != null) {
        lastFahrenheit =
            fMatch.group(1) ?? ''; // Get the value or an empty string
      }
    }
// Debugging logs
    print("Last Celsius: $lastCelsius, Last Fahrenheit: $lastFahrenheit");

    setState(() {
      _serialData.clear(); // Clear previous data
      if (lastFahrenheit.isNotEmpty) {
        _serialData.add(Text("Fahrenheit: $lastFahrenheit°F",
            style: const TextStyle(color: Colors.white)));
      }

      // if (lastCelsius.isNotEmpty) {
      //   _serialData.add(Text("Celsius: $lastCelsius°C",
      //       style: const TextStyle(color: Colors.white)));
      // }
    });
  }

  // Fetches list of available USB ports
  void _getPorts() async {
    _ports = [];
    List<UsbDevice> devices = await UsbSerial.listDevices();
    if (!devices.contains(_device)) {
      _connectTo(null);
    }
    print(devices);

    devices.forEach((device) {
      _ports.add(ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: _device == device ? Colors.red : Colors.blue),
        child: Text(_device == device ? "Disconnect" : "Connect",
            style:
                const TextStyle(color: Colors.white)), // White text on button
        onPressed: () {
          _connectTo(_device == device ? null : device).then((res) {
            _getPorts();
          });
        },
      )
          // ListTile(
          //   leading: const Icon(Icons.usb, color: Colors.white), // White icon
          //   title: Text(device.productName ?? 'Unknown product',
          //       style: const TextStyle(color: Colors.white)), // White text
          //   subtitle: Text(device.manufacturerName ?? 'Unknown manufacturer',
          //       style: const TextStyle(color: Colors.white)), // White text
          //   trailing: ElevatedButton(
          //     style: ElevatedButton.styleFrom(
          //         primary: _device == device ? Colors.red : Colors.blue),
          //     child: Text(_device == device ? "Disconnect" : "Connect",
          //         style: const TextStyle(
          //             color: Colors.white)), // White text on button
          //     onPressed: () {
          //       _connectTo(_device == device ? null : device).then((res) {
          //         _getPorts();
          //       });
          //     },
          //   ))
          );
    });

    setState(() {
      print(_ports);
    });
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5), // Duration of one full rotation
    )..repeat(); // Repeat the animation indefinitely

    UsbSerial.usbEventStream!.listen((UsbEvent event) {
      _getPorts();
    });

    _getPorts();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _connectTo(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackgroundColor(
        // Assuming you have a custom gradient background
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('USB Arduino',
                          style: TextStyle(
                              color: Colors.white, // White text
                              fontWeight: FontWeight.bold,
                              fontSize: 25)),
                      // Switch(
                      //   activeColor: Colors.green,
                      //   inactiveThumbColor: Colors.red,
                      //   value: _status == 'Connected' ? true : false,
                      //   onChanged: (value) {},
                      // ),
                      ..._ports
                    ],
                  ),
                  // const SizedBox(height: 50),
                  // Text(
                  //     _ports.length > 0
                  //         ? "Available Serial Ports"
                  //         : "No serial devices available",
                  //     style: const TextStyle(
                  //         color: Colors.white, // White text
                  //         fontSize: 25,
                  //         fontWeight: FontWeight.bold)),
                  // ..._ports,
                  // Text('Status: $_status\n',
                  //     style:
                  //         const TextStyle(color: Colors.white)), // White text
                  // Text('info: ${_port.toString()}\n',
                  //     style:
                  //         const TextStyle(color: Colors.white)), // White text

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 50),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'C',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 40,
                                color: mWhiteColor),
                          ),
                          Switch(
                            value: isCelsius,
                            activeColor: isCelsius ? Colors.green : Colors.grey,
                            onChanged: (value) {
                              setState(() {
                                // isCelsius != isCelsius;
                                // lastCelsius = fahrenheitToCelsius(
                                //         double.parse(lastFahrenheit))
                                //     .toStringAsFixed(2)
                                //     .toString();
                              });
                            },
                          )
                        ],
                      ),
                      SizedBox(height: 50),
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: MediaQuery.of(context).size.height * 0.2,
                        child: Container(
                            height: double.infinity,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: mWhiteColor, width: 5)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (_status == 'Connected') ...[
                                  isCelsius
                                      ? Text(
                                          "${lastFahrenheit}°C",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 50,
                                              color: Colors.orange),
                                        )
                                      : Text("${lastFahrenheit}°F",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 50,
                                              color: Colors.orange))
                                ] else ...[
                                  const Text(
                                    'No Device Available',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 18),
                                  )
                                ]
                              ],
                            )),
                      ),
                      // AnimatedBuilder(
                      //   animation: _controller,
                      //   builder: (context, child) {
                      //     return CircleAvatar(
                      //       backgroundColor: Colors.transparent,
                      //       radius: MediaQuery.of(context).size.height * 0.2,
                      //       child: Container(
                      //           height: double.infinity,
                      //           width: double.infinity,
                      //           decoration: BoxDecoration(
                      //               shape: BoxShape.circle,
                      //               border: Border.all(
                      //                   color: Colors.transparent, width: 5)),
                      //           child: ShaderMask(
                      //             shaderCallback: (Rect bounds) {
                      //               return const RadialGradient(
                      //                 colors: [
                      //                   Colors.red,
                      //                   Colors.blue,
                      //                   Colors.green,
                      //                   Colors.yellow
                      //                 ],
                      //                 stops: [0.0, 0.3, 0.6, 1.0],
                      //                 center: Alignment.center,
                      //                 radius: 1.0,
                      //                 tileMode: TileMode.repeated,
                      //               ).createShader(bounds);
                      //             },
                      //             child: Transform.rotate(
                      //               angle: _controller.value * 2,
                      //               child: Container(
                      //                 decoration: BoxDecoration(
                      //                   shape: BoxShape.circle,
                      //                   border: Border.all(
                      //                     width: 5,
                      //                     color: Colors.transparent,
                      //                   ),
                      //                 ),
                      //                 child: Column(
                      //                   children: [
                      //                     ..._serialData,
                      //                   ],
                      //                 ),
                      //               ),
                      //             ),
                      //           )),
                      //     );
                      //   },
                      // ),

                      // ListTile(
                      //   title: TextField(
                      //     controller: _textController,
                      //     style: const TextStyle(
                      //         color: Colors.white), // White input text
                      //     decoration: const InputDecoration(
                      //         border: OutlineInputBorder(
                      //             borderSide: BorderSide(
                      //                 color: Colors.white)), // White border
                      //         labelText: 'Text To Send',
                      //         labelStyle: TextStyle(
                      //             color: Colors.white)), // White label
                      //   ),
                      //   trailing: ElevatedButton(
                      //     style: ElevatedButton.styleFrom(
                      //       primary: Colors.blue, // Blue button background
                      //     ),
                      //     onPressed: _port == null
                      //         ? null
                      //         : () async {
                      //             if (_port == null) {
                      //               return;
                      //             }
                      //             String data = "${_textController.text}\r\n";
                      //             await _port!.write(
                      //                 Uint8List.fromList(data.codeUnits));
                      //             _textController.text = "";
                      //           },
                      //     child: const Text("Send",
                      //         style: TextStyle(
                      //             color: Colors.white)), // White button text
                      //   ),
                      // ),
                      // const Text("Result Data",
                      //     style: TextStyle(color: Colors.white)), // White text
                      //..._serialData,
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}



   //  SafeArea(
      //     child: Center(
      //         child: Column(
      //   children: [
      //     ButtonBar(
      //       alignment: MainAxisAlignment.spaceBetween,
      //       children: [
      //         IconButton(
      //           onPressed: () {},
      //           icon: const Icon(Icons.arrow_back),
      //           color: mWhiteColor,
      //         ),
      //         CircleAvatar(
      //             backgroundColor: mPrimaryColor,
      //             child: IconButton(
      //                 onPressed: () {},
      //                 icon: Icon((Icons.menu), color: mWhiteColor)))
      //       ],
      //     )
      //   ],
      // ))),

//  Center(
//           child: SingleChildScrollView(
//         child: Column(children: <Widget>[
//           Text(
//               _ports.length > 0
//                   ? "Available Serial Ports"
//                   : "No serial devices available",
//               style: Theme.of(context).textTheme.titleLarge),
//           ..._ports,
//           Text('Status: $_status\n'),
//           Text('info: ${_port.toString()}\n'),
//           ListTile(
//             title: TextField(
//               controller: _textController,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Text To Send',
//               ),
//             ),
//             trailing: ElevatedButton(
//               onPressed: _port == null
//                   ? null
//                   : () async {
//                       if (_port == null) {
//                         return;
//                       }
//                       String data = _textController.text + "\r\n";
//                       await _port!.write(Uint8List.fromList(data.codeUnits));
//                       _textController.text = "";
//                     },
//               child: const Text("Send"),
//             ),
//           ),
//           Text("Result Data", style: Theme.of(context).textTheme.titleLarge),
//           ..._serialData,
//         ]),
//       )),
