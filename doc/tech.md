## Technologie

[Redis](http://redis.io/) - key-value data structure store, używany do trzymania aktualnego stanu poszególnych rozgrywek.

[PosgreSQL](http://www.postgresql.org/) - popularna baza danych, przechowywane są tam pytania oraz dane użytkowników

[Phoenix](http://www.phoenixframework.org/) - framework webowy ułatwiający komunikacje z bazą danych, dynamiczne oprogramowanie serwera oraz komunikacji korzystając z websocketów

[WordsAPI](https://www.wordsapi.com/) - web API zwracające między innymi synonimy słów

Przebieg rozgrywki z technicznego punktu widzenia:
 * Użytkownik po zalgowaniu otrzymuje na stonie terminal który służy do wyświetlania stanu gry z perspektywy aktualnego gracza.
 * Użytkownik w interakcji z terminalem generuje jakieś akcje które są wysyłane na serwer.
 * Następuje tam odczytanie stanu gry na podstawie ID polaczenia. 
 * Modyfikacja stanu gry, zapis w Redisie, oraz zwrócenie nowego do użytkownika do wszystkich graczy w danych pokoju.
 
Bardziej szczegółowo wygląda to tak:

  1. Użytkownik po zalogowaniu się otrzymuje "ciasteczko", które jest zapisywane w jego przeglądarce internetowej, które go jednoznacznie identyfikuje w dalszej komunikacji w serwerem przez bezstanowy protokół HTTP.
  2. Po wejściu/przekierowaniu na stronę gry jest on już rozpoznany i wysłany zostaje mu terminal.
  3. Terminal łączy się z serwerem przez Websocket i od teraz jest zestawione połączenie dla  komunikacji dwustronnej. 
  4. Terminal może teraz wysyłać różne akcje(ich identyfikatory) na serwer. W odpowiedzi oczekuje stanu gry po wykonaniu tej akcji.
  5. Serwer przekierowywuje akcje do danego pokoju, jest to obsługiwane przez https://github.com/Familiadex/Familiadex/blob/master/web/channels/game_channel.ex
A konkretniej metode `Familiada.GameState.update` autoryzuje ona akcje i jeśli jest prawidłowa to pobiera stan gry, routuje akcje do odpowiedniej metody w module https://github.com/Familiadex/Familiadex/blob/master/web/logic/reactions.ex która modyfikuje stan gry.

Taka technologia i architektura pozwala na skalowanie zasobów(serwerów oraz baz danych) liniowo z zależności od ilości użytkowników oraz
zabezpieczenie gry przed oszustwami.

Utworzony został minimalny działający produkt, który pozwolił nam przetestować 2 nowe języki programowania oraz web framework.
W retrospektywie [Phoenix](http://www.phoenixframework.org/) napisany w [Elixirze](http://elixir-lang.org/) jest był dobrym wyborem. Posiada on dość eleganckie abstracje do routowania i obsługi komunikacji po websocketach, która była kluczowa dla projektu będącego niejako grą czasu rzeczywistego.

Jednak [Elm](http://elm-lang.org/), język wykorzystany do napisania czatu oraz terminala, okazał się średim rozwiązaniem jeśli chodzi o prototypowanie.
Nikt w naszym zespole nie miał większego doświadczenia z statycznie typowanymi językami funkcjonalnymi, więc pomimo typowych zalet języka kompilowanego oraz silego typowania brak doświadczenia w silnie typowanych językach oraz reaktywnym stylu programowania znacznie spowolnił tworzenie prototypu.
Poprawność kodu dla aplikacji klienciej łatwo debugowalej wizualnie nie byłą warta nauki tego języka( w kontekście ukończenia projektu ).


