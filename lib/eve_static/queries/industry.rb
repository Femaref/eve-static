module EveStatic
  module Queries
    module Industry
      module ClassMethods
        def industry_time_generator(method, defaults = {}, &block)
          if !block_given?
            raise 'you need to supply a block to industry_time_generator'
          end
        
          define_method method do |type, opt = {}|
            params = defaults.merge(opt)
            typeID = coerce_industry_type(type)
          
            result = instance[:invBlueprintTypes].where(:blueprintTypeID => typeID).first
          
            block.call(result, params)
          end
        end
                  
        def research_time(base, skill, slot, implant)
          base * (1 - (0.05 * skill)) * slot * implant
        end
      end
    
    
      def self.included(klass)
      klass.extend(ClassMethods)
      
      klass.instance_eval do      
        industry_time_generator(:manufacture_time,  {
            :industry => 0.0,
            :implant_modifier => 1.0,
            :slot_modifier => 1.0,
            :pe => 0.0
          }) do |result, params|
            if params[:pe] >= 0
              pe = params[:pe].to_f/(1.0+params[:pe].to_f)
            else
              pe = params[:pe].to_f - 1.0
            end
            
            res = result[:productionTime] * ((1-(0.04*params[:industry])))*params[:implant_modifier]*params[:slot_modifier]
            res = res * ( 1.0 - ((result[:productivityModifier].to_f)/result[:productionTime].to_f) * pe)
            res.to_i
        end
        
        industry_time_generator(:material_research_time, {
          :metallurgy => 0.0,
          :implant_modifier => 1.0,
          :slot_modifier => 1.0
        }) do |result, params|
          research_time(result[:researchMaterialTime], params[:metallurgy], params[:slot_modifier], params[:implant_modifier]).to_i
        end
        
        industry_time_generator(:production_research_time, {
          :research => 0.0,
          :implant_modifier => 1.0,
          :slot_modifier => 1.0
        }) do |result, params|
          research_time(result[:researchProductivityTime], params[:research], params[:slot_modifier], params[:implant_modifier]).to_i
        end
        
        industry_time_generator(:copy_research_time, {
          :science => 0.0,
          :implant_modifier => 1.0,
          :slot_modifier => 1.0
        }) do |result, params|
          research_time(result[:researchCopyTime], params[:science], params[:slot_modifier], params[:implant_modifier]).to_i
        end
        end
      end
            
      def blueprint(type)
        typeID = coerce_type_id(type)
        
        instance[:invBlueprintTypes].where(:productTypeID => typeID).first
      end
      
      def product(type)
        typeID = coerce_type_id(type)
        
        instance[:invBlueprintTypes].where(:blueprintTypeID => typeID).select(Sequel.lit('productTypeID')).first[:productTypeID]
      end
    end
  end
end