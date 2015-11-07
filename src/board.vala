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

    private enum CurrentBox {
        LIGHT,
        DARK,
    }

    public class Board: Vame.GameArea {

        public Board() {
            this.set_use_background_function();
            this.draw_background.connect(this.draw_background_cb);
        }

        public void draw_background_cb(Vame.GameArea self, Cairo.Context context) {
            CurrentBox current = CurrentBox.LIGHT;
            double[] color = Utils.get_light_color();

            Gtk.Allocation alloc;
            this.get_allocation(out alloc);

            int width = alloc.width;
            int height = alloc.height;
            int box_width = width / 8;
            int box_height = height / 8;
            int x = 0;
            int y = 0;

            bool change = true;

            for (int i = 1; i <= 64; i++) {
                if (x == 8) {
                    x = 0;
                    y++;

                    change = false;
                } else {
                    change = true;
                }

                if (change) {
                    switch (current) {
                        case CurrentBox.LIGHT:
                            current = CurrentBox.DARK;
                            color = Utils.get_light_color();
                            break;

                        case CurrentBox.DARK:
                            current = CurrentBox.LIGHT;
                            color = Utils.get_dark_color();
                            break;
                    }
                }

                context.set_source_rgb(color[0], color[1], color[2]);
                context.rectangle(x * box_width, y * box_height, (x + 1) * box_width, (y + 1) * box_height);
                context.fill();

                x++;
            }
        }
    }
}
