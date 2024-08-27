import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:nba_app/team.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Team> teams = [];

  Future<http.Response> getTeams() async {
    teams.clear();
    final apiKey =
        '55786edc-ec7a-49f1-996e-33f9f1705738'; // Replace with your actual API key

    final response = await http.get(
      Uri.https(
        'api.balldontlie.io',
        '/v1/teams',
      ),
      headers: {
        'Authorization': apiKey,
      },
    );

    var jsonData = jsonDecode(response.body);
    for (var eachTeam in jsonData['data']) {
      Team team = Team(
          abbreviation: eachTeam['abbreviation'],
          city: eachTeam['city'],
          fullName: eachTeam['full_name']);
      teams.add(team);
    }
    return response;
  }

  @override
  void initState() {
    super.initState();
    getTeams();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
        title: const Text('NBA TEAMS'),
      ),
      body: FutureBuilder<http.Response>(
        future: getTeams(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: teams.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const CircleAvatar(
                    child: Icon(
                      Icons.sports_basketball,
                      color: Colors.orange,
                    ),
                  ),
                  title: Text(teams[index].fullName),
                  subtitle: Text(teams[index].city),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
