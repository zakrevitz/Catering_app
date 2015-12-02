class APIHelper
  # Compose daily menu and prepare it to be sent on client
  def self.get_menus(user_id)
    sprint = Sprint.find_by aasm_state: 'started'
    ration = DailyRation.where("sprint_id = ? AND user_id = ?", sprint.id, user_id).take
    unless ration
      menus = DailyMenu.where("active = ?", true).order(:day_number).as_json(except: [:created_at, :updated_at])
      categories = Category.all
      favourite_user_food = User.find(user_id).favourite_dishes_id
      menus.each do |resp|
        category_json = categories.as_json(except: [:created_at, :updated_at])

        dishes = Dish.find(resp['dish_ids'])
        grouped_dishes = dishes.group_by { |d| d['category_id'] }

        # Create categories array node for each DailyMenu
        resp['categories'] = category_json
        resp['categories'].each do |category|
          category['dishes'] =
            grouped_dishes[category['id']]
            .as_json(only: [:id, :title, :description, :price, :children_ids, :type])
          if category['dishes']
            category['dishes'].each do |dish|
              if favourite_user_food
                if favourite_user_food.include? dish['id']
                  dish['favourited'] = true
                else
                  dish['favourited'] = false
                end
              else
                dish['favourited'] = false
              end
              
              if dish['type'] == 'BusinessLunch'
                _bussinessLunchDishes = Dish.find(dish['children_ids'])
                dish['child_dishes'] = _bussinessLunchDishes.as_json(only: [:title, :description])
              end
              if dish['type'] == 'DishWithOption'
                dish.delete('price')
                options = DishOption.where(:dish_with_option_id => dish['id'])
                dish['options'] = []
                options.each do |option|
                  dish['options'] << option.as_json(only:[:id,:title,:price])
                end
              end
              dish.delete('children_ids')
            end
          end
        end

        # Delete empty categories
        resp['categories'].reject! { |cat| !cat['dishes'] }
        # There are no sense to store dish_ids
        resp.delete('dish_ids')
      end
    end
  end

  # Import user submitted rations to DB
  # TODO: https://github.com/lassebunk/dish use this gem way of doing it
  def self.set_rations(request, user_id)
    rations = []
    _sprint = Sprint.find_by aasm_state: 'started'
    # TODO: refactor for less queries to DB
    request["request"].each do |ration|
      dish = Dish.find(ration["dish_id"])
      # Break user submitted Business Lunch into its elements
      if dish.type == "BusinessLunch"
        dish.children_ids.each do |dish_id|
          rations << compose_ration( ration, dish_id, _sprint.id, user_id)
        end
      end
      if dish.type == "Meal"
        rations << compose_ration( ration, ration["dish_id"], _sprint.id, user_id)
      end
      # In case if user ordered dish with optional ingridients
      if dish.type == "DishWithOption"
        rations << compose_ration_with_option( ration, ration["dish_id"], _sprint.id, user_id)
      end
    end
    DailyRation.import rations, :validate => true
  end

  # Check if rations for single day are overbudget
  def self.check_rations(request)
    # TODO: Check daily menu and dish present
    _daily_menus = DailyMenu.where(:active => true)
    _max_prices = Hash.new
    _daily_menus.each do |day|
      _max_prices["#{day.id}"] = day.max_total
    end
    request["request"].each do |ration|
      if ration["quantity"].to_i >= 1
        _max_prices[ration["day_id"]] -= Dish.find(ration["dish_id"]).price * ration["quantity"].to_i
      else
        _max_prices[ration["day_id"]] -= Dish.find(ration["dish_id"]).price
      end
      if _max_prices[ration["day_id"]] < 0
        return false
      end
    end
    return true
  end

  # Add/delete like dish to user table
  def self.like(dish_id, user_id)
    user = User.find(user_id)
    if user.favourite_dishes_id.include? dish_id
      user.favourite_dishes_id.delete(dish_id)
      user.save
    else
      user.favourite_dishes_id.push(dish_id)
      user.save
    end
  end

  # Compose ration from user submitted data
  private
    def self.compose_ration(ration, dish_id, sprint_id, user_id)
      _created_ration                = DailyRation.new
      _created_ration.dish_id        = dish_id
      _created_ration.price          = Dish.find(dish_id).price * ration["quantity"].to_f
      _created_ration.quantity       = ration["quantity"]
      _created_ration.daily_menu_id  = ration["day_id"]
      _created_ration.user_id        = user_id
      _created_ration.sprint_id      = sprint_id
      return _created_ration
    end
    # TODO: Refactor into "if ration["option_id"]" not in dual methods
    def self.compose_ration_with_option(ration, dish_id, sprint_id, user_id)
      _created_ration                 = DailyRation.new
      _created_ration.dish_id         = dish_id
      _created_ration.price           = DishOption.find(ration["option_id"]).price * ration["quantity"].to_f
      _created_ration.quantity        = ration["quantity"]
      _created_ration.daily_menu_id   = ration["day_id"]
      _created_ration.dish_option_id  = ration["option_id"]
      _created_ration.user_id         = user_id
      _created_ration.sprint_id       = sprint_id
      return _created_ration
    end

 # private :compose_ration

end