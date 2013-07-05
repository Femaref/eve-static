module EveStatic
  module Coerce
    def coerce_type_id(type)
      coerce_type(type)[:typeID]
    end
    
    def coerce_type_name(type)
      coerce_type(type)[:typeName]
    end
    
          
    def coerce_industry_type(type)      
      hash = coerce_type(type)
      
      typeID = hash[:typeID]
      typeName = hash[:typeName]
      
      if !(typeName =~ /.+Blueprint/)
        typeID = blueprint(typeID)[:blueprintTypeID]
      end
      
      typeID
    end
    
    private
    
    def coerce_type(type)
      if type.is_a? String
        hash = {
          :typeName => type,
          :typeID => typeID(type)
        }
      elsif type.is_a? Integer
        hash = {
          :typeName => typeName(type),
          :typeID => type
        }
      else
        raise "type needs to be either Integer or String"
      end
      
      hash
    end
  end
end