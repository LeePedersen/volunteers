class Volunteer
  attr_accessor :name, :project_id, :id

  def initialize attributes
    @id = attributes.fetch :id
    @name = attributes.fetch :name
    @project_id = attributes.fetch :project_id
  end

  def == volunteer
    self.name.downcase.eql? volunteer.name.downcase
  end

  def self.all
    returned_volunteers = DB.exec "SELECT * FROM volunteers;"
    volunteers = []
    returned_volunteers.each do |volunteer|
      id = volunteer.fetch("id").to_i
      name = volunteer.fetch "name"
      project_id = volunteer.fetch "project_id"
      volunteers.push Volunteer.new({:id => id, :name => name, :project_id => project_id})
    end
    volunteers
  end

  def save
    result = DB.exec "INSERT INTO volunteers (name, project_id) VALUES ('#{name}', '#{project_id}') RETURNING id;"
    @id = result.first.fetch("id").to_i
  end

  def self.find(id)
    volunteer = DB.exec("SELECT * FROM volunteers WHERE id = #{id};").first
    id = volunteer.fetch("id").to_i
    name = volunteer.fetch "name"
    project_id = volunteer.fetch "project_id"
    Volunteer.new({:id => id, :name => name, :project_id => project_id})
  end

  def update(name)
    DB.exec("UPDATE volunteers SET name = '#{name}' WHERE id = #{@id};")
    volunteer = Volunteer.find(@id)
  end

  def delete
    DB.exec("DELETE FROM volunteers WHERE id = #{@id}")
  end
end
