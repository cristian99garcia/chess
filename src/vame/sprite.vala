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

    public class Sprite: GLib.Object {

        public signal void update();
        public signal void position_changed(int x, int y);
        public signal void click();
        public signal void mouse_in();
        public signal void mouse_out();
        public signal void cursor_changed(Gdk.CursorType cursor);

        private Vame.Image _image;
        private int _x;
        private int _y;
        private int _anchor_x;
        private int _anchor_y;
        private double _rotation;
        private double _scale = 1.0;
        private bool _flip;
        private Gdk.Rectangle rect;

        private Vame.GameArea? area = null;
        private ulong? handler_click = null;
        private ulong? handler_motion = null;

        public bool pointer_in = false;

        public Sprite(Vame.Image image) {
            this.image = image;
        }

        private void _update() {
            this.rect = Gdk.Rectangle();
            this.rect.x = this.x + (int)(this.x - (this.x * this.scale) / 2);
            this.rect.y = this.y + (int)(this.y - (this.y * this.scale) / 2);
            this.rect.width = (int)(this.image.width * this.scale);
            this.rect.height = (int)(this.image.height * this.scale);

            this._anchor_x = this.image.width / 2;
            this._anchor_y = this.image.height / 2;

            this.update();
        }

        public Vame.Image image {
            get { return this._image; }
            set {
                this._image = value;
                this._image.update.connect(() => { this.update(); });
                this._update();
            }
        }

        public int x {
            get { return this._x; }
            set { this._x = value; this._update(); }
        }

        public int y {
            get { return this._y; }
            set { this._y = value; this._update(); }
        }

        public int anchor_x {
            get { return this._anchor_x; }
            set { this._anchor_x = value; this._update(); }
        }

        public int anchor_y {
            get { return this._anchor_y; }
            set { this._anchor_y = value; this._update(); }
        }

        public double rotation {
            get { return this._rotation; }
            set { this._rotation = value; this._update(); }
        }

        public double scale {
            get { return this._scale; }
            set { this._scale = value; this._update(); }
        }

        public bool flip {
            get { return this._flip; }
            set { this._flip = value; this._update(); }
        }

        public void set_pos(int? x = null, int? y = null) {
            if (x != null) {
                this.x = x;
            }

            if (y != null) {
                this.y = y;
            }

            this.position_changed(this.x, this.y);
        }

        public void set_area(Vame.GameArea area) {
            if (this.area != null) {
                print("Can not add sprite in this area, it's in another area\n");
                return;
            }

            this.area = area;
            this.handler_click = this.area.click.connect(this.check_click);
            this.handler_motion = this.area.motion.connect(this.check_in);
        }

        public void remove_of_the_box() {
            if (this.area == null) {
                print("Can not remove sprite of the box, it isn't in any box\n");
                return;
            }

            this.area.disconnect(this.handler_click);
            this.area.disconnect(this.handler_motion);

            this.handler_click = null;
            this.handler_motion = null;
            this.area = null;
        }

        public Vame.GameArea? get_area() {
            return this.area;
        }

        private void check_click(Vame.GameArea area, Vame.ButtonType button, int x, int y) {
            if (this.pointer_in && button == Vame.ButtonType.LEFT) {
                this.click();
            }
        }

        private void check_in(Vame.GameArea area, int x, int y) {
            bool _in = x >= this.x && x <= this.x + this.image.width && y >= this.y && y <= this.y + this.image.height;

            if (_in && !this.pointer_in) {
                this.pointer_in = true;
                this.mouse_in();
            } else if (!_in && this.pointer_in) {
                this.pointer_in = false;
                this.mouse_out();
            }
        }
    }
}
