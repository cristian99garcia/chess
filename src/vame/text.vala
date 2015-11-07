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

    public class Text {

        public signal void update();

        private string _text;
        private string _font_face = "Curier";
        private int _font_size = 15;
        private double[] _color = { 0.0, 0.0, 0.0 };
        private int _x;
        private int _y;
        public int width;
        public int height;

        public Text(string text) {
            this.text = text;
        }

        public int x {
            get { return this._x; }
            set { this._x = value; this.update(); }
        }

        public int y {
            get { return this._y; }
            set { this._y = value; this.update(); }
        }

        public string text {
            get { return this._text; }
            set { this._text = value; this.update_data(); }
        }

        public string font_face {
            get { return this._font_face; }
            set { this._font_face = value; this.update_data(); }
        }

        public int font_size {
            get { return this._font_size; }
            set { this._font_size = value; this.update_data(); }
        }

        public double[] color {
            get { return this._color; }
            set {this._color = value; this.update(); }
        }

        public void set_pos(int? x = null, int? y = null) {
            if (x != null) {
                this._x = x;
            }

            if (y != null) {
                this._y = y;
            }

            this.update();
        }

        private void update_data() {
	        // Get size
	        Cairo.ImageSurface surface = new Cairo.ImageSurface(Cairo.Format.ARGB32, 500, 500);
	        Cairo.Context context = new Cairo.Context(surface);

        	context.select_font_face(this.font_face, Cairo.FontSlant.NORMAL, Cairo.FontWeight.BOLD);
        	context.set_font_size(this.font_size);

        	Cairo.TextExtents extents;
        	context.text_extents(this.text, out extents);

        	this.width = (int)extents.width;
        	this.height = (int)extents.height;

        	this.update();
        }
    }
}
