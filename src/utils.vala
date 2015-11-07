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

namespace Utils {

    public enum PieceType {
        ROOK,
        KNIGHT,
        BISHOP,
        KING,
        QUEEN,
        PAWN,
    }

    public enum TeamType {
        WHITE,
        BLACK,
    }

    public double[] get_light_color() {
        double[] color = { 0.9411764705882353, 0.9411764705882353, 0.7098039215686275 };
        return color;
    }

    public double[] get_dark_color() {
        double[] color = { 0.7098039215686275, 0.5333333333333333, 0.38823529411764707 };
        return color;
    }

    public string get_image_path(string name) {
        string path = GLib.Path.build_filename(LocalPath.get_instance().get_local_folder(), @"src/icons/$name");
        return path;
    }

    public void get_real_position(Vame.GameArea area, int cx, int cy, Vame.Image image, out int x, out int y) {
        Gtk.Allocation allocaction;
        area.get_allocation(out allocaction);

        int width = allocaction.width;
        int height = allocaction.height;

        int box_width = width / 8;
        int box_height = height / 8;

        x = (cx - 1) * box_width + (box_width - image.width) / 2;
        y = (cy - 1) * box_height + (box_height - image.width) / 2;

    }

    public class LocalPath: GLib.Object {  // Singleton class

        private static LocalPath Instance = null;

        public string LOCAL_PATH = "";

        private static void create_instance() {
            if (Instance == null) {
                Instance = new LocalPath();
            }
        }

        public static LocalPath get_instance() {
            if (Instance == null) {
                create_instance();
            }

            return Instance;
        }

        public void set_local_folder(string path) {
            this.LOCAL_PATH = path;
        }

        public string get_local_folder() {
            return this.LOCAL_PATH;
        }
    }
}
