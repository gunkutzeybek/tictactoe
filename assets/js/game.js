import socket from './socket'
import {Presence} from 'phoenix'

let Game = {
    Lobby : {        
        init: function(){
            let channel = socket.channel('tictactoe:lobby', {});

            channel.on("presence_state", state => {
                if (state){
                    let hideNoAvailability = false;
                    
                    let divGame = document.getElementById("divGame");
                    this.removeAllChildNodes(divGame);

                    let game_ids = state["game_ids"];
                    for (var i = 0; i < game_ids.length; i++){        
                        console.log(game_ids[i]);     
                        let game_id = game_ids[i];                                                           
                        hideNoAvailability = true;

                        let gameDiv = document.createElement("div");
                        gameDiv.innerHTML = "Game " + game_id + " is waiting.";

                        let hdnGameId = document.createElement("input");
                        hdnGameId.type = "hidden";
                        hdnGameId.value = game_id;
                        hdnGameId.classList.add("js-game-id");

                        let btnJoin = document.createElement("button");
                        btnJoin.innerHTML = "Join";

                        gameDiv.appendChild(btnJoin);
                        gameDiv.appendChild(hdnGameId);
                        divGame.appendChild(gameDiv);

                        btnJoin.addEventListener('click', function(){
                            let parent = this.parentElement;
                            let id = parent.getElementsByClassName("js-game-id")[0].value;
                            location.href = "/tictactoe?game_id=" + id;
                        })
                        
                        let noAvailability = document.getElementById("divNoAvailableGame");
                        if (hideNoAvailability){                            
                            noAvailability.style.display = "none";

                            divGame.style.display = "block"; 
                        } else {
                            noAvailability.style.display = "block";

                            divGame.style.display = "none";
                        }                        
                    }
                }
            });            

            channel.join();

            let createGameButton = document.getElementById("btnCreateGame");
            createGameButton.addEventListener("click", function(){
                channel.push("init_game")
                    .receive("ok", (payload) => location.href = "/tictactoe?game_id=" + payload.game_id);
            });
        },
        removeAllChildNodes: function(parent) {
            while (parent.firstChild) {
                parent.removeChild(parent.firstChild);
            }
        } 
    },
    TicTacToe : {        
        ownPlayer: '',
        init: function(){
            let hdnGameId = document.getElementById("hdnGameId");            
            let channel = socket.channel('game:' + hdnGameId.value, {});
            let presence = new Presence(channel);

            let lobbyChannel = socket.channel('tictactoe:lobby', {});

            lobbyChannel.join();

            channel.join().receive('ok', ({game, player}) => {            
                    Game.TicTacToe.ownPlayer = player;
                    lobbyChannel.push("presence_update", {game_id: hdnGameId.value});
                    Game.TicTacToe.updateBoard(game, player);
                }
            );      
            channel.on('start_game', () => {
                Game.TicTacToe.isGameStarted = true;   
                let divGameStatus = document.getElementsByClassName("game_status")[0];
                if (Game.TicTacToe.turn == Game.TicTacToe.ownPlayer){
                    divGameStatus.textContent = "Your turn!";
                }
                else{
                    divGameStatus.textContent = "Waiting for opponent to play!";
                }

                var boxElements = document.getElementsByClassName("ttt_box");
                for (var i = 0; i < boxElements.length; i++){
                    boxElements[i].addEventListener('click', function(){
                        var position = this.id.substring(this.id.length - 1);
                        channel.push("make_move", { player: Game.TicTacToe.ownPlayer, position: parseInt(position - 1) })
                            .receive("error", (reason) => alert(reason));
                    });
                }
            });              
            channel.on('make_move', (game) => {
                Game.TicTacToe.updateBoard(game);
            });
        },         
        turn: 'X',              
        isGameActive: false,
        isGameStarted:false,
        updateBoard: function(game){            
            let divGameStatus = document.getElementsByClassName("game_status")[0];
        
            if (Game.TicTacToe.isGameStarted){
                Game.TicTacToe.turn = game.turn;
                if (game.turn == Game.TicTacToe.ownPlayer){
                    Game.TicTacToe.isGameActive = true;
                    divGameStatus.textContent = "Your turn!";
                }
                else{
                    divGameStatus.textContent = "Waiting for oppent to play!"
                }
                Game.TicTacToe.renderBoard(game.board);
                Game.TicTacToe.IsThereAWinner(game, divGameStatus);
            }
        },
        IsThereAWinner: function(game, divGameStatus){
            if (game.winner){
                Game.TicTacToe.isGameActive = false;
                divGameStatus.textContent = game.winner + " wins!";
            }
        },
        renderBoard: function(board) {
            for (var i = 0; i < board.length; i++){
                let box = document.getElementById("box" + (i + 1));
                let boardElement = board[i];
                if (boardElement === "X" && !box.classList.contains("x-background")){
                    if (box.classList.contains("o-background")){
                        box.classList.remove(["o-background"]);
                    }
                    box.classList.add("x-background");
                }
                else if (boardElement === "O" && !box.classList.contains("Y")){
                    if (box.classList.contains("x-background")){
                        box.classList.remove(["x-background"]);
                    }
                    box.classList.add("o-background");
                }
                else{
                    box.classList.remove(["x-background", "o-background"]);
                }
            }
        }
    }
};

export default Game