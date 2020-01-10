class Volunteer
  attr_accessor :name, :project_id, :id

  def initialize attributes
    @id = attributes.fetch :id
    @name = attributes.fetch :name
    @project_id = attributes.fetch :project_id
  end

end
