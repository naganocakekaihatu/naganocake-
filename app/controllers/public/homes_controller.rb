module Public
  class HomesController < ApplicationController
    def top
      @items = Item.all
    end
  
    def about
    end
  end
end