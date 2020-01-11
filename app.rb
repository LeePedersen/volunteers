require('sinatra')
require('sinatra/reloader')
require('./lib/project')
require('./lib/volunteer')
require('pry')
require("pg")
also_reload('lib/**/*.rb')


DB = PG.connect({:dbname => "volunteer_tracker"})


get '/' do
  @projects = Project.all
  erb(:projects)
end

post '/projects' do
  title = params[:title]
  project = Project.new(:title => title, :id => nil)
  project.save
  @projects = Project.all
  erb(:projects)
end

get '/projects/:id' do
  @project = Project.find(params[:id])
  @volunteers = @project.volunteers
  erb(:project)
end

patch '/projects/:id' do
  @project = Project.find(params[:id].to_i)
  @project.update({:title => params[:title], :id => nil})
  erb(:project)
end

get '/projects/:id/edit' do
  @project = Project.find(params[:id].to_i)
  erb(:edit_project)
end

delete '/projects/:id' do
  @project = Project.find(params[:id])
  @project.delete
  @projects = Project.all
  erb(:projects)
end

post '/projects/:id/add_volunteer' do
  binding.pry
  @volunteer = Volunteer.new({:id => nil, :name => params[:name], :project_id => params[:id].to_i})
  @volunteer.save
  @project = Project.find(params[:id].to_i)
  erb(:project)
end

get '/volunteers/:id' do
  @volunteer = Volunteer.find(params[:id])
  erb(:volunteer)
end

patch '/volunteers/:id' do
  @volunteer = Volunteer.find(params[:id])
  @volunteer = @volunteer.update(params[:name])
  @volunteers = Volunteer.all
  erb(:volunteers)
end
