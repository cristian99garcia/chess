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

namespace Vame {

    public class Image {

        public signal void update();

        public int width = 0;
        public int height = 0;
        public double scale = 1;
        public string path;
        public Cairo.ImageSurface surface;

        public Image(string path) {
            this.set_from_path(path, false);
        }

        public void set_from_path(string path, bool update = true) {
	        GLib.File file = GLib.File.new_for_path(path);

            if (file.query_exists()) {
                this.path = path;
                this.surface = new Cairo.ImageSurface.from_png(this.path);
                this.width = surface.get_width();
                this.height = surface.get_height();

                if (update) {
                    this.update();
                }
            }
        }
    }
}
