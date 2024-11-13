import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

class TemperatureDashboard extends StatefulWidget {
  @override
  _TemperatureDashboardState createState() => _TemperatureDashboardState();
}

class _TemperatureDashboardState extends State<TemperatureDashboard> {
  Map<String, dynamic>? sensorData;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    fetchData(); // Ambil data pertama kali
    // Set timer untuk mengambil data setiap 5 detik
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) => fetchData());
  }

  @override
  void dispose() {
    timer?.cancel(); // Batalkan timer ketika widget di-dispose
    super.dispose();
  }

  Future<void> fetchData() async {
    try {
      // Ganti URL sesuai dengan server Anda
      // Untuk emulator Android: 10.0.2.2
      // Untuk device fisik: IP komputer Anda
      final response =
          await http.get(Uri.parse('http://10.0.2.2:3000/api/data'));

      if (response.statusCode == 200) {
        setState(() {
          sensorData = json.decode(response.body);
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (sensorData == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Container(
        color: Colors.grey[800],
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Temperature Summary Card
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ringkasan Suhu',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildTempItem('${sensorData!['suhumax']}°C',
                                'Suhu Max', Colors.red),
                            _buildTempItem('${sensorData!['suhumin']}°C',
                                'Suhu Min', Colors.blue),
                            _buildTempItem('${sensorData!['suhurata']}°C',
                                'Suhu Rata', Colors.green),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // Measurement Details Card
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Detail Pengukuran',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildMeasurementItem(
                          sensorData!['nilai_suhu_max_humid_max'][0]['0']['idx']
                              .toString(),
                          sensorData!['nilai_suhu_max_humid_max'][0]['0']
                              ['timestamp'],
                          sensorData!['nilai_suhu_max_humid_max'][0]['0']
                              ['suhun'],
                          sensorData!['nilai_suhu_max_humid_max'][0]['0']
                              ['humid'],
                          sensorData!['nilai_suhu_max_humid_max'][0]['0']
                              ['kecerahan'],
                        ),
                        SizedBox(height: 16),
                        _buildMeasurementItem(
                          sensorData!['nilai_suhu_max_humid_max'][1]['1']['idx']
                              .toString(),
                          sensorData!['nilai_suhu_max_humid_max'][1]['1']
                              ['timestamp'],
                          sensorData!['nilai_suhu_max_humid_max'][1]['1']
                              ['suhun'],
                          sensorData!['nilai_suhu_max_humid_max'][1]['1']
                              ['humid'],
                          sensorData!['nilai_suhu_max_humid_max'][1]['1']
                              ['kecerahan'],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // Time Period Card
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Periode Waktu',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildPeriodItem(sensorData!['month_year_max'][0]['0']
                            ['month_year']),
                        SizedBox(height: 8),
                        _buildPeriodItem(sensorData!['month_year_max'][1]['1']
                            ['month_year']),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget helper methods remain the same
  Widget _buildTempItem(String temp, String label, Color color) {
    return Column(
      children: [
        Text(
          temp,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildMeasurementItem(
    String id,
    String timestamp,
    int temp,
    int humidity,
    int brightness,
  ) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ID: $id',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
            ),
          ),
          Text(
            timestamp,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMeasurementValue(Icons.thermostat, '$temp°C', 'Suhu'),
              _buildMeasurementValue(
                  Icons.water_drop, '$humidity%', 'Kelembaban'),
              _buildMeasurementValue(
                  Icons.wb_sunny, '$brightness', 'Kecerahan'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMeasurementValue(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.green[600],
          size: 24,
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodItem(String period) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            Icons.calendar_today,
            size: 16,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(width: 8),
        Text(
          period,
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
