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

end
