import 'dart:async';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:usb_arduino/app/constants.dart';
import 'package:usb_serial/transaction.dart';
import 'package:usb_serial/usb_serial.dart';

class DashboardScreen extends StatefulWidget {
  static const String routeName = '/dashboardscreen';
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  UsbPort? _port;
  String _status = "Idle";
  List<Widget> _ports = [];
  List<Widget> _serialData = [];

  StreamSubscription<String>? _subscription;
  Transaction<String>? _transaction;
  UsbDevice? _device;

  String lastCelsius = '';
  String lastFahrenheit = '';

  bool isCelsius = false;

  late List<int> _chartData = [];

  String _finalResult = '';
  int _count = 0;

  @override
  void initState() {
    super.initState();

    _chartData = getfaharenitChartData();
    _chartData = getCelciousChartData();

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

  List<int> getfaharenitChartData() {
    // Ensure lastFahrenheit is a valid number
    double fahrenheit = double.tryParse(lastFahrenheit) ?? 0.0;
    int fValue = fahrenheit.round(); // Convert to integer
    // Return the data as chart data
    return [fValue];
  }

  List<int> getCelciousChartData() {
    double celcious = double.tryParse(lastCelsius) ?? 0.0;
    int cValue = celcious.round();
    return [cValue];
  }

  // Function to connect to USB device
  Future<bool> _connectTo(device) async {
    _serialData.clear();
    lastFahrenheit = '';
    lastCelsius = '';

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
        isCelsius = false;
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
      setState(() {
        _serialData
            .add(Text(line, style: const TextStyle(color: Colors.white)));
        if (_serialData.length > 20) {
          _serialData.removeAt(0);
        }
      });

      // Check if the received line contains the expected code pattern
      if (line.contains("INVST20249901")) {
        String receivedCode = line.trim();
        print(receivedCode);

        String responseCode = "OK";

        // Future.delayed(const Duration(seconds: 1), () {
        print('Sending response back: $responseCode');
        _port!.write(Uint8List.fromList(responseCode.codeUnits));
        // });
      } else {
        print('Code not matched');
      }

      // Process temperature data
      processLine(line);
    });

    setState(() {
      _status = "Connected";
    });
    return true;
  }

  void processLine(String line) {
    // Regex patterns to match temperature values
    RegExp cRegExp = RegExp(r'C(\d+\.\d+)#');
    RegExp fRegExp = RegExp(r'F(\d+\.\d+)#');

    if (cRegExp.hasMatch(line)) {
      Match? cMatch = cRegExp.firstMatch(line);
      if (cMatch != null) {
        lastCelsius = cMatch.group(1) ?? '';
      }
    }

    if (fRegExp.hasMatch(line)) {
      Match? fMatch = fRegExp.firstMatch(line);
      if (fMatch != null) {
        lastFahrenheit = fMatch.group(1) ?? '';
      }
    }

    setState(() {
      _serialData.clear();
      _chartData.clear();
      if (lastFahrenheit.isNotEmpty) {
        _serialData.add(Text("Fahrenheit: $lastFahrenheit°F",
            style: const TextStyle(color: Colors.white)));
      }

      if (isCelsius && lastFahrenheit.isNotEmpty) {
        lastCelsius = fahrenheitToCelsius(double.parse(lastFahrenheit))
            .toStringAsFixed(2);
      }
      // Update the chart data when the Fahrenheit value changes
      _chartData =
          !isCelsius ? getfaharenitChartData() : getCelciousChartData();

      print("last f = ${lastFahrenheit}");

      String finalResult = lastFahrenheit;
      print("final r = ${finalResult}");

      if (finalResult == lastFahrenheit) {
        _count++;
        // print('@@@@@@@@@@@@@@@@@@@@@@@@@@@${_count}');
      }

      _count == 10 ? _finalResult = lastFahrenheit : '';
    });
  }

  double fahrenheitToCelsius(double fahrenheit) {
    return (fahrenheit - 32) * 5 / 9;
  }

  // Fetch list of available USB ports
  void _getPorts() async {
    _ports = [];
    List<UsbDevice> devices = await UsbSerial.listDevices();
    // if (!devices.contains(_device)) {
    //   _connectTo(null);
    // }

    if (devices.isNotEmpty) {
      // Request permission to access the device
      await _connectTo(devices.first);
    } else {
      _connectTo(null);
    }
    print(devices);

    devices.forEach((device) {
      _ports.add(SvgPicture.asset(
        'assets/signal-on.svg',
        color: mSuccessColor,
      ));
    });

    setState(() {
      print(_ports);
    });
  }

  bool _isUpsideDown = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mBackgroundColor,
      body: Transform(
        alignment: Alignment.center,
        transform:
            _isUpsideDown ? Matrix4.rotationZ(3.14159) : Matrix4.identity(),
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
                      const Text('Smart Temperature',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                      if (_status != 'Connected')
                        SvgPicture.asset('assets/signal-off.svg',
                            color: mWhiteColor),
                      ..._ports
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            'F',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: mWhiteColor),
                          ),
                          Switch(
                            value: isCelsius && _status == 'Connected',
                            activeColor: isCelsius && _status == 'Connected'
                                ? mSuccessColor
                                : mGreyColor,
                            onChanged: (value) {
                              if (_status == 'Connected') {
                                setState(() {
                                  isCelsius = value;
                                  if (isCelsius && lastFahrenheit.isNotEmpty) {
                                    lastCelsius = fahrenheitToCelsius(
                                            double.parse(lastFahrenheit))
                                        .toStringAsFixed(2);
                                  }
                                });
                              }
                            },
                          ),
                          Text(
                            'C',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: isCelsius && _status == 'Connected'
                                    ? mSuccessColor
                                    : mWhiteColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                      AvatarGlow(
                        startDelay: const Duration(microseconds: 1000),
                        animate: _status == 'Connected' ? true : false,
                        glowColor: mBackgroundColor,
                        curve: Curves.fastOutSlowIn,
                        glowShape: BoxShape.circle,
                        glowRadiusFactor: 0.15,
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: MediaQuery.of(context).size.height * 0.2,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              if (_status == 'Connected')
                                SfCircularChart(
                                  series: <CircularSeries>[
                                    RadialBarSeries<int, String>(
                                        dataSource: _chartData,
                                        xValueMapper: (int data, _) => '',
                                        yValueMapper: (int data, _) =>
                                            _status == 'Connected' ? data : 0,
                                        dataLabelSettings:
                                            const DataLabelSettings(
                                                isVisible: true),
                                        enableTooltip: true,
                                        maximumValue: isCelsius ? 150 : 300,
                                        innerRadius: '148',
                                        trackColor: mPrimaryColor,
                                        strokeColor: mOrangeColor,
                                        trackBorderColor: mOrangeColor,
                                        radius: '156'),
                                  ],
                                ),
                              // Positioned content inside the circle
                              Container(
                                height: double.infinity,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: mPrimaryColor, width: 3.5),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (_status == 'Connected') ...[
                                      isCelsius
                                          ? Text(
                                              "$lastCelsius°C",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 50,
                                                color: Colors.orange,
                                              ),
                                            )
                                          : Text(
                                              "$lastFahrenheit°F",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 50,
                                                color: Colors.orange,
                                              ),
                                            )
                                    ] else ...[
                                      const Text(
                                        'No Device Available',
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 18),
                                      )
                                    ]
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 160),
                    ],
                  ),
                  if (_status == 'Connected')
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: CircleAvatar(
                          radius: 25,
                          backgroundColor: mSecondaryColor,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isUpsideDown = !_isUpsideDown;
                              });
                            },
                            child: SvgPicture.asset(
                              'assets/rotate.svg',
                              height: 30,
                            ),
                          )
                          // IconButton(
                          //     onPressed: () {
                          //       setState(() {
                          //         _isUpsideDown = !_isUpsideDown;
                          //       });
                          //       print(_isUpsideDown);
                          //     },
                          //     icon: const Icon(Icons.rotate_right)),
                          ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
