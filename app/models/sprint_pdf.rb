class SprintPdf < Prawn::Document
  include Prawn::View
  
  def initialize(resource)
      @sprint = resource
      @total_dishes_count = Hash.new
      super(top_margin: 50)
      text "Summary for #{@sprint.title}" , :style => :bold, :size => 20, :align => :center
  end

  def overall_pdf
                              # Nice, somehow fast, but not pretty
    connection = ActiveRecord::Base.connection
    _rations = connection.execute('SELECT "dishes"."title","dish_options"."title" as "optional_title", "daily_menus"."day_number",SUM("daily_rations"."price") as "price_sum", SUM("daily_rations"."quantity") as "quantity_sum" FROM "daily_rations"  INNER JOIN "dishes" ON "daily_rations"."dish_id"="dishes"."id" LEFT JOIN "dish_options" ON "daily_rations"."dish_option_id"="dish_options"."id" INNER JOIN "daily_menus" ON "daily_rations"."daily_menu_id"="daily_menus"."id" WHERE "daily_rations"."sprint_id" = '"#{@sprint.id}"' GROUP BY "dishes"."title", "daily_menus"."day_number","dish_options"."title" ORDER BY  "daily_menus"."day_number"ASC') 
    span(250, :position => :center) do
      text "Started on: #{@sprint.started_at}" , :size => 10
      text "Ended: #{@sprint.finished_at}" , :size => 10
    end
    days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
    grouped_rations = _rations.group_by{|x| x['day_number']}
    grouped_rations.each do |k,v|
      text days[k.to_i-1], :style => :bold, :size => 14, :align => :center
      v.each do |dish|
        if dish['optional_title']
          text "#{dish['title']} #{dish['optional_title']} x#{dish['quantity_sum']} #{dish['price_sum']} UAH"
        else
          text "#{dish['title']} x#{dish['quantity_sum']} #{dish['price_sum']} UAH"
        end
      end
    end
  end

  def detailed_pdf
    days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
    queue = 'SELECT SUM("daily_rations"."price") as "price_sum", SUM("daily_rations"."quantity") as "quantity_sum" ,"dish_options"."title" as "optional_title", "dishes"."title", "users"."name",  "daily_menus"."day_number" FROM "daily_rations" INNER JOIN "users" ON "users"."id" = "daily_rations"."user_id" INNER JOIN "dishes" ON "dishes"."id" = "daily_rations"."dish_id" LEFT JOIN "dish_options" ON "daily_rations"."dish_option_id"="dish_options"."id" INNER JOIN "daily_menus" ON "daily_rations"."daily_menu_id"="daily_menus"."id" WHERE "daily_rations"."sprint_id" = '"#{@sprint.id}"' GROUP BY"dishes"."title", "daily_menus"."day_number", "users"."name","dish_options"."title" ORDER BY  "daily_menus"."day_number"ASC'
    _rations = ActiveRecord::Base.connection.execute(queue)
    grouped_rations = _rations.group_by{|x| x['day_number']}
    grouped_rations.each do |k,v|
      text days[k.to_i-1], :style => :bold, :size => 14, :align => :center
      grouped_users = v.group_by{|x| x['name']}
      grouped_users.each do |k,v|
        text k, :style => :bold
        v.each do |dish|
          if dish['optional_title']
            text "#{dish['title']} #{dish['optional_title']} x#{dish['quantity_sum']} #{dish['price_sum']} UAH"
          else
            text "#{dish['title']} x#{dish['quantity_sum']} #{dish['price_sum']} UAH"
          end
        end
      end
    end
  end
end
