require_relative '../exceptions/not_found_exception'
require_relative '../exceptions/configuration_exception'
require_relative '../values/project'
require_relative '../services/get_jenkins_projects'
require_relative '../services/build_scm'
require_relative '../util/settings'

module GitlabWebHook
  class CreateProjectForBranch
    include Settings

    def initialize(get_jenkins_projects = GetJenkinsProjects.new, build_scm = BuildScm.new)
      @get_jenkins_projects = get_jenkins_projects
      @build_scm = build_scm
    end

    def with(details)
      copy_from = get_project_to_copy_from(details)
      new_project_name = get_new_project_name(copy_from, details)
      new_project_scm = @build_scm.with(copy_from.scm, details)

      # TODO: set github url, requires github plugin reference
      branch_project = Java.jenkins.model.Jenkins.instance.copy(copy_from.jenkins_project, new_project_name)
      branch_project.scm = new_project_scm
      branch_project.makeDisabled(false)
      branch_project.description = settings.description
      branch_project.save

      Project.new(branch_project)
    end

    private

    def get_project_to_copy_from(details)
      master_not_found_message = 'could not determine master project, please create a project for the repo (usually for the master branch)'
      @get_jenkins_projects.master(details) || raise(NotFoundException.new(master_not_found_message))
    end

    def get_new_project_name(copy_from, details)
      new_project_name = "#{settings.use_master_project_name? ? copy_from.name : details.repository_name}_#{details.safe_branch}"
      raise ConfigurationException.new("project #{new_project_name} already exists") unless @get_jenkins_projects.named(new_project_name).empty?
      new_project_name
    end
  end
end
