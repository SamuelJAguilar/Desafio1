import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                    context, 
                    '/', 
                    (route) => false
                  );
            },
            child: Row(
              children: [
                Icon(Icons.event, color: Colors.red, size: 40),
                Text(
                  ' Centro de Eventos',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Los mejores eventos en un solo lugar',
            style: TextStyle(fontSize: 18, color: const Color.fromARGB(255, 7, 66, 114), fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}