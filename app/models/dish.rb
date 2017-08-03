# == Schema Information
#
# Table name: dishes
#
#  id                 :integer          not null, primary key
#  description        :string
#  dish_name          :string
#  dish_name_not_mark :string
#  image              :string
#  status             :boolean
#  is_available       :boolean          default(TRUE)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  category_id        :integer
#  material_id        :integer
#
# Indexes
#
#  index_dishes_on_category_id  (category_id)
#  index_dishes_on_material_id  (material_id)
#


class Dish < ApplicationRecord
    mount_uploader :image, ImageUploader

    # skip_callback :save, :before, :store_picture!
    before_validation :normal_dish_name

    belongs_to :category, optional: true
    has_many :order_details
    has_many :price_change_histories
    # has_many :dish_discounts
    # has_many :discount_days, through: :dish_discounts
    belongs_to :material, optional: true

    # index_name([Rails.env,base_class.to_s.pluralize.underscore].join('_'))
    # index_name("dish_dish")

    def self.search(query)
        __elasticsearch__.search(
            {
                query: {
                    multi_match: {
                        query: query,
                        fields: ['dish_name','dish_name_not_mark']
                    }
                }
            }
        )
    end

    def self.search_cutlery(keysearch)
        # where('lower(dish_name) LIKE ?', "%#{keysearch}%")
        Dish.search(keysearch)
    end

    def self.search_drinking(keysearch)
        # where('lower(dish_name) LIKE ?', "%#{keysearch}%")
        Dish.search(keysearch)
    end

    def self.search_by_phong(term)
        if term
            where('lower(dish_name) LIKE ?', "%#{term.downcase}%")
        end
    end

    def self.search_by_dish_name(term)
        if term
            where('lower(dish_name) LIKE ?', "%#{term.downcase}%")
        end
    end

    def self.search_by_dish_name_not_mark(term)
        if term
            where('lower(dish_name_not_mark) LIKE ?', "%#{term.downcase}%")
        end
    end

    def self.suggest_by_user(user_id)
        ActiveRecord::Base.connection.execute("SELECT order_details.dish_id, sum(order_details.quantity) sum_quantity FROM orders, dishes, order_details WHERE orders.id = order_details.order_id AND dishes.id = order_details.dish_id AND user_id = #{user_id} GROUP BY order_details.dish_id ORDER BY sum_quantity DESC FETCH FIRST 5 ROWS ONLY").to_json
    end

    private
    def normal_dish_name
        if self.dish_name
            self.dish_name_not_mark = self.dish_name.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').downcase.to_s
        end
    end
end
# Dish.import
