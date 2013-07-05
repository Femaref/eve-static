module EveStatic
  module Manipulate  
    def add_category_id(input)
      input.merge({ :categoryID => typeCategory(input[:typeID])[:categoryID]})
    end
    
    def add_category_ids(input)
      input.map { |i| add_category_id i }
    end
    
    def add_group_id(input)
      input.merge({ :groupID => typeGroup(input[:typeID])[:groupID]})
    end
    
    def add_group_ids(input)
      input.map { |i| add_group_id i }
    end
    
    def to_human(input)
      if input.is_a? Array
        output = input.map { |i| to_human(i) }
      elsif input.is_a? Hash
        if primitive?(input)
          output = add_category_id(input)
          output = add_group_id(input)
          output = output.merge({:categoryName => typeCategory(input[:typeID])[:categoryName]})
          output = output.merge({:groupName => typeGroup(input[:typeID])[:groupName]})
        else
          output = input.map do |k, v|
            if primitive?(v)
              [k, v]
            else
              [k, to_human(v)]
            end          
          end
          
          output = Hash[output]
        end
      else
        output = input
      end
      
      output
    end
    
    private
    def primitive?(input)
      return false if input.is_a?(Array)
      output = input.values.map { |i| i.is_a?(Array) || i.is_a?(Hash) }
      output = !output.reduce(:|)
    end
  end
end