/*
Copyright (C) 2015, Cristian García <cristian99garcia@gmail.com>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
*/

namespace Chess {

    public class Brain: GLib.Object {

        public GLib.List<Chess.Piece> white_pieces;
        public GLib.List<Chess.Piece> black_pieces;
        public GLib.List<Chess.PossibleMovement> possible_movements;
        public Chess.Board board;

        public Chess.Piece? current_piece = null;
        public Utils.TeamType current_turn;

        public Brain(Chess.Board board) {
            this.board = board;
        }

        public void make_teams() {
            this.white_pieces = new GLib.List<Chess.Piece>();
            this.black_pieces = new GLib.List<Chess.Piece>();
            this.possible_movements = new GLib.List<Chess.PossibleMovement>();
            this.current_turn = Utils.TeamType.WHITE;

            for (int i=1; i <= 8; i++) {  // 8 pawns for the 2 teams
                this.make_piece(Utils.PieceType.PAWN, Utils.TeamType.WHITE, i, 7);
                this.make_piece(Utils.PieceType.PAWN, Utils.TeamType.BLACK, i, 2);
            }

            // 2 rooks for the 2 teams
            this.make_piece(Utils.PieceType.ROOK, Utils.TeamType.WHITE, 1, 8);
            this.make_piece(Utils.PieceType.ROOK, Utils.TeamType.WHITE, 8, 8);
            this.make_piece(Utils.PieceType.ROOK, Utils.TeamType.BLACK, 1, 1);
            this.make_piece(Utils.PieceType.ROOK, Utils.TeamType.BLACK, 8, 1);

            // 2 knights for the 2 teams
            this.make_piece(Utils.PieceType.KNIGHT, Utils.TeamType.WHITE, 2, 8);
            this.make_piece(Utils.PieceType.KNIGHT, Utils.TeamType.WHITE, 7, 8);
            this.make_piece(Utils.PieceType.KNIGHT, Utils.TeamType.BLACK, 2, 1);
            this.make_piece(Utils.PieceType.KNIGHT, Utils.TeamType.BLACK, 7, 1);

            // 2 bishop for the 2 teams
            this.make_piece(Utils.PieceType.BISHOP, Utils.TeamType.WHITE, 3, 8);
            this.make_piece(Utils.PieceType.BISHOP, Utils.TeamType.WHITE, 6, 8);
            this.make_piece(Utils.PieceType.BISHOP, Utils.TeamType.BLACK, 3, 1);
            this.make_piece(Utils.PieceType.BISHOP, Utils.TeamType.BLACK, 6, 1);

            // 1 king for the 2 teams
            this.make_piece(Utils.PieceType.KING, Utils.TeamType.WHITE, 4, 8);
            this.make_piece(Utils.PieceType.KING, Utils.TeamType.BLACK, 4, 1);

            // 1 queen for the 2 teams
            this.make_piece(Utils.PieceType.QUEEN, Utils.TeamType.WHITE, 5, 8);
            this.make_piece(Utils.PieceType.QUEEN, Utils.TeamType.BLACK, 5, 1);
        }

        public void make_piece(Utils.PieceType type, Utils.TeamType color, int x, int y) {
            Chess.Piece piece = new Chess.Piece(type, color);
            this.board.add_sprite((piece as Vame.Sprite));
            piece.set_position(x, y);
            piece.click.connect(this.show_movements);

            if (color == Utils.TeamType.WHITE) {
                this.white_pieces.append(piece);
            } else if (color == Utils.TeamType.BLACK) {
                this.black_pieces.append(piece);
            }
        }

        public void show_movements(Vame.Sprite sprite) {
            Chess.Piece piece = (sprite as Chess.Piece);

            if (piece.color != this.current_turn) {
                return;
            }

            this.current_piece = piece;
            string movements = piece.get_possible_movements();

            this.remove_all_possible_movements();

            foreach (string movement in movements.split(" ")) {
                if (movement == " " || movement == "") {
                    continue;
                }

                int x = int.parse(movement.split(":")[0]);
                int y = int.parse(movement.split(":")[1]);

                this.make_possible_movement(x, y);
            }
        }

        public void make_possible_movement(int x, int y) {
            Chess.PossibleMovement sprite = new Chess.PossibleMovement(x, y, this.board);

            sprite.selected.connect(this.movement_selected);
            this.possible_movements.append(sprite);
            this.board.add_sprite(sprite);
        }

        public void remove_all_possible_movements() {
            foreach (Chess.PossibleMovement sprite in this.possible_movements) {
                this.board.remove_sprite(sprite);
            }

            this.possible_movements = new GLib.List<Chess.PossibleMovement>();
        }

        public void movement_selected(Vame.Sprite sprite) {
            Chess.PossibleMovement movement = (sprite as Chess.PossibleMovement);
            if (this.current_piece != null) {
                this.current_piece.set_position(movement.pos_x, movement.pos_y);
                this.current_turn = (this.current_turn == Utils.TeamType.WHITE)? Utils.TeamType.BLACK: Utils.TeamType.WHITE;
            }

            this.remove_all_possible_movements();
        }
    }
}
