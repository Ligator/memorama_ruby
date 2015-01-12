require 'rubygems'  
require 'gosu'  
  
class GameWindow < Gosu::Window  
  
  def initialize  
  	@window_width = 650  
    @window_height = 650  
    @gosu_window = self  
    super(@window_width, @window_height, false)  
    self.caption = "Ever After High - Memorama KAROL" 

    @background_image = Gosu::Image.new(@gosu_window, "images/starry_night.png", true)
    @background_1 = Gosu::Image.new(@gosu_window, "images/background_1.png", true)
    @background_2 = Gosu::Image.new(@gosu_window, "images/background_2.png", true)
    @background_3 = Gosu::Image.new(@gosu_window, "images/background_3.jpg", true)
    @win_image = Gosu::Image.new(@gosu_window, "images/win.png", true)
    
    @cursor = Gosu::Image.new(@gosu_window, "images/cursor.png", true)
    @back_hover = Gosu::Image.new(@gosu_window, "images/card_back_2.png", true)
    @back_wait = Gosu::Image.new(@gosu_window, "images/card_back_4.png", true)
    @card1_image = Gosu::Image.new(@gosu_window, "images/cerise-hood.png", true)
    @card2_image = Gosu::Image.new(@gosu_window, "images/apple-white.png", true)
    @card3_image = Gosu::Image.new(@gosu_window, "images/briar-beauty.png", true)
    @card4_image = Gosu::Image.new(@gosu_window, "images/ashlynn-ella.png", true)
    @card5_image = Gosu::Image.new(@gosu_window, "images/raven-queen.png", true)
    @card6_image = Gosu::Image.new(@gosu_window, "images/madeline-hatter.png", true)

    @factor = 0.3

    @card = [ @card1_image, @card1_image, 
              @card2_image, @card2_image, 
              @card3_image, @card3_image,
              @card4_image, @card4_image,
              @card5_image, @card5_image,
              @card6_image, @card6_image]

    @background = [@background_1, @background_2, @background_3, @background_image]
    @background_index = 0

    randomize
  end   

  def randomize
    @card.shuffle!
    @volteadas = Array.new(@card.length, false)

    @img_w = @card1_image.width * @factor
    @img_h = @card1_image.height * @factor
    margen_x = margen_y = 50
    space = 10
    @img_x = [margen_x, margen_x+@img_w+space, margen_x+2*@img_w+2*space, margen_x+3*@img_w+3*space,
              margen_x, margen_x+@img_w+space, margen_x+2*@img_w+2*space, margen_x+3*@img_w+3*space,
              margen_x, margen_x+@img_w+space, margen_x+2*@img_w+2*space, margen_x+3*@img_w+3*space]
    @img_y = [margen_y, margen_y, margen_y, margen_y, 
              margen_y+@img_h+space, margen_y+@img_h+space, margen_y+@img_h+space, margen_y+@img_h+space,
              margen_y+2*@img_h+2*space, margen_y+2*@img_h+2*space, margen_y+2*@img_h+2*space, margen_y+2*@img_h+2*space]
    @cont = 0
    @cont2 = 0
    @temp1 = @temp2 = nil
    @win = false

    @background_index = @background_index +1
    @background_index = 0 if @background_index >= @background.count
end
  
  def update  
    if @temp1 and @temp2
      if @card[@temp1] == @card[@temp2]
        @temp1 = @temp2 = nil
      else
        @cont = @cont.next
        if @cont == 30
          @volteadas[@temp1] = @volteadas[@temp2] = false
          @cont = 0
          @temp1 = @temp2 = nil
        end
      end
    end
    if @volteadas.all? {|e| e.equal?true}
        @cont2 = @cont2.next
        if @cont2 == 30
          @cont = 0
          @temp1 = @temp2 = nil
          @win = true
        end
    end
  end  

  def button_down(id) 
    if id == Gosu::MsLeft
      @volteadas.each_with_index do |rev, i|
        if rev==false and is_mouse_hovering(@img_x[i], @img_y[i])
          p "(#{@gosu_window.mouse_x}, #{@gosu_window.mouse_y}) Card: #{i}"
          unless @temp1 and @temp2
            if @temp1
              @temp2 = i
            else
              @temp1 = i
            end
            @volteadas[i] = true
          end
        end
      end
      p @volteadas
    elsif id==char_to_button_id('r')
      randomize
    end      
  end

  def is_mouse_hovering(x,y)
    mx = @gosu_window.mouse_x
    my = @gosu_window.mouse_y
    (mx >= x and my >= y) and (mx <= x + @img_w) and (my <= y + @img_h)
  end
  
  def draw  
  	@background[@background_index].draw(0,0,0) 
  	@volteadas.each_with_index do |rev, i|
      if rev
        @card[i].draw(@img_x[i], @img_y[i], 0, @factor, @factor) 
      elsif is_mouse_hovering(@img_x[i], @img_y[i])
        @back_hover.draw(@img_x[i], @img_y[i], 0, @factor, @factor) 
      else
        @back_wait.draw(@img_x[i], @img_y[i], 0, @factor, @factor) 
      end
    end
    @cursor.draw(@gosu_window.mouse_x, @gosu_window.mouse_y, 1)
    @win_image.draw(70,350,1) if @win
  end  
  
end  
  
window = GameWindow.new  
window.show 

# asdf
