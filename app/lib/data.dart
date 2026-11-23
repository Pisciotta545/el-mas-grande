import 'package:supabase_flutter/supabase_flutter.dart';

import 'models.dart';

SupabaseClient get db => Supabase.instance.client;

const _team = 'id, name, short_name, is_river';
const _match = 'id, competition_id, stage, kickoff, time_confirmed, venue, home_goals, away_goals, status, '
    'home:teams!matches_home_team_id_fkey($_team), away:teams!matches_away_team_id_fkey($_team)';

List<T> _list<T>(List<Map<String, dynamic>> rows, T Function(Map<String, dynamic>) parse) => rows.map(parse).toList();

/// Consultas públicas: las mismas que arma la web.
abstract final class Repo {
  static Future<List<Competition>> competitions() async =>
      _list(await db.from('competitions').select().order('sort_order', ascending: true), Competition.fromJson);

  static Future<List<Match>> matches() async =>
      _list(await db.from('matches').select(_match).order('kickoff', ascending: true), Match.fromJson);

  static Future<List<StandingRow>> standings() async => _list(
        await db
            .from('standings')
            .select('competition_id, position, played, won, drawn, lost, goals_for, goals_against, points, '
                'team:teams($_team)')
            .order('position', ascending: true),
        StandingRow.fromJson,
      );

  static Future<List<Team>> teams() async =>
      _list(await db.from('teams').select().order('name', ascending: true), Team.fromJson);

  static Future<List<Interview>> interviews() async =>
      _list(await db.from('interviews').select().order('published_at', ascending: false), Interview.fromJson);

  static Future<List<Discount>> discounts() async =>
      _list(await db.from('discounts').select().order('valid_until', ascending: true), Discount.fromJson);

  static Future<List<Raffle>> raffles() async => _list(
        await db
            .from('raffles')
            .select('id, title, description, prize_count, closes_at, match:matches(stage)')
            .order('closes_at', ascending: false),
        Raffle.fromJson,
      );

  static Future<List<RankingRow>> ranking() async => _list(
        await db
            .from('prode_ranking')
            .select()
            .order('points', ascending: false)
            .order('exact_hits', ascending: false)
            .limit(20),
        RankingRow.fromJson,
      );

  // Lo de cada hincha: las reglas RLS de la base solo dejan ver y tocar lo propio.

  static Future<Map<int, Pick>> myPicks(String userId) async {
    final rows = await db.from('predictions').select('match_id, home_goals, away_goals').eq('user_id', userId);
    return {for (final r in rows) r['match_id'] as int: Pick(r['home_goals'] as int, r['away_goals'] as int)};
  }

  static Future<void> savePick(String userId, int matchId, Pick pick) => db.from('predictions').upsert({
        'user_id': userId,
        'match_id': matchId,
        'home_goals': pick.home,
        'away_goals': pick.away,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      });

  static Future<Map<int, String>> discountCodes() async {
    final rows = await db.from('discount_codes').select('discount_id, code');
    return {for (final r in rows) r['discount_id'] as int: r['code'] as String};
  }

  static Future<Set<int>> myRaffles(String userId) async {
    final rows = await db.from('raffle_entries').select('raffle_id').eq('user_id', userId);
    return {for (final r in rows) r['raffle_id'] as int};
  }

  static Future<void> joinRaffle(String userId, int raffleId) =>
      db.from('raffle_entries').insert({'raffle_id': raffleId, 'user_id': userId});

  static Future<void> leaveRaffle(String userId, int raffleId) =>
      db.from('raffle_entries').delete().eq('raffle_id', raffleId).eq('user_id', userId);

  static Future<bool> usernameAvailable(String username) async =>
      await db.rpc('username_available', params: {'p_username': username}) as bool;

  static Future<String?> username(String userId) async {
    final row = await db.from('profiles').select('username').eq('id', userId).maybeSingle();
    return row?['username'] as String?;
  }
}
