// Los mismos datos que usa la web (ver supabase/migrations).

class Competition {
  Competition.fromJson(Map<String, dynamic> j)
      : id = j['id'] as String,
        name = j['name'] as String,
        season = j['season'] as String,
        hasTable = j['has_table'] as bool,
        tableLabel = j['table_label'] as String?;

  final String id;
  final String name;
  final String season;
  final bool hasTable;
  final String? tableLabel;
}

class TeamRef {
  TeamRef.fromJson(Map<String, dynamic> j)
      : id = j['id'] as String,
        name = j['name'] as String,
        shortName = j['short_name'] as String,
        isRiver = j['is_river'] as bool;

  final String id;
  final String name;
  final String shortName;
  final bool isRiver;
}

class Team {
  Team.fromJson(Map<String, dynamic> j)
      : id = j['id'] as String,
        name = j['name'] as String,
        shortName = j['short_name'] as String,
        nickname = j['nickname'] as String?,
        city = j['city'] as String,
        country = j['country'] as String,
        founded = j['founded'] as int?,
        stadium = j['stadium'] as String?,
        isRiver = j['is_river'] as bool;

  final String id;
  final String name;
  final String shortName;
  final String? nickname;
  final String city;
  final String country;
  final int? founded;
  final String? stadium;
  final bool isRiver;
}

class Match {
  Match.fromJson(Map<String, dynamic> j)
      : id = j['id'] as int,
        competitionId = j['competition_id'] as String,
        stage = j['stage'] as String,
        kickoff = DateTime.parse(j['kickoff'] as String),
        timeConfirmed = j['time_confirmed'] as bool,
        venue = j['venue'] as String?,
        homeGoals = j['home_goals'] as int?,
        awayGoals = j['away_goals'] as int?,
        status = j['status'] as String,
        home = TeamRef.fromJson(j['home'] as Map<String, dynamic>),
        away = TeamRef.fromJson(j['away'] as Map<String, dynamic>);

  final int id;
  final String competitionId;
  final String stage;
  final DateTime kickoff;
  final bool timeConfirmed;
  final String? venue;
  final int? homeGoals;
  final int? awayGoals;
  final String status;
  final TeamRef home;
  final TeamRef away;

  bool get finished => status == 'finished';
  bool get scheduled => status == 'scheduled';
  TeamRef get rival => home.isRiver ? away : home;
}

class StandingRow {
  StandingRow.fromJson(Map<String, dynamic> j)
      : competitionId = j['competition_id'] as String,
        position = j['position'] as int,
        played = j['played'] as int,
        won = j['won'] as int,
        drawn = j['drawn'] as int,
        lost = j['lost'] as int,
        goalsFor = j['goals_for'] as int,
        goalsAgainst = j['goals_against'] as int,
        points = j['points'] as int,
        team = TeamRef.fromJson(j['team'] as Map<String, dynamic>);

  final String competitionId;
  final int position;
  final int played;
  final int won;
  final int drawn;
  final int lost;
  final int goalsFor;
  final int goalsAgainst;
  final int points;
  final TeamRef team;

  int get goalDiff => goalsFor - goalsAgainst;
}

class QA {
  QA.fromJson(Map<String, dynamic> j)
      : q = j['q'] as String,
        a = j['a'] as String;

  final String q;
  final String a;
}

class Interview {
  Interview.fromJson(Map<String, dynamic> j)
      : id = j['id'] as int,
        slug = j['slug'] as String,
        title = j['title'] as String,
        dek = j['dek'] as String,
        interviewee = j['interviewee'] as String,
        intervieweeRole = j['interviewee_role'] as String,
        author = j['author'] as String,
        publishedAt = DateTime.parse(j['published_at'] as String),
        featured = j['featured'] as bool,
        isSample = j['is_sample'] as bool,
        body = (j['body'] as List).map((e) => QA.fromJson(e as Map<String, dynamic>)).toList();

  final int id;
  final String slug;
  final String title;
  final String dek;
  final String interviewee;
  final String intervieweeRole;
  final String author;
  final DateTime publishedAt;
  final bool featured;
  final bool isSample;
  final List<QA> body;
}

class Discount {
  Discount.fromJson(Map<String, dynamic> j)
      : id = j['id'] as int,
        merchant = j['merchant'] as String,
        category = j['category'] as String,
        title = j['title'] as String,
        description = j['description'] as String,
        validUntil = DateTime.parse(j['valid_until'] as String);

  final int id;
  final String merchant;
  final String category;
  final String title;
  final String description;
  final DateTime validUntil;
}

class Raffle {
  Raffle.fromJson(Map<String, dynamic> j)
      : id = j['id'] as int,
        title = j['title'] as String,
        description = j['description'] as String,
        prizeCount = j['prize_count'] as int,
        closesAt = DateTime.parse(j['closes_at'] as String),
        stage = (j['match'] as Map<String, dynamic>?)?['stage'] as String?;

  final int id;
  final String title;
  final String description;
  final int prizeCount;
  final DateTime closesAt;
  final String? stage;

  bool get open => closesAt.isAfter(DateTime.now());
}

class RankingRow {
  RankingRow.fromJson(Map<String, dynamic> j)
      : userId = j['user_id'] as String,
        username = j['username'] as String,
        points = j['points'] as int,
        exactHits = j['exact_hits'] as int;

  final String userId;
  final String username;
  final int points;
  final int exactHits;
}

class Pick {
  const Pick(this.home, this.away);

  final int home;
  final int away;

  /// 3 por resultado exacto, 1 por acertar ganador o empate (igual que la base).
  int pointsFor(Match m) {
    if (m.homeGoals == null || m.awayGoals == null) return 0;
    if (home == m.homeGoals && away == m.awayGoals) return 3;
    return (home - away).sign == (m.homeGoals! - m.awayGoals!).sign ? 1 : 0;
  }
}
