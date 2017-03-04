Build a Connect Four game on the command line where two human players can play against each other and the board is displayed inbetween turns. Make sure it is created using TDD practices.

Note: Game only functional when correct syntax used for user input.

Example input:

>load 'connect_four.rb'

=> true

> P1 = ConnectFour::Player.new({name: "VP", piece: "\u2654"})

=> #

> P2 = ConnectFour::Player.new({name: "X", piece: "\u265A"})

=> #

> players = [P1,P2]

=> [#,#]

> ConnectFour::Game.new(players).play
