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

    public class PossibleMovement: Vame.Sprite {

        public signal void selected();

        public int pos_x;
        public int pos_y;

        public PossibleMovement(int x, int y, Chess.Board board) {
            base(new Vame.Image(Utils.get_image_path("possible.png")));

            this.pos_x = x;
            this.pos_y = y;

            int real_x;
            int real_y;

            Utils.get_real_position(board, x, y, this.image, out real_x, out real_y);

            this.set_pos(real_x, real_y);

            this.click.connect(() => {
                this.selected();
            });
        }
    }

    public class Piece: Vame.Sprite {

        public Utils.PieceType type;
        public Utils.TeamType color;

        public int pos_x;
        public int pos_y;

        public Piece(Utils.PieceType type, Utils.TeamType team) {
            string color = (team == Utils.TeamType.WHITE)? "white_": "black_";
            string name;

            switch (type) {
                case Utils.PieceType.ROOK:
                    name = "rook.png";
                    break;

                case Utils.PieceType.KNIGHT:
                    name = "knight.png";
                    break;

                case Utils.PieceType.BISHOP:
                    name = "bishop.png";
                    break;

                case Utils.PieceType.KING:
                    name = "king.png";
                    break;

                case Utils.PieceType.QUEEN:
                    name = "queen.png";
                    break;

                case Utils.PieceType.PAWN:
                    name = "pawn.png";
                    break;

                default:  // this should never happen
                    name = "pawn.png";
                    break;
            }

            string path = Utils.get_image_path(color + name);
            base(new Vame.Image(path));

            this.type = type;
            this.color = team;
        }

        public void set_position(int x, int y) {
            this.pos_x = x;
            this.pos_y = y;

            int real_x;
            int real_y;

            Vame.GameArea area = this.get_area();
            Utils.get_real_position(area, this.pos_x, this.pos_y, this.image, out real_x, out real_y);

            this.set_pos(real_x, real_y);
        }

        public string get_possible_movements() {
            string movements = "";

            switch (this.type) {
                case Utils.PieceType.ROOK:
                    movements = this.get_rook_movements();
                    break;

                case Utils.PieceType.KNIGHT:
                    movements = this.get_knight_movements();
                    break;

                case Utils.PieceType.BISHOP:
                    movements = this.get_bishop_movements();
                    break;

                case Utils.PieceType.KING:
                    movements = this.get_king_movements();
                    break;

                case Utils.PieceType.QUEEN:
                    movements = this.get_rook_movements() + this.get_bishop_movements();
                    break;

                case Utils.PieceType.PAWN:
                    movements = this.get_pawn_movements();
                    break;
            }

            return movements;
        }

        private string get_rook_movements() {
            string movements = "";
            for (int i=1; i < 8; i++) {
                if (this.pos_x + i <= 8) {
                    movements += " %d:%d ".printf(this.pos_x + i, this.pos_y);
                }

                if (this.pos_x - i >= 1) {
                    movements += " %d:%d ".printf(this.pos_x - i, this.pos_y);
                }

                if (this.pos_y + i <= 8) {
                    movements += " %d:%d ".printf(this.pos_x, this.pos_y + i);
                }

                if (this.pos_y - i >= 1) {
                    movements += " %d:%d ".printf(this.pos_x, this.pos_y - i);
                }
            }

            return movements;
        }

        private string get_knight_movements() {
            string movements = "";
            if (this.pos_x - 2 > 1) {
                if (this.pos_y - 1 >= 1) {
                    movements += " %d:%d ".printf(this.pos_x - 2, this.pos_y - 1);
                }

                if (this.pos_y + 1 <= 8) {
                    movements += " %d:%d ".printf(this.pos_x - 2, this.pos_y + 1);
                }
            }

            if (this.pos_x + 2 <= 8) {
                if (this.pos_y - 1 >= 1) {
                    movements += " %d:%d ".printf(this.pos_x + 2, this.pos_y - 1);
                }

                if (this.pos_y + 1 <= 8) {
                    movements += " %d:%d ".printf(this.pos_x + 2, this.pos_y + 1);
                }
            }

            if (this.pos_y - 2 >= 1) {
                if (this.pos_x - 1 >= 1) {
                    movements += " %d:%d ".printf(this.pos_x - 1, this.pos_y - 2);
                }

                if (this.pos_x + 1 <= 8) {
                    movements += " %d:%d ".printf(this.pos_x + 1, this.pos_y - 2);
                }
            }

            if (this.pos_y + 2 <= 8) {
                if (this.pos_x - 1 >= 1) {
                    movements += " %d:%d ".printf(this.pos_x - 1, this.pos_y + 2);
                }

                if (this.pos_x + 1 <= 8) {
                    movements += " %d:%d ".printf(this.pos_x + 1, this.pos_y + 2);
                }
            }

            return movements;
        }

        private string get_bishop_movements() {
            string movements = "";
            for (int i=1; i <= 8; i++) {
                if (this.pos_x + i <= 8 && this.pos_y + i <= 8) {
                    movements += " %d:%d ".printf(this.pos_x + i, this.pos_y + i);
                }

                if (this.pos_x - i >= 1 && this.pos_y + i <= 8) {
                    movements += " %d:%d ".printf(this.pos_x - i, this.pos_y + i);
                }

                if (this.pos_x + i <= 8 && this.pos_y - i >= 1) {
                    movements += " %d:%d ".printf(this.pos_x + i, this.pos_y - i);
                }

                if (this.pos_x - i >= 1 && this.pos_y - i >= 1) {
                    movements += " %d:%d ".printf(this.pos_x - i, this.pos_y - i);
                }
            }

            return movements;
        }

        private string get_king_movements() {
            string movements = "";
            if (this.pos_x - 1 >= 1) {
                if (this.pos_y - 1 >= 1) {
                    movements += " %d:%d ".printf(this.pos_x - 1, this.pos_y - 1);
                }

                movements += " %d:%d ".printf(this.pos_x - 1, this.pos_y);

                if (this.pos_y + 1 <= 8) {
                    movements += " %d:%d ".printf(this.pos_x - 1, this.pos_y + 1);
                }
            }

            if (this.pos_y - 1 >= 1) {
                movements += " %d:%d ".printf(this.pos_x, this.pos_y - 1);
            }

            if (this.pos_y + 1 <= 8) {
                movements += " %d:%d ".printf(this.pos_x, this.pos_y + 1);
            }

            if (this.pos_x + 1 <= 8) {
                if (this.pos_y - 1 >= 1) {
                    movements += " %d:%d ".printf(this.pos_x + 1, this.pos_y - 1);
                }

                movements += " %d:%d ".printf(this.pos_x + 1, this.pos_y);

                if (this.pos_y + 1 <= 8) {
                    movements += " %d:%d ".printf(this.pos_x + 1, this.pos_y + 1);
                }
            }

            return movements;
        }

        private string get_pawn_movements() {
            int y_white_pawn = 7;
            int y_black_pawn = 2;

            string movements = "";
            if (this.color == Utils.TeamType.WHITE && this.pos_y == y_white_pawn) {
                movements += " %d:%d ".printf(this.pos_x, y_white_pawn - 1);
                movements += " %d:%d ".printf(this.pos_x, y_white_pawn - 2);
            } else if (this.color == Utils.TeamType.BLACK && this.pos_y == y_black_pawn) {
                movements += " %d:%d ".printf(this.pos_x, y_black_pawn + 1);
                movements += " %d:%d ".printf(this.pos_x, y_black_pawn + 2);
            } else if (this.color == Utils.TeamType.WHITE && this.pos_y != y_white_pawn) {
                movements += " %d:%d ".printf(this.pos_x, this.pos_y - 1);
            } else if (this.color == Utils.TeamType.BLACK && this.pos_y != y_black_pawn) {
                movements += " %d:%d ".printf(this.pos_x, this.pos_y + 1);
            }

            return movements;
        }
    }
}
