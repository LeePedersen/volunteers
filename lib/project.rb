class Project
  attr_accessor(:title, :id)

  def initialize(attributes)
    @id = attributes.fetch(:id)
    @title = attributes.fetch(:title)
  end

  def save
    result = DB.exec("INSERT INTO projects (name, id) VALUES ('#{name}', #{id}) RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def ==(project)
    self.title().downcase().eql?(project.title().downcase())
  end

  def self.all
    returned_projects = DB.exec("SELECT * FROM projects;")
    projects = []
    returned_projects.each do |project|
      id = project.fetch("id").to_i
      title = project.fetch("title")
      projects.push(Project.new({:id => id, :title => title}))
    end
    projects
  end

  def save
    result = DB.exec("INSERT INTO projects (title) VALUES ('#{title}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def self.find(id)
    project = DB.exec("SELECT * FROM projects WHERE id = #{id};").first
    id = project.fetch("id").to_i
    title = project.fetch("title")
    Project.new({:id => id, :title => title})
  end

  def volunteers
    volunteers = []
    returned_volunteers = DB.exec("SELECT * FROM volunteers WHERE project_id = #{@id}")
    returned_volunteers.each do |volunteer|
      id = volunteer.fetch "id"
      name = volunteer.fetch "name"
      volunteers.push(Volunteer.new({:id => id, :name => name, :project_id => @id}))
    end
    volunteers
  end

  def update(attributes)
    @id = attributes.fetch(:id).to_i
    @title = attributes.fetch(:title)
    DB.exec("UPDATE projects SET title = '#{@title}' WHERE id = #{@id};")
  end



end
