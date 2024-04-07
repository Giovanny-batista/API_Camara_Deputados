import 'package:flutter/material.dart';
import 'package:parliament/routes/router.dart' as routes;

class Home extends StatelessWidget {
  const Home({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300], 
      body: Row(
        children: [
          
          SizedBox(
            width: 120, 
            child: Container(
              color: Colors.grey[800], 
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, routes.deputados);
                    },
                    child: Text(
                      'Deputados',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, routes.comissao);
                    },
                    child: Text(
                      'Comissões',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 200, 
                    width: MediaQuery.of(context).size.width * 0.75, 
                    child: Image.network(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQyFuy7J_4t6Zlu2yFn_KWwdcWwJlfs2C4M3azv7XJ0Ng&s',
                      fit: BoxFit.cover, 
                    ),
                  ),
                  const SizedBox(height: 16), 
                  
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
