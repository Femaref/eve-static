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
      
      def groupName(groupID)
        instance[:invGroups].where(:groupID => groupID).select(Sequel.lit('groupName')).first[:groupName]
      end
      
      def groupID(groupName)
        instance[:invGroups].where(:groupName => groupName).select(Sequel.lit('groupID')).first[:groupID]
      end
      
      def typeGroup(type)
        typeID = coerce_type_id(type)
        
        instance[:invTypes].inner_join(:invGroups, :groupID => :groupID).where(:typeID => typeID).select_all(:invGroups).first
      end
      
      def categoryName(categoryID)
        instance[:invCategories].where(:categoryID => categoryID).select(Sequel.lit('categoryName')).first[:categoryName]
      end
      
      def categoryID(categoryName)
        instance[:invCategories].where(:categoryName => categoryName).select(Sequel.lit('categoryID')).first[:categoryID]
      end
      
      def typeCategory(type)
        typeID = coerce_type_id(type)
        
        instance[:invTypes].inner_join(:invGroups, :groupID => :groupID).inner_join(:invCategories, :categoryID => :categoryID).where(:typeID => typeID).select_all(:invCategories).first
      end
      
    end
  end
end