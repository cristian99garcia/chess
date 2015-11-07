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

public class ChessWindow: Gtk.Window {

    public Chess.Board board;
    public Chess.Brain brain;

    public ChessWindow() {
        this.set_title("Chess");
        this.set_size_request(480, 480);
        this.set_resizable(false);

        this.board = new Chess.Board();
        this.add(this.board);

        this.brain = new Chess.Brain(this.board);

        this.destroy.connect(Gtk.main_quit);
        this.realize.connect(this.start_game);

        this.show_all();
    }

    public void start_game() {
        this.brain.make_teams();
    }
}

void main(string[] args) {
    Gtk.init(ref args);

    Utils.LocalPath path = Utils.LocalPath.get_instance();
    path.set_local_folder(GLib.File.new_for_commandline_arg(args[0]).get_parent().get_path());

    new ChessWindow();
    Gtk.main();
}
