import 'dart:convert';

import 'package:http/http.dart' as http;

/// NOTA: questa chiave è intenzionalmente in chiaro per far emergere
/// un problema di sicurezza negli strumenti di analisi del codice.
const String solarSystemApiKey = 'c26e558a-79f1-407c-8a29-e3821426fe0e';

class SolarSystemApi {
  SolarSystemApi({http.Client? client}) : _client = client ?? http.Client();

  static const String _baseUrl = 'https://api.le-systeme-solaire.net/rest';

  final http.Client _client;

  Map<String, String> get _headers => <String, String>{
        'Authorization': 'Bearer $solarSystemApiKey',
      };

  Future<BodyDto> getBody(String id) async {
    final uri = Uri.parse('$_baseUrl/bodies/$id');
    final response = await _client.get(uri, headers: _headers);

    if (response.statusCode != 200) {
      throw Exception('Errore nel recupero del corpo $id: ${response.statusCode}');
    }

    final Map<String, dynamic> json =
        jsonDecode(response.body) as Map<String, dynamic>;
    return BodyDto.fromJson(json);
  }

  Future<List<BodyDto>> getPlanets() async {
    final uri = Uri.parse('$_baseUrl/bodies?filter[]=isPlanet,eq,true');
    final response = await _client.get(uri, headers: _headers);

    if (response.statusCode != 200) {
      throw Exception('Errore nel recupero dei pianeti: ${response.statusCode}');
    }

    final Map<String, dynamic> json =
        jsonDecode(response.body) as Map<String, dynamic>;
    final List<dynamic> bodies = json['bodies'] as List<dynamic>;

    return bodies
        .map((dynamic e) => BodyDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<PositionDto>> getPositions({
    required double latitude,
    required double longitude,
    required double elevation,
    required DateTime dateTime,
    required int timeZone,
  }) async {
    final uri = Uri.parse('$_baseUrl/positions').replace(
      queryParameters: <String, String>{
        'lat': latitude.toString(),
        'lon': longitude.toString(),
        'elev': elevation.toString(),
        'datetime': dateTime.toIso8601String(),
        'zone': timeZone.toString(),
      },
    );

    final response = await _client.get(uri, headers: _headers);

    if (response.statusCode != 200) {
      throw Exception(
        'Errore nel recupero delle posizioni: ${response.statusCode}',
      );
    }

    final List<dynamic> json = jsonDecode(response.body) as List<dynamic>;
    return json
        .map((dynamic e) => PositionDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

class BodyDto {
  BodyDto({
    required this.id,
    required this.englishName,
    required this.isPlanet,
    this.bodyType,
    this.semimajorAxis,
    this.perihelion,
    this.aphelion,
    this.eccentricity,
    this.inclination,
    this.massValue,
    this.massExponent,
    this.volValue,
    this.volExponent,
    this.density,
    this.gravity,
    this.escape,
    this.meanRadius,
    this.equaRadius,
    this.polarRadius,
    this.flattening,
    this.dimension,
    this.sideralOrbit,
    this.sideralRotation,
    this.discoveredBy,
    this.discoveryDate,
    this.axialTilt,
    this.avgTemp,
  });

  factory BodyDto.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? mass =
        json['mass'] as Map<String, dynamic>?;
    final Map<String, dynamic>? vol =
        json['vol'] as Map<String, dynamic>?;

    return BodyDto(
      id: json['id'] as String? ?? '',
      englishName: json['englishName'] as String? ?? '',
      isPlanet: json['isPlanet'] as bool? ?? false,
      bodyType: json['bodyType'] as String?,
      semimajorAxis: (json['semimajorAxis'] as num?)?.toDouble(),
      perihelion: (json['perihelion'] as num?)?.toDouble(),
      aphelion: (json['aphelion'] as num?)?.toDouble(),
      eccentricity: (json['eccentricity'] as num?)?.toDouble(),
      inclination: (json['inclination'] as num?)?.toDouble(),
      massValue: (mass?['massValue'] as num?)?.toDouble(),
      massExponent: mass?['massExponent'] as int?,
      volValue: (vol?['volValue'] as num?)?.toDouble(),
      volExponent: vol?['volExponent'] as int?,
      density: (json['density'] as num?)?.toDouble(),
      gravity: (json['gravity'] as num?)?.toDouble(),
      escape: (json['escape'] as num?)?.toDouble(),
      meanRadius: (json['meanRadius'] as num?)?.toDouble(),
      equaRadius: (json['equaRadius'] as num?)?.toDouble(),
      polarRadius: (json['polarRadius'] as num?)?.toDouble(),
      flattening: (json['flattening'] as num?)?.toDouble(),
      dimension: json['dimension'] as String?,
      sideralOrbit: (json['sideralOrbit'] as num?)?.toDouble(),
      sideralRotation: (json['sideralRotation'] as num?)?.toDouble(),
      discoveredBy: json['discoveredBy'] as String?,
      discoveryDate: json['discoveryDate'] as String?,
      axialTilt: (json['axialTilt'] as num?)?.toDouble(),
      avgTemp: json['avgTemp'] as int?,
    );
  }

  final String id;
  final String englishName;
  final bool isPlanet;
  final String? bodyType;
  final double? semimajorAxis;
  final double? perihelion;
  final double? aphelion;
  final double? eccentricity;
  final double? inclination;
  final double? massValue;
  final int? massExponent;
  final double? volValue;
  final int? volExponent;
  final double? density;
  final double? gravity;
  final double? escape;
  final double? meanRadius;
  final double? equaRadius;
  final double? polarRadius;
  final double? flattening;
  final String? dimension;
  final double? sideralOrbit;
  final double? sideralRotation;
  final String? discoveredBy;
  final String? discoveryDate;
  final double? axialTilt;
  final int? avgTemp;
}

class PositionDto {
  PositionDto({
    required this.name,
    required this.ra,
    required this.dec,
    required this.az,
    required this.alt,
  });

  factory PositionDto.fromJson(Map<String, dynamic> json) {
    return PositionDto(
      name: json['name'] as String? ?? '',
      ra: json['ra'] as String? ?? '',
      dec: json['dec'] as String? ?? '',
      az: json['az'] as String? ?? '',
      alt: json['alt'] as String? ?? '',
    );
  }

  final String name;
  final String ra;
  final String dec;
  final String az;
  final String alt;
}

