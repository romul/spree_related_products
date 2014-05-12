require 'spree_core'
require 'spree_related_products_hooks'

module SpreeRelatedProducts
  class Engine < Rails::Engine

    def self.activate

      Product.class_eval do
        has_many :relations, :as => :relatable

        def self.relation_types
          RelationType.where(:applies_to => self.name).order(:name)
        end

        relation_types.each do |rt|
          method_name = rt.name.downcase.gsub(" ", "_").pluralize
          define_method method_name do
            relations.where(:relation_type_id => rt.id).map(&:related_to).select {|product| product.deleted_at.nil? && product.available_on <= Time.now()}
          end unless new.respond_to?(method_name)
        end
      end

      Admin::ProductsController.class_eval do
        def related
          load_resource
          @relation_types = Product.relation_types
        end
      end

    end

    config.autoload_paths += %W(#{config.root}/lib #{config.root}/app/models/calculator)
    config.to_prepare &method(:activate).to_proc

  end
end