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

get '/project/:id' do
  @project = Project.find(params[:id])
  @volunteers = @project.volunteers
  erb(:project)
end

patch '/project/:id' do
  @project = Project.find(params[:id].to_i)
  @project.update({:title => params[:title], :id => nil})
  erb(:project)
end

get '/project/:id/edit' do
  @project = Project.find(params[:id].to_i)
  erb(:edit_project)
end
