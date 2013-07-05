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
        
        result = instance[:invBlueprintTypes].where(:productTypeID => typeID).first
        result ||= instance[:invBlueprintTypes].where(:blueprintTypeID => typeID).first
        
        result
      end
      
      def product(type)
        typeID = coerce_type_id(type)
        
        instance[:invBlueprintTypes].where(:blueprintTypeID => typeID).select(Sequel.lit('productTypeID')).first[:productTypeID]
      end
      
      def materials(type, me = 0)
        typeID = coerce_industry_type(type)
        productTypeID = product(typeID)
        
        bp = blueprint(typeID)
                
        raw = raw_materials(productTypeID).to_a
        
        extra = extra_materials(typeID).to_a
        
        subtract = extra.select { |e| e[:recycle] }
        
        subtract = subtract.map do |s|
          raw_materials(s[:requiredTypeID]).to_a
        end
        
        subtract = subtract.flatten
        raw_hash = Hash[raw.map { |r| [ r[:materialTypeID], r ] }]
        
        subtract.each do |s|
          if raw_hash.keys.include? s[:materialTypeID]
            raw_hash[s[:materialTypeID]][:quantity] -= s[:quantity]
          end
        end
        
        raw = raw_hash.values
        raw = raw.select do |r|
          r[:quantity] > 0
        end       
        
        raw = raw.map { |r| r.merge({ :waste => waste(r[:quantity], bp[:wasteFactor], me) }) }
                
        { :raw => raw, 
          :extra => extra }
      end
      
      private
      
      def raw_materials(typeID)
        instance[:invTypeMaterials].where( :invTypeMaterials__typeID => typeID ).select(:materialTypeID, :quantity)
      end
      
      def extra_materials(typeID)
        instance[:ramTypeRequirements].where( :typeID => typeID ).where(:activityID => 1).select(:requiredTypeID, :quantity, :damagePerJob, :recycle)
      end
      
      def waste(base, base_waste, me)
        if me >= 0
          me = (1.0/(me + 1.0))
        else
          me = (1.0 - me)
        end
      
        result = base * (base_waste.to_f/100.0) * me
        result.to_i
      end
    end
  end
end