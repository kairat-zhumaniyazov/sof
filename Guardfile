scope groups: ['specs']

group 'specs' do
  guard :rspec, cmd: "bundle exec spring rspec" do
    require "guard/rspec/dsl"
    dsl = Guard::RSpec::Dsl.new(self)

    # Feel free to open issues for suggestions and improvements

    # RSpec files
    rspec = dsl.rspec
    watch(rspec.spec_helper) { rspec.spec_dir }
    watch(rspec.spec_support) { rspec.spec_dir }
    watch(rspec.spec_files)

    # Ruby files
    ruby = dsl.ruby
    dsl.watch_spec_files_for(ruby.lib_files)

    # Rails files
    rails = dsl.rails(view_extensions: %w(erb haml slim))
    dsl.watch_spec_files_for(rails.app_files)
    dsl.watch_spec_files_for(rails.views)

    watch(rails.controllers) { |m| rspec.spec.("controllers/#{m[1]}_controller") }

    # Rails config changes
    watch(rails.spec_helper)     { rspec.spec_dir }
    watch(rails.routes)          { "#{rspec.spec_dir}/controllers" }
    watch(rails.app_controller)  { "#{rspec.spec_dir}/controllers" }

    # Capybara features specs
    watch(rails.view_dirs)     { |m| rspec.spec.("features/#{m[1]}") }
    watch(rails.layouts)       { |m| rspec.spec.("features/#{m[1]}") }

    # Turnip features and steps
    watch(%r{^spec/acceptance/(.+)\.feature$})
    watch(%r{^spec/acceptance/steps/(.+)_steps\.rb$}) do |m|
      Dir[File.join("**/#{m[1]}.feature")][0] || "spec/acceptance"
    end
  end

  guard 'spring', bundler: true do
    watch('Gemfile.lock')
    watch(%r{^config/})
    watch(%r{^spec/(support|factories)/})
  end

  guard :bundler do
    require 'guard/bundler'
    require 'guard/bundler/verify'
    helper = Guard::Bundler::Verify.new

    files = ['Gemfile']
    files += Dir['*.gemspec'] if files.any? { |f| helper.uses_gemspec?(f) }

    # Assume files are symlinked from somewhere
    files.each { |file| watch(helper.real_path(file)) }
  end
end

group 'rails' do
  # Guard-Rails supports a lot options with default values:
  # daemon: false                        # runs the server as a daemon.
  # debugger: false                      # enable ruby-debug gem.
  # environment: 'development'           # changes server environment.
  # force_run: false                     # kills any process that's holding the listen port before attempting to (re)start Rails.
  # pid_file: 'tmp/pids/[RAILS_ENV].pid' # specify your pid_file.
  # host: 'localhost'                    # server hostname.
  # port: 3000                           # server port number.
  # root: '/spec/dummy'                  # Rails' root path.
  # server: thin                         # webserver engine.
  # start_on_start: true                 # will start the server when starting Guard.
  # timeout: 30                          # waits untill restarting the Rails server, in seconds.
  # zeus_plan: server                    # custom plan in zeus, only works with `zeus: true`.
  # zeus: false                          # enables zeus gem.
  # CLI: 'rails server'                  # customizes runner command. Omits all options except `pid_file`!

  guard 'rails' do
    watch('Gemfile.lock')
    watch(%r{^(config|lib)/.*})
  end
end
