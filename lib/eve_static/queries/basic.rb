module EveStatic
  module Queries
    module Basic
      def typeID(typeName)
        if !typeName.is_a?(String)
          raise "please supply typeName as a String"
        end
        
        instance[:invTypes].where(:typeName => typeName).select(Sequel.lit('typeID')).first[:typeID]
      end
      
      def typeName(typeID)
        if !typeID.is_a?(Integer)
          raise "please supply typeID as an Integer"
        end
        
        instance[:invTypes].where(:typeID => typeID).select(Sequel.lit('typeName')).first[:typeName]
      end
    end
  end
end