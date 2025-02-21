require 'gtk3'
Gtk.init

font_desc = Pango::FontDescription.new("Sans 20")

window = Gtk::Window.new("Cockulator")
window.set_default_size(200, 200)
window.signal_connect("destroy") { Gtk.main_quit}

text_view = Gtk::TextView.new
text_view.editable = false
text_view.cursor_visible = false
text_view.set_size_request(-1, 20)
text_view.margin = 15
text_view.override_font(font_desc)
@text_buffer = text_view.buffer
@text_buffer.text = ""

grid = Gtk::Grid.new
grid.column_homogeneous = true
grid.row_homogeneous = true
grid.column_spacing = 5  
grid.row_spacing = 5    
grid.margin = 10

def button_label(x)
    case x
    when 1
        return x.to_s
    when 2
        return x.to_s
    when 3
        return x.to_s
    when 4
        return "-"
    when 5
        return (x-1).to_s
    when 6
        return (x-1).to_s
    when 7
        return (x-1).to_s
    when 8
        return "+"
    when 9
        return (x-2).to_s
    when 10
        return (x-2).to_s
    when 11
        return (x-2).to_s
    when 12
        return "*"
    when 13
        return "clear"
    when 15
        return "/"
    when 16
        return "="
    else
        return "0"
    end
end

def string_splitter(a, b)
    a = a.split(/([\/\+\-\*])/)
    puts a
    calculation(a[0], a[1], a[2], @text_buffer)
end

def calculation(x, y, z, u)
    result2 ||= nil
    if y == "+"
        result = x + z
    elsif y == "-"
        x = x.split("")
        z = z.split("")
        common = x & z
        common.each do |o|
            x.delete(o)
        end
        result = x.join
    elsif y == "*"
        result2 = []
        x = x.to_s
        puts "#{x}"
        z.to_i.times do |i|
            i = x
            result2 << i
        end
        result2 = result2.join("")
    else #/
        result = "Bruh I'm tired leave me alone 🙏"
    end
    if result2 == nil
        result = result.to_s
        numba = @text_buffer.end_iter
        @text_buffer.insert(numba, "=#{result}")
    else
        numba = @text_buffer.end_iter
        @text_buffer.insert(numba, "=#{result2}")
    end
end

def wipe(a)
    @text_buffer.text = ""
end

(0..3).each do |row|
    (0..3).each do |col|
        button_number = row * 4 + col + 1
        button = Gtk::Button.new(:label => button_label(button_number))
        button.set_size_request(10,10)
        button.signal_connect("clicked") do
            if button_label(button_number) == "="
                string_splitter(@text_buffer.text, @text_buffer)
            elsif button_label(button_number) == "clear"
                wipe(@text_buffer)
            else
                numba = @text_buffer.end_iter
                @text_buffer.insert(numba, "#{button_label(button_number)}")
            end
        end
        grid.attach(button, col, row, 1, 1)
    end
end

vbox = Gtk::Box.new(:vertical, 5)
vbox.pack_start(text_view, expand: false, fill: true, padding: 0)
vbox.pack_start(grid, expand: true, fill: true, padding: 0)

window.add(vbox)
window.show_all

Gtk.main