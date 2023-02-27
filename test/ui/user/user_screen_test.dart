import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';

import 'package:lichess_mobile/src/common/api_client.dart';
import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/ui/user/user_screen.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import '../../test_utils.dart';
import '../../test_app.dart';

void main() {
  final mockClient = MockClient((request) {
    if (request.url.path == '/api/games/user/$testUserId') {
      return mockResponse(userGameResponse, 200);
    } else if (request.url.path == '/api/user/$testUserId') {
      return mockResponse(testUserResponse, 200);
    } else if (request.url.path == '/api/user/$testUserId/activity') {
      return mockResponse(testActivityResponse, 200);
    }
    return mockResponse('', 404);
  });

  group('UserScreen', () {
    testWidgets(
      'should see recent games',
      (WidgetTester tester) async {
        final app = await buildTestApp(
          tester,
          home: const UserScreen(user: testUser),
          overrides: [
            httpClientProvider.overrideWithValue(mockClient),
          ],
        );

        await tester.pumpWidget(app);

        // wait for user request
        await tester.pump(const Duration(milliseconds: 50));

        // full name at the top
        expect(
          find.widgetWithText(ListTile, 'John Doe'),
          findsOneWidget,
        );

        // wait for recent games
        await tester.pump(const Duration(milliseconds: 50));

        // opponent in recent games
        expect(
          find.widgetWithText(PlatformListTile, 'maia1 (1397)'),
          findsOneWidget,
        );
        expect(
          find.widgetWithText(PlatformListTile, 'maia1 (1399)'),
          findsOneWidget,
        );
        expect(
          find.widgetWithText(PlatformListTile, 'maia1 (1410)'),
          findsOneWidget,
        );
      },
      variant: kPlatformVariant,
    );
  });
}

const testUserName = 'FakeUserName';
const testUserId = UserId('fakeuserid');
const testUser = LightUser(id: testUserId, name: testUserName);
final userGameResponse = '''
{"id":"rfBxF2P5","rated":false,"variant":"standard","speed":"blitz","perf":"blitz","createdAt":1672074461465,"lastMoveAt":1672074683485,"status":"mate","players":{"white":{"user":{"name":"$testUserName","patron":true,"id":"$testUserId"},"rating":1178},"black":{"user":{"name":"maia1","title":"BOT","id":"maia1"},"rating":1397}},"winner":"white","clock":{"initial":300,"increment":3,"totalTime":420,"lastFen":"r7/pppk4/4p1B1/3pP3/6Pp/q1P1P1nP/P1QK1r2/R5R1 w - - 1 1"}}
{"id":"msAKIkqp","rated":false,"variant":"standard","speed":"blitz","perf":"blitz","createdAt":1671791341158,"lastMoveAt":1671791589063,"status":"resign","players":{"white":{"user":{"name":"maia1","title":"BOT","id":"maia1"},"rating":1399},"black":{"user":{"name":"$testUserName","patron":true,"id":"$testUserId"},"rating":1178}},"winner":"white","clock":{"initial":300,"increment":3,"totalTime":420,"lastFen":"r7/pppk4/4p1B1/3pP3/6Pp/q1P1P1nP/P1QK1r2/R5R1 w - - 1 1"}}
{"id":"7Jxi9mBF","rated":false,"variant":"standard","speed":"blitz","perf":"blitz","createdAt":1671100908073,"lastMoveAt":1671101322211,"status":"mate","players":{"white":{"user":{"name":"$testUserName","patron":true,"id":"$testUserId"},"rating":1178},"black":{"user":{"name":"maia1","title":"BOT","id":"maia1"},"rating":1410}},"winner":"white","clock":{"initial":300,"increment":3,"totalTime":420,"lastFen":"r7/pppk4/4p1B1/3pP3/6Pp/q1P1P1nP/P1QK1r2/R5R1 w - - 1 1"}}
''';

final testUserResponse = '''
{
  "id": "$testUserId",
  "username": "$testUserName",
  "createdAt": 1290415680000,
  "seenAt": 1290415680000,
  "title": "GM",
  "patron": true,
  "perfs": {
    "blitz": {
      "games": 2340,
      "rating": 1681,
      "rd": 30,
      "prog": 10
    },
    "rapid": {
      "games": 2340,
      "rating": 1677,
      "rd": 30,
      "prog": 10
    },
    "classical": {
      "games": 2340,
      "rating": 1618,
      "rd": 30,
      "prog": 10
    }
  },
  "profile": {
    "country": "France",
    "location": "Lille",
    "bio": "test bio",
    "firstName": "John",
    "lastName": "Doe",
    "fideRating": 1800,
    "links": "http://test.com"
  }
}
''';

const testActivityResponse = '''
[
  {
    "interval": {
      "start": 1677456000000,
      "end": 1677542400000
    },
    "games": {
      "rapid": {
        "win": 2,
        "loss": 0,
        "draw": 0,
        "rp": {
          "before": 3022,
          "after": 3028
        }
      }
    },
    "puzzles": {
      "score": {
        "win": 55,
        "loss": 4,
        "draw": 0,
        "rp": {
          "before": 1709,
          "after": 1709
        }
      }
    },
    "follows": {
      "in": {
        "ids": [
          "bananeaufklo",
          "akbar4566",
          "caosayz",
          "alexgoldberg",
          "dodo-chess",
          "chillywilly0",
          "whitstine",
          "thegamerr2011",
          "arjun2704",
          "joomla2003",
          "mancastro",
          "zhukovgleb",
          "brothermanbm",
          "txmperchess"
        ]
      }
    }
  },
  {
    "interval": {
      "start": 1677369600000,
      "end": 1677456000000
    },
    "games": {
      "classical": {
        "win": 0,
        "loss": 0,
        "draw": 1,
        "rp": {
          "before": 2078,
          "after": 2078
        }
      }
    },
    "follows": {
      "in": {
        "ids": [
          "gfe4567ujkmnbvfder",
          "armageddon_13",
          "akim2014",
          "jeff_thechef",
          "kamenev_8_andrei",
          "kianmehralipanahi",
          "akiftuna",
          "sava2012",
          "miroslavnik2015",
          "elwood13",
          "wjswww",
          "yagizcetin7",
          "aunee4321",
          "godkrishna07",
          "eugeny_bog"
        ],
        "nb": 18
      }
    }
  },
  {
    "interval": {
      "start": 1677283200000,
      "end": 1677369600000
    },
    "games": {
      "classical": {
        "win": 1,
        "loss": 0,
        "draw": 0,
        "rp": {
          "before": 2078,
          "after": 2078
        }
      }
    },
    "puzzles": {
      "score": {
        "win": 28,
        "loss": 3,
        "draw": 0,
        "rp": {
          "before": 1709,
          "after": 1709
        }
      }
    },
    "follows": {
      "in": {
        "ids": [
          "z-masterchief117-z",
          "ksar1x19",
          "patrickzhou",
          "nazarsav12",
          "goshabelyaev",
          "campanaro56",
          "hyp1",
          "alesaqueen",
          "green_tazer",
          "tkm_balkan2010",
          "yagizcetin7",
          "orikylee",
          "simokhin",
          "disguyaarav",
          "qnilaidung2011"
        ],
        "nb": 18
      }
    }
  }
]
''';
