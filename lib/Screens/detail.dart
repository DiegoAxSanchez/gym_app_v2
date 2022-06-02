import 'package:gym_app_v2/Models/Patient.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  DetailScreen({super.key, required this.patient});
  Patient patient;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient: ${patient.nom}, ${patient.prenom}'),
      ),
      body: Center(
        child: _buildStack(patient),
      ),
    );
  }

  // #docregion Stack
  Widget _buildStack(Patient patient) {
    return Stack(
      alignment: const Alignment(0.6, 0.6),
      children: [
        const CircleAvatar(
          backgroundImage: AssetImage('images/pic.jpg'),
          radius: 100,
        ),
        Container(
          decoration: const BoxDecoration(
            color: Colors.black45,
          ),
          child: Text(
            '${patient.nom} ${patient.prenom}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 241, 241, 241),
            ),
          ),
        ),
      ],
    );
  }
// #enddocregion Stack
}
