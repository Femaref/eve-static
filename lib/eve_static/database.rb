module EveStatic
  class Database
    include EveStatic::Queries::Basic
    include EveStatic::Queries::Industry
    include EveStatic::Manipulate
    include EveStatic::Coerce
  
    def initialize(opt = {})
      defaults = {
        :adapter => 'mysql2'
      }
    
      @db = Sequel.connect(defaults.merge(opt))
    end
    
    def instance
      @db
    end
  end
end
